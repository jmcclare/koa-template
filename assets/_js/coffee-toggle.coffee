
# A proof of concept implementation of toggle.jsx in CoffeeScript.

import React from 'react'
import ReactDOM from 'react-dom'


class Toggle extends React.Component
  constructor: (props) ->
    super(props)
    this.state = {isToggleOn: true}

  handleClick: () =>
    this.setState (prevState) =>
      isToggleOn: !prevState.isToggleOn

  render: () ->
    return (
      <button onClick={this.handleClick}>
        {if this.state.isToggleOn then 'ON' else 'OFF'}
      </button>
    )

export default Toggle
