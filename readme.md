<h1 align="center">Module-Cli</h1>

## 安装

```shell
npm i -D @ofly/module-cli
```

## 使用

```sh
npx create-module-cli
```



## 介绍

该插件是定制自己的模板后， 然后用来搬迁代码。从而减少代码的编写。



### 1. 配置文件 `.tcp.config.js`

```javascript
const path = require("path");

module.exports = {
	/**
	 * 模版目录
	 */
	templateDir: '自己定义文件夹',
	/**
	 * 模版拷贝的目标
	 */
	moduleDir: path.resolve("./src"),
	/**
	 * 可替换文件后缀
	 */
	enabledReplaceSuffix: [".vue", ".js", ".jsx", ".ts", ".tsx", ".json"],
};
```

`templateDir`: 模版目录

`moduleDir`: 模版拷贝的目标

`enabledReplaceSuffix`: 可替换文件后缀

### 2. 命令行 命令

```sh
npx @ofly/create-module-cli -h
```

```shell
Usage: create-module-cli [options]

Options:
  -V, --version      output the version number
  --config <config>  配置文件的地址, 默认读取根目录下的.tcp.config.js
  --verbose          打印比较详细的提示信息
  -h, --help         display help for command
```

