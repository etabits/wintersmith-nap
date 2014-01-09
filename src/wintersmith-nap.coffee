nap  = require 'nap'
path = require 'path'

module.exports = (env, callback) ->
  roots =
    contents: path.resolve(env.workDir, env.config.contents)
    output: path.resolve(env.workDir, env.config.output)


  napCfg = env.config.nap

  # prefix with location of `contents` directory
  # and also using a very ugly hack (10 levels ../) because of nap bath handling bug, until
  # https://github.com/craigspaeth/nap/pull/71 is merged into the next nap release
  for ext of napCfg.assets
    for section of napCfg.assets[ext]
      for index of napCfg.assets[ext][section]
        napCfg.assets[ext][section][index] = '../../../../../../../../../../' + roots.contents + napCfg.assets[ext][section][index]
  
  preview = 'preview' == process.argv[2]

  napCfg.mode      = if preview then 'development' else 'production'
  napCfg.publicDir = if preview then roots.contents else roots.output

  nap napCfg
  

  if preview # development
    createNapWrapper = (ext) ->
      (section) ->
        nap[ext](section).replace(/\/assets\/contents\//g, '/')

    env.locals.nap = {}
    env.locals.nap.css = createNapWrapper 'css'
    env.locals.nap.js = createNapWrapper 'js'
    env.locals.nap.jst = createNapWrapper 'jst'

  else # production
    env.logger.info('nap.package()...')
    nap.package()
    env.logger.info('Done!')
    #nap.js('main')
    env.locals.nap = nap


  # we're done
  callback()
