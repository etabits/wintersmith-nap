vows = require 'vows'
assert = require 'assert'
wintersmith = require 'wintersmith'
fs = require 'fs'

suite = vows.describe 'Plugin'

suite.addBatch
  'wintersmith':
    topic: -> wintersmith './example/config.json'
    'loaded ok': (env) ->
      assert.instanceOf env, wintersmith.Environment
    'build':
      topic: (env) -> env.build(@callback)
      'template':
        topic: (result) ->
          fs.readFile('./example/build/index.html', 'utf-8', @callback)

        '<link href=...': (htmlOutput) ->
          assert.notEqual htmlOutput.indexOf("<link href='/assets/main-5fc96a8558e1b247f6b5c3f4b4e6d475.css' rel='stylesheet' type='text/css'>"), -1

        '<script src=...': (htmlOutput) ->
          assert.notEqual htmlOutput.indexOf("<script src='/assets/main-1e1b06f3f659747d8ec7f975653b375c.js' type='text/javascript'>"), -1
      'asset files':
        topic: ->
          {
            js:  fs.readFileSync('./example/build/assets/main-1e1b06f3f659747d8ec7f975653b375c.js').toString(),
            css: fs.readFileSync('./example/build/assets/main-5fc96a8558e1b247f6b5c3f4b4e6d475.css').toString()
          }
        'javascript': (assets) ->
          assert.equal assets.js, 'for(var i=0;5>i;++i);alert("HI");'
        'css': (assets) ->
          assert.equal assets.css, 'body{color:white;background:black}'

suite.export module
