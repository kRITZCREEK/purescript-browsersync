
// foreign import create :: forall e. Name -> BSEff e BrowserSync
exports.create = function(n){
  return function(){
    return require('browser-sync').create(n);
  };
};

// foreign import get :: forall e. Name -> BSEff e (Maybe BrowserSync)
exports.get = function(n){
    return function(){
      return require('browser-sync').get(n);
    };
};

// foreign import has :: forall e. Name -> BSEff e Boolean
exports.has = function(n){
  return function(){
    return require('browser-sync').has(n);
  };
};

// foreign import init :: forall e. BrowserSync -> BSConfig -> (BSEff e Unit) -> BSEff e Unit
exports.init = function(bs){
  return function(conf){
    return function(cb){
      return function(){
        bs.init(conf, cb);
      };
    };
  };
};

// foreign import reload :: forall e. BrowserSync -> BSEff e Unit
exports.reload = function(bs){
  return function(){
    bs.reload();
  };
};

// foreign import notify :: forall e. BrowserSync -> String -> Nullable Int -> BSEff e Unit
exports.notify = function(bs){
  return function(m){
    return function(){
      bs.notify(m);
    };
  };
};

// foreign import exit   :: BrowserSync -> forall e. BSEff e Unit
exports.exit = function(bs){
    return function(){
      bs.exit();
    };
};
