nap = require 'nap'

module.exports = (env, callback) ->

  roots =
    contents: env.config.contents
    output: env.config.output

  napCfg = env.config.nap

  # prefix with location of `contents` directory
  for ext of napCfg.assets
    for section of napCfg.assets[ext]
      for index of napCfg.assets[ext][section]
        napCfg.assets[ext][section][index] = roots.contents + napCfg.assets[ext][section][index]

  preview = 'preview' == process.argv[2]

  napCfg.mode      = if preview then 'development' else 'production'
  napCfg.publicDir = if preview then roots.contents else roots.output

  nap napCfg

  nap.package() unless preview
  global.nap = nap

  # we're done
  callback()
