const globalConfig = require("../global");
const { program } = require("commander");
const path = require("path");
const innerConfig = require("../tcp.config.js");
const { deepObjectCopy } = require("./deepObjectCopy");
const Console = require("./Console");

const version = require("../../package.json").version;
program.version(version);
program
	.option(
		"--config <config>",
		"配置文件的地址, 默认读取根目录下的.tcp.config.js"
	)
	.option("--verbose", "打印比较详细的提示信息")
	.option('-r, --reverse', "是否由模块生成模板")
	.option('-d, --debug', 'output extra debugging')
	.parse(process.argv);
const options = program.opts();

const { config, verbose, reverse } = options;

globalConfig.setConfig(
	globalConfig.KEY.PRINT,
	process.env.NODE_ENV === "development" ? true : verbose
	);
// 1.设置提示信息
Console.info(`内置配置${reverse}: ${JSON.stringify(innerConfig)}`);
let outerConfig = {};
if (config) {
	Console.info(`外部配置地址: ${path.resolve(config)}`);
	outerConfig = require(path.resolve(config));
} else {
	try {
		outerConfig = require(path.resolve(".tcp.config.js"));
	} catch (e) {
		Console.info("未配置外部.tcp.config.js, 按照默认配置进行");
	}
}

Console.info(`外部配置: ${JSON.stringify(outerConfig)}`);
let finalConfig = deepObjectCopy(innerConfig, outerConfig);
Console.info(`finalConfig: ${JSON.stringify(finalConfig)}`);

const Mode = {
	TEMPLATE: 'template',
	MODULE: 'module'
}


module.exports = {
	config: finalConfig,
	mode: reverse?Mode.TEMPLATE: Mode.MODULE,
	Mode
};
