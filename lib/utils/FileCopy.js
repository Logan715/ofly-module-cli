const fs = require("fs-extra");
const path = require("path");
const ora = require("ora");
class FileCopy {
	templatePath = "";
	targetPath = "";
	camelCaseModule = "";
	upperUnderlineModule = "";
	options = {
		deep: 0,
		enabledReplaceSuffix: [],
	};
	fileSize = 0;
	indexFile = 0;
	constructor(from, to, options) {
		const arr = to.split("/");
		const moduleName = arr[arr.length - 1];
		this.templatePath = from;
		this.targetPath = to;

		this.camelCaseModule = this.toCamelCaseModule(moduleName);
		this.upperUnderlineModule = this.toUpperUnderline(this.camelCaseModule);

		this.options = options;
		this.fileSize = this.getFileSize(this.templatePath);
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
		
		const enabledReplace = this.options.enabledReplaceSuffix.map(suffix=>`${suffix}${this.options.templateSuffix}`).some((suffix) =>
			fromPath.endsWith(suffix)
		);
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
				fs.ensureDirSync(path.join(toPath, file.name));
				this.copyDirection(
					path.join(fromPath, file.name),
					path.join(toPath, file.name),
					fileDeep + 1
				);
			} else {
				let toFileName = file.name.endsWith(this.options.templateSuffix)?
				file.name.substr(0, file.name.length-this.options.templateSuffix.length):
				file.name;
				this.copyFile(
					path.join(fromPath, file.name),
					path.join(toPath, toFileName),
					fileDeep
				);
			}
		});
	}
	contentReplace(content, fileDeep) {
		let tempContent = content;
		if (this.options.deep) {
			const insertStr = Array(this.options.deep + 1).join("../");
			const stepLength = insertStr.length;
			// const reg = new RegExp(`[\\'|\\"]\\./|[\\'|\\"]\\.\\./`, "g");
			// const reg = new RegExp(`[\\'|\\"]\\./(\\.\\./){${fileDeep}}`, "g");
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
		const replaces = {
			camelCaseModule: this.camelCaseModule,
			upperUnderlineModule: this.upperUnderlineModule,
		};
		Object.keys(replaces).map((key) => {
			const reg = new RegExp(`\\$\{${key}}`, "g");
			tempContent = tempContent.replace(reg, replaces[key]);
		});

		return tempContent;
	}

	existTargetFolder() {
		return fs.existsSync(this.targetPath);
	}
	getFileSize(templatePath = this.templatePath) {
		const arr = fs.readdirSync(templatePath, { withFileTypes: true });
		let size = 0;
		arr.forEach((file) => {
			if (file.isDirectory()) {
				size += this.getFileSize(path.join(templatePath, file.name));
			} else {
				size += 1;
			}
		});
		return size;
	}
	toCamelCaseModule(moduleName) {
		return moduleName.slice(0, 1).toLowerCase() + moduleName.slice(1);
	}
	toUpperUnderline(camelCaseModule) {
		const reg = new RegExp("[A-Z]");
		return camelCaseModule
			.split("")
			.map((c) => (reg.test(c) ? "_" + c : c))
			.join("")
			.toUpperCase();
	}
}

module.exports = FileCopy;
