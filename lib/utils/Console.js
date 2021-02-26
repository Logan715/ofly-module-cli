const chalk = require("chalk");
const globalConfig = require("../global");
const Console = function (...arg) {
	globalConfig.getConfig(globalConfig.KEY.PRINT) &&
		console.log.apply(null, arg);
};

module.exports = {
	error: (val) => console.error(`[create-module-cli] ${chalk.red(val)}`),
	warn: (val) =>
		globalConfig.getConfig(globalConfig.KEY.PRINT) &&
		console.warn(`[create-module-cli] ${chalk.yellow(val)}`),
	info: (val) =>
		globalConfig.getConfig(globalConfig.KEY.PRINT) &&
		console.info(`[create-module-cli] ${chalk.cyan(val)}`),
	success: (val) => console.log(`[create-module-cli] ${chalk.green(val)}`),
	log: (val) =>
		globalConfig.getConfig(globalConfig.KEY.PRINT) &&
		console.log(`[create-module-cli] ${val}`),
	raw: (val) =>
		globalConfig.getConfig(globalConfig.KEY.PRINT) && console.log(val),
};
