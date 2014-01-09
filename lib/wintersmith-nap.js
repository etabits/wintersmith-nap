// Generated by CoffeeScript 1.6.3
(function() {
  var nap;

  nap = require('nap');

  module.exports = function(env, callback) {
    var createNapWrapper, ext, index, napCfg, preview, roots, section;
    roots = {
      contents: env.config.contents,
      output: env.config.output
    };
    napCfg = env.config.nap;
    for (ext in napCfg.assets) {
      for (section in napCfg.assets[ext]) {
        for (index in napCfg.assets[ext][section]) {
          napCfg.assets[ext][section][index] = roots.contents + napCfg.assets[ext][section][index];
        }
      }
    }
    preview = 'preview' === process.argv[2];
    napCfg.mode = preview ? 'development' : 'production';
    napCfg.publicDir = preview ? roots.contents : roots.output;
    nap(napCfg);
    if (preview) {
      createNapWrapper = function(ext) {
        return function(section) {
          return nap[ext](section).replace(/\/assets\/contents\//g, '/');
        };
      };
      global.nap = {};
      global.nap.css = createNapWrapper('css');
      global.nap.js = createNapWrapper('js');
      global.nap.jst = createNapWrapper('jst');
    } else {
      nap["package"]();
      global.nap = nap;
    }
    return callback();
  };

}).call(this);