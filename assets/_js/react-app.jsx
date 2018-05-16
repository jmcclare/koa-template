
//
// This file is a pure JSX entry point compiled by WebPack.
//
// It’s mainly a proof of concept. It’s not necessary unless you really want to
// program every bit of your React app in JSX because you can import and use
// JSX files from the front end CoffeeScript in this project. XML elements
// interspersed in front end CoffeeScript files will be transpiled to React
// function calls in JavaScript, so you can write your React apps entirely in
// CoffeeScript.
//

import React from 'react'
import ReactDOM from 'react-dom'

import Swiggity from './swiggity'
import Toggle from './toggle'
import TicTacToe from './tic-tac-toe'

console.log('Console message from react-app.jsx')

//ReactDOM.render(
  //<Swiggity />,
  //document.getElementById('react-test')
//)

//ReactDOM.render(
  //<Toggle />,
  //document.getElementById('react-test')
//)

ReactDOM.render(
  <TicTacToe />,
  document.getElementById('tic-tac-toe')
)
