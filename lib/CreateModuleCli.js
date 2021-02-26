const { config } = require("./utils/helperUtil");
const Console = require("./utils/Console");
const FileCopy = require("./utils/FileCopy");
const inquirer = require("inquirer");

class CreateModuleCli {
	constructor() {
		this.logger = Console;
	}
	/**
	 * 运行脚手架的主入口
	 */
	async run() {
		this.logger.success(JSON.stringify(this.getConfig()));
		const { templateDir, targetDir, enabledReplaceSuffix } = this.getConfig();
		const options = await inquirer.prompt([
			{
				type: "input", // 问题类型
				name: "modulePath", // 数据属性名
				message: "模块名称", // 提示信息
				validate: (modulePath) => {
					if (modulePath && modulePath.endsWith("/")) {
						return "模块名称不能以【/】结束.";
					} else if (!modulePath) {
						return "模块名称未填写.";
					}
					if (modulePath) {
						if (modulePath.endsWith("/")) {
							return "模块名称不能以【/】结束.";
						}
						if (modulePath.startsWith("/")) {
							return "模块名称不能以【/】开始.";
						}
						if (modulePath.includes("./") || modulePath.includes("../")) {
							return "模块名称暂不支持【../】【./】.";
						}
					} else {
						return "模块名称未填写.";
					}
					return true;
				},
			},
		]);
		const { modulePath } = options;
		const deep = modulePath.split("/").length - 1;
		this.logger.info(`deep:${deep}`);
		const moduleDir = `${targetDir}/${modulePath}`;
		const fileCopy = new FileCopy(templateDir, moduleDir, {
			deep,
			enabledReplaceSuffix,
		});
		if (!fileCopy.existTargetFolder()) {
			fileCopy.copy();
		} else {
			this.logger.error("模块已经存在, 创建模块失败!");
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
