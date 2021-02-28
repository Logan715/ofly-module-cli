const fs = require("fs-extra");
const path = require("path");
const ora = require("ora");
class FileCopy {
	templatePath = "";
	targetPath = "";
	options = {
		deep: 0,
		enabledReplaceSuffix: [],
	};
	fileSize = 0;
	indexFile = 0;
	constructor(from, to, options) {
		this.templatePath = from;
		this.targetPath = to;
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
	copyFile(fromPath, toPath) {
		const content = fs.readFileSync(fromPath);
		let newContent = content;
		if (this.options.deep) {
			const enabledReplace = this.options.enabledReplaceSuffix.some((suffix) =>
				fromPath.endsWith(suffix)
			);
			if (enabledReplace) {
				newContent = this.contentReplace(content.toString());
			}
		}

		fs.writeFileSync(toPath, newContent);
		this.indexFile += 1;
		this.spinner.text = `copying: (${this.indexFile}|${this.fileSize})`;
	}

	copyDirection(fromPath, toPath) {
		const arr = fs.readdirSync(fromPath, { withFileTypes: true });
		arr.forEach((file) => {
			if (file.isDirectory()) {
				fs.ensureDirSync(path.join(toPath, file.name));
				this.copyDirection(
					path.join(fromPath, file.name),
					path.join(toPath, file.name)
				);
			} else {
				this.copyFile(
					path.join(fromPath, file.name),
					path.join(toPath, file.name)
				);
			}
		});
	}
	contentReplace(content) {
		const insertStr = Array(this.options.deep + 1).join("../");
		const stepLength = insertStr.length;
		let tempContent = content;
		const reg = new RegExp(`[\\'|\\"]\\./|[\\'|\\"]\\.\\./`, "g");
		let match = undefined;
		let step = 0;
		while ((match = reg.exec(content))) {
			const matchStr = match[0];
			const index = step + match["index"] + matchStr.length;
			tempContent =
				tempContent.slice(0, index) + insertStr + tempContent.slice(index);
			step += stepLength;
		}
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
}

module.exports = FileCopy;
