import dummy from './dummy-module'
import React from 'react'
import ReactDOM from 'react-dom'
import Swiggity from './swiggity'
import Toggle from './coffee-toggle'

console.log 'hello from site.coffee'

myfunc = ->
  new Promise (resolve) ->
    console.log 'hello from inside myfunc in site.coffee.'
    resolve()

myfunc2 = ->
  await myfunc()
  console.log 'hello from inside myfunc2 in site.coffee'

myfunc2()

# Next line is an intentional syntax error for testing.
#var b = 2

dummy()


# Attach and render the sample Toggle React app only if the #toggle element is
# present to avoid errors in the browser console.
#
# Note it is best to import everything related to a React app in a separate
# CoffeeScript file and only link that file on the pages where the React app is
# used.
if document.getElementById 'toggle'
  # You can use React components imported from regular .jsx files too.
  #ReactDOM.render(
    #<Swiggity />,
    #document.getElementById('toggle')
  #)

  ReactDOM.render(
    <Toggle />,
    document.getElementById('toggle')
  )
