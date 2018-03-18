path = require('path')
url = require('url')
coffeeScript = require('coffeescript')
updateSyntaxError = require('coffeescript/lib/coffeescript/helpers').updateSyntaxError
fs = require('fs')


mwGenerator = (opt) ->
  if !opt.src
    throw new Error('You should specify the source directory (src) for koa-coffeescript')

  if !opt.dst
    opt.dst = opt.src

  if !opt.compileOpt
    opt.compileOpt = {}

  return (ctx, next) ->
    await compile(ctx, opt)
    await next()


# TODO: If there is already a destination file, make this compare the file
# times of the source and destination and skip reading, compiling and writing
# if the destination has the same time or newer. Right now this is only useful
# in development because it does these things on every request.
compile = (ctx, opt) ->
  pathname = url.parse(ctx.url).pathname

  if /\.js$/.test(pathname)
    compiledFilePath = path.join(opt.dst, pathname)
    filePath = compiledFilePath.replace(/\.js$/, '.coffee')
    filePath = filePath.replace(opt.dst, opt.src)

    fs.readFile filePath, 'utf8', (err, file) =>
      if err
        throw err

      try
        await compiledFile = coffeeScript.compile(file, opt.compileOpt)
      catch err
        updateSyntaxError(err, null, filePath)
        throw err

      fs.writeFile compiledFilePath, compiledFile, (err) =>
        if err
          throw err


export default mwGenerator
