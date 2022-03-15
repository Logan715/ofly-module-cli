const fs = require("fs-extra");
const path = require("path");
const ora = require("ora");
const os = require('os')
const Console = require("./Console");
const { Mode } = require("./helperUtil");

class FileCopy {
	templatePath = "";
	targetPath = "";
	options = {
		mode: "module",
		deep: 0,
		enabledReplaceSuffix: [],
		replaceObject: {},
		excludeReplace: [],
	};
	fileSize = 0;
	indexFile = 0;
	constructor(from, to, options) {
		this.logger = Console;
		this.templatePath = from;
		this.targetPath = to;
		this.options = options;
		this.fileSize = this.getFileNumbers(this.templatePath);
		this.spinner = ora(`copying: (${this.indexFile}|${this.fileSize})`);
	}
	copy() {
		this.spinner.start();
		fs.ensureDirSync(this.targetPath);
		this.copyDirection(
			path.join(this.templatePath),
			path.join(this.targetPath)
		);
		this.spinner.succeed("copy success");
	}
	copyFile(fromPath, toPath, fileDeep) {
		const content = fs.readFileSync(fromPath);
		let newContent = content;
		const enabledReplace = 
			this.options.enabledReplaceSuffix.
			map(suffix=>this.options.mode === Mode.MODULE?`${suffix}${this.options.templateSuffix}`:suffix).
			some((suffix) =>fromPath.endsWith(suffix)) && 
			!this.options.excludeReplace.some(name=> fromPath.endsWith(name))
			;

		if (enabledReplace) {
			newContent = this.contentReplace(content.toString(), fileDeep);
		}
		fs.writeFileSync(toPath, newContent);
		this.indexFile += 1;
		this.spinner.text = `copying: (${this.indexFile}|${this.fileSize})`;
	}

	copyDirection(fromPath, toPath, fileDeep = 0) {
		const arr = fs.readdirSync(fromPath, { withFileTypes: true });
		arr.forEach((file) => {
			if (file.isDirectory()) {
				fs.ensureDirSync(path.join(toPath, this.fileNameReplace(file.name, true)));
				this.copyDirection(
					path.join(fromPath, file.name),
					path.join(toPath, this.fileNameReplace(file.name, true)),
					fileDeep + 1
				);
			} else {
				this.copyFile(
					path.join(fromPath, file.name),
					path.join(toPath, this.fileNameReplace(file.name)),
					fileDeep
				);
			}
		});
	}
	fileNameReplace(fileName, folder = false) {
		let _fileName = fileName
		if(this.options.mode === Mode.MODULE) {
			const matchArray = Object.keys(this.options.replaceObject)
			.filter(key=> fileName.includes(key))
			.sort((a,b)=> b.length - a.length);
			if(matchArray.length) {
				_fileName = fileName.replace(matchArray[0], this.options.replaceObject[matchArray[0]])
			}
			if(folder) {
				return _fileName;
			} 
			return _fileName.substr(0, _fileName.length-this.options.templateSuffix.length)
		} else {
			if(folder) {
				return fileName
			}
			return `${fileName}${this.options.templateSuffix}`
		}
	}
	contentReplace(content, fileDeep) {
		let tempContent = content;
		if (this.options.deep) {
			const insertStr = Array(this.options.deep + 1).join("../");
			const stepLength = insertStr.length;
			const reg = new RegExp(
				`[\\'|\\"](\\./){0,1}(\\.\\./){${fileDeep + 1}}`,
				"g"
			);
			let match = undefined;
			let step = 0;
			while ((match = reg.exec(content))) {
				const matchStr = match[0];
				const index = step + match["index"] + matchStr.length;
				tempContent =
					tempContent.slice(0, index) + insertStr + tempContent.slice(index);
				step += stepLength;
			}
		}

		Object.keys(this.options.replaceObject).map((key) => {
			let reg = undefined;
			if(this.options.mode === Mode.MODULE) {
				if(os.platform().indexOf('win')===0) {
					reg = new RegExp(`\\$\{${key}}`, "g");
				} else {
					reg = new RegExp(`\\\$\{${key}}`, "g");
				}
				tempContent = tempContent.replace(reg, this.options.replaceObject[key]);
			} else {
				if(os.platform().indexOf('win')===0) {
					reg = new RegExp(`${key}`, "g");
				} else {
					reg = new RegExp(`${key}`, "g");
				}
				tempContent = tempContent.replace(reg, `\${${key}}`);
			}
			
		});

		return tempContent;
	}

	existTargetFolder() {
		return fs.existsSync(this.targetPath);
	}
	getFileNumbers(templatePath = this.templatePath) {
		const arr = fs.readdirSync(templatePath, { withFileTypes: true });
		let numbers = 0;
		arr.forEach((file) => {
			if (file.isDirectory()) {
				numbers += this.getFileNumbers(path.join(templatePath, file.name));
			} else {
				numbers += 1;
			}
		});
		return numbers;
	}
}

module.exports = FileCopy;
