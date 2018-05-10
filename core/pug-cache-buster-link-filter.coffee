cacheBusterLink = (text, options) ->
  # TODO: generate id for href based on local file date.
  # TODO: store ids in local persistent dictionary.
  # TODO: iterate over all options and include them as tag parameters.
  tag = '<link '
  if options.rel
    tag += ' rel="' + options.rel + '"'
  if options.type
    tag += ' type="' + options.type + '" '
  if options.href
    tag += ' href="' + options.href + '?v=some-id-based-on-file-date"'
  tag += ' />'
  return tag


export default cacheBusterLink
