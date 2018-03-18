console.log 'hello from site.coffee'
console.log 'hello again from site.coffee'

myfunc = ->
  new Promise (resolve) ->
    a = 0
    console.log 'hello from inside myfunc.'
    resolve()

myfunc2 = ->
  await myfunc()
  console.log 'hello form inside myfunc2'

myfunc2()
