console.log 'hello from site.coffee'
console.log 'hello again from site.coffee'

myfunc = ->
  new Promise (resolve) ->
    console.log 'hello from inside myfunc.'
    resolve()

myfunc2 = ->
  await myfunc()
  console.log 'hello from inside myfunc2'

myfunc2()

# Next line is an intentional syntax error for testing.
#var b = 2
