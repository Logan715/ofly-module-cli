const KEY = {
	PRINT: "PRINT",
};
class GlobalConfig {
	config = {};
	KEY = KEY;
	setConfig = (key, value) => {
		this.config = {
			...this.config,
			[key]: value,
		};
	};
	getConfig = (key) => {
		return this.config[key];
	};
}

const globalConfig = new GlobalConfig();
module.exports = globalConfig;
