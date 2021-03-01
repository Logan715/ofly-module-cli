const path = require("path");

module.exports = {
	/**
	 * 模版目录
	 */
	templateDir: path.resolve(
		require.resolve("./tcp.config.js"),
		"../..",
		".template"
	),
	/**
	 * 模版拷贝的目标
	 */
	targetDir: path.resolve("./src"),
	/**
	 * 可替换文件后缀
	 */
	enabledReplaceSuffix: [".vue", ".js", ".jsx", ".ts", ".tsx", ".json"],
	
};
