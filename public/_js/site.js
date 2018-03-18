'use strict';

var myfunc, myfunc2;

console.log('hello from site.coffee');

console.log('hello again from site.coffee');

myfunc = function myfunc() {
  return new Promise(function (resolve) {
    var a;
    a = 0;
    console.log('hello from inside myfunc.');
    return resolve();
  });
};

myfunc2 = async function myfunc2() {
  await myfunc();
  return console.log('hello form inside myfunc2');
};

myfunc2();