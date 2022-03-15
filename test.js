
const os = require('os')
let reg = undefined;
const str = "${Focus}"
if(os.platform().indexOf('win')===0) {
  reg = new RegExp(`\\$\{Focus}`, "g");
} else {
  reg = new RegExp(`\\\$\{Focus}`, "g");
}