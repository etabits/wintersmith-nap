nap = require 'nap'

module.exports = (env, callback) ->

  roots =
    contents: env.config.contents or './contents'
    output: env.config.output or './build'

  napCfg = env.config.nap

  # prefix with location of `contents` directory
  for ext of napCfg.assets
    for section of napCfg.assets[ext]
      for index of napCfg.assets[ext][section]
        napCfg.assets[ext][section][index] = roots.contents + napCfg.assets[ext][section][index]

  preview = 'preview' == process.argv[2]

  napCfg.mode      = if preview then 'development' else 'production'
  napCfg.publicDir = if preview then roots.contents else '/build'

  nap napCfg

  if preview # development
    createNapWrapper = (ext) ->
      (section) ->
        nap[ext](section).replace(/\/assets\/contents\//g, '/')

    global.nap = {}
    global.nap.css = createNapWrapper 'css'
    global.nap.js = createNapWrapper 'js'
    global.nap.jst = createNapWrapper 'jst'

  else # production
    nap.package()
    global.nap = nap


  # we're done
  callback()
