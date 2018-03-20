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
    #try
      #compile(ctx, opt)
    #catch err
      #return next err
    #next()

    #console.log "ctx.url: #{ctx.url}"

    return compile ctx, opt, (err) ->
      if err
        #console.log('server error', err, ctx)
        return next err
        #throw err
      return next()


# TODO: If there is already a destination file, make this compare the file
# times of the source and destination and skip reading, compiling and writing
# if the destination has the same time or newer. Right now this is only useful
# in development because it does these things on every request.
compile = (ctx, opt, cb) ->
  pathname = url.parse(ctx.url).pathname

  if /\.js$/.test(pathname)
    compiledFilePath = path.join(opt.dst, pathname)
    filePath = compiledFilePath.replace(/\.js$/, '.coffee')
    filePath = filePath.replace(opt.dst, opt.src)


    # Compare the file modification times.
    return fs.stat filePath, (err, fileStat) ->
      if err
        if err.code == 'ENOENT'
          # No matching .coffee file in the src directory for this .js file.
          # Nothing needs to be done here.
          return cb()
        else
          return cb err

      fs.stat compiledFilePath, (err, compFileStat) ->
        if err
          if err.code == 'ENOENT'
            # Compiled .js file does not exist yet. No need to compare times.
            # Do the compilation..
            return doCompile filePath, compiledFilePath, opt, cb
          else
            return cb err

        if fileStat.mtime > compFileStat.mtime
          # The source file is newer than the compiled .js file. Do the
          # compilation.
          return doCompile filePath, compiledFilePath, opt, cb
        else
          return cb()

  else
    return cb()


# This final step where we actually perform the compilation, after verifying
# that we need to.
doCompile = (filePath, compiledFilePath, opt, cb) ->
  fs.readFile filePath, 'utf8', (err, file) =>
    if err
      #throw err
      #console.log err
      return cb err

    try
      compiledFile = coffeeScript.compile(file, opt.compileOpt)
    catch err
      updateSyntaxError(err, null, filePath)
      #throw err
      #console.log err
      return cb err

    fs.writeFile compiledFilePath, compiledFile, (err) =>
      if err
        #throw err
        #console.log err
        return cb err


export default mwGenerator
