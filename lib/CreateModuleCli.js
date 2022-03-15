const { config, mode, Mode } = require("./utils/helperUtil");
const Console = require("./utils/Console");
const FileCopy = require("./utils/FileCopy");

class CreateModuleCli {
	constructor() {
		this.logger = Console;
	}
	/**
	 * 运行脚手架的主入口
	 */
	async run() {
		this.logger.success(JSON.stringify(this.getConfig()));
		this.logger.success(mode);
		const { templateDir, moduleDir, enabledReplaceSuffix, templateSuffix, excludeReplace, tconfig } = this.getConfig();
		let replaceObject = undefined;
		if(mode === Mode.TEMPLATE) {
			try {
				replaceObject = await require(`${moduleDir}/.tconfig.json`);
			} catch(e) {
				this.logger.error(`未找到[${`${moduleDir}/.tconfig.json`}]配置文件`);
				return
			}
			const fileCopy = new FileCopy(moduleDir, templateDir, {
				mode,
				replaceObject,
				enabledReplaceSuffix,
				templateSuffix,
				excludeReplace
			});
			if (!fileCopy.existTargetFolder()) {
				fileCopy.copy();
			} else {
				this.logger.error("模块已经存在, 创建模块失败!");
			}
		} else {
			replaceObject = tconfig;
			const fileCopy = new FileCopy(templateDir, moduleDir, {
				mode,
				replaceObject,
				enabledReplaceSuffix,
				templateSuffix,
				excludeReplace
			});
			if (!fileCopy.existTargetFolder()) {
				fileCopy.copy();
			} else {
				this.logger.error("模块已经存在, 创建模块失败!");
				}
		}
		
	}
	/**
	 * 获取配置信息
	 */
	getConfig() {
		return config;
	}
}

module.exports = CreateModuleCli;
