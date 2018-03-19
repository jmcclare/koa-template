import path from 'path'
import url from 'url'
import coffeeScript from 'coffeescript'
import coffeeHelpers from 'coffeescript/lib/coffeescript/helpers'
updateSyntaxError = coffeeHelpers.updateSyntaxError
import fs from 'fs'


mwGenerator = (opt) ->
  if !opt.src
    throw new Error('You should specify the source directory (src) for koa-coffeescript')

  if !opt.dst
    opt.dst = opt.src

  if !opt.compileOpt
    opt.compileOpt = {}

  return (ctx, next) ->
    # NOTE: This try / catch statement is pointless because I cannot throw
    # errors from within compile without crashing the process.
    try
      compile(ctx, opt)
    catch err
      return next err
    next()


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

    # TODO: Find out why throwing an error from inside the fs.readFile callback
    # crashes the whole process. For now, I can log an error to console, but I
    # may not want to do that in production. I’d rather pass it on to the
    # next() function and let the appropriate middleware handle it.
    fs.readFile filePath, 'utf8', (err, file) =>
      if err
        if err.code == 'ENOENT'
          # No matching .coffee file in the src directory for this .js file.
          # Nothing needs to be done here.
          return
        else
          #throw err
          console.log err
          return

      try
        compiledFile = coffeeScript.compile(file, opt.compileOpt)
      catch err
        updateSyntaxError(err, null, filePath)
        #throw err
        console.log err
        return

      fs.writeFile compiledFilePath, compiledFile, (err) =>
        if err
          #throw err
          console.log err
          return


export default mwGenerator
