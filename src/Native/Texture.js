// eslint-disable-next-line no-unused-vars, camelcase
var _elm_community$webgl$Native_Texture = function () {

  function loadWith(options, source) {
    // eslint-disable-next-line camelcase
    var Scheduler = _elm_lang$core$Native_Scheduler;
    return Scheduler.nativeBinding(function (callback) {
      var img = new Image();
      function createTexture(gl) {
        var tex = gl.createTexture();
        gl.bindTexture(gl.TEXTURE_2D, tex);
        gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, true);
        gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, img);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, options.magnifyingFilter._0);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, options.minifyingFilter._0);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, options.horizontalWrap._0);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, options.verticalWrap._0);
        gl.generateMipmap(gl.TEXTURE_2D);
        gl.bindTexture(gl.TEXTURE_2D, null);
        return tex;
      }
      img.onload = function () {
        callback(Scheduler.succeed({
          ctor: 'Texture',
          createTexture: createTexture,
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
