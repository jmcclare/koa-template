import React from 'react'
import ReactDOM from 'react-dom'

import Swiggity from './swiggity'
import Toggle from './toggle'

console.log('Console message from react-app.jsx')

//ReactDOM.render(
  //<Swiggity />,
  //document.getElementById('react-test')
//)

ReactDOM.render(
  <Toggle />,
  document.getElementById('react-test')
)
