// eslint-disable-next-line no-unused-vars, camelcase
var _elm_community$webgl$Native_Texture = function () {

  function loadWith(filter, source) {
    // eslint-disable-next-line camelcase
    var Scheduler = _elm_lang$core$Native_Scheduler;
    return Scheduler.nativeBinding(function (callback) {
      var img = new Image();
      // prevent the debugger from serializing the image as a record
      function getImage() {
        return img;
      }
      img.onload = function () {
        callback(Scheduler.succeed({
          ctor: 'Texture',
          img: getImage,
          filter: filter,
          width: img.width,
          height: img.height
        }));
      };
      img.onerror = function () {
        callback(Scheduler.fail({ ctor: 'Error' }));
      };
      img.crossOrigin = 'Anonymous';
      img.src = source;
    });
  }

  function size(texture) {
    // eslint-disable-next-line camelcase
    return _elm_lang$core$Native_Utils.Tuple2(texture.width, texture.height);
  }

  return {
    size: size,
    loadWith: F2(loadWith)
  };

}();
