getRandomInt = (max)->
  return Math.floor(Math.random() * Math.floor(max))


class CacheBuster
  constructor: (@staticDir) ->
    @cachedIDs = {}

    # Pug needs to be able to call these class methods without referencing the
    # object instance after we pass them as filter methods.
    this.link = this.link.bind this

  link: (text, options) ->
    # TODO: generate id for href based on local file date.
    # TODO: iterate over all options and include them as tag parameters.
    tag = '<link '
    if options.rel
      tag += ' rel="' + options.rel + '"'
    if options.type
      tag += ' type="' + options.type + '" '
    if options.href
      #console.log 'in cacheBusterLink: ' + options.href
      #console.log 'in cacheBusterLink: ' + @staticDir
      if @cachedIDs[options.href]
        id = @cachedIDs[options.href]
      else
        id = getRandomInt 1000000
        @cachedIDs[options.href] = id
      tag += ' href="' + options.href + '?v=' + id + '"'
    tag += ' />'
    return tag


export default CacheBuster
