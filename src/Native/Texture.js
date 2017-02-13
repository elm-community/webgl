// eslint-disable-next-line no-unused-vars, camelcase
var _elm_community$webgl$Native_Texture = function () {

  var NEAREST = 9728;
  var LINEAR = 9729;
  var CLAMP_TO_EDGE = 33071;

  function guid() {
    // eslint-disable-next-line camelcase
    return _elm_lang$core$Native_Utils.guid();
  }

  function applySettings(gl, flipY, magnify, mininify, horizontalWrap, verticalWrap) {
    gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, flipY);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, magnify);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, mininify);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, horizontalWrap);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, verticalWrap);
  }

  function isSizeValid(width, height, isMipmap, horizontalWrap, verticalWrap) {
    var widthPowerOfTwo = (width & (width - 1)) === 0;
    var heightPowerOfTwo = (height & (height - 1)) === 0;
    return (widthPowerOfTwo && heightPowerOfTwo) || (
      !isMipmap
      && horizontalWrap === CLAMP_TO_EDGE
      && verticalWrap === CLAMP_TO_EDGE
    );
  }

  function load(magnify, mininify, horizontalWrap, verticalWrap, flipY, url) {
    // eslint-disable-next-line camelcase
    var Scheduler = _elm_lang$core$Native_Scheduler;
    var isMipmap = mininify !== NEAREST && mininify !== LINEAR;

    return Scheduler.nativeBinding(function (callback) {
      var img = new Image();
      function createTexture(gl) {
        var texture = gl.createTexture();
        gl.bindTexture(gl.TEXTURE_2D, texture);
        applySettings(gl, flipY, magnify, mininify, horizontalWrap, verticalWrap);
        gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, img);
        if (isMipmap) {
          gl.generateMipmap(gl.TEXTURE_2D);
        }
        gl.bindTexture(gl.TEXTURE_2D, null);
        return texture;
      }
      img.onload = function () {
        var width = img.width;
        var height = img.height;
        if (isSizeValid(width, height, isMipmap, horizontalWrap, verticalWrap)) {
          callback(Scheduler.succeed({
            ctor: 'Texture',
            id: guid(),
            createTexture: createTexture,
            width: width,
            height: height
          }));
        } else {
          callback(Scheduler.fail({
            ctor: 'SizeError',
            _0: width,
            _1: height
          }));
        }
      };
      img.onerror = function () {
        callback(Scheduler.fail({ ctor: 'LoadError' }));
      };
      if (url.slice(0, 5) !== 'data:') {
        img.crossOrigin = 'Anonymous';
      }
      img.src = url;
    });
  }

  function size(texture) {
    // eslint-disable-next-line camelcase
    return _elm_lang$core$Native_Utils.Tuple2(texture.width, texture.height);
  }

  function fromEntities(magnify, mininify, horizontalWrap, verticalWrap, flipY, width, height, entities) {
    var isMipmap = mininify !== NEAREST && mininify !== LINEAR;

    if (isSizeValid(width, height, isMipmap, horizontalWrap, verticalWrap)) {
      return { ctor: 'Ok', _0: {
        ctor: 'Texture',
        id: guid(),
        initTexture: initTexture,
        entities: entities,
        width: width,
        height: height
      }};
    } else {
      return { ctor: 'Err', _0: {
        ctor: 'SizeError',
        _0: width,
        _1: height
      }};
    }

    function initTexture(gl) {
      var framebuffer = gl.createFramebuffer();
      var texture = gl.createTexture();
      var renderbuffer = gl.createRenderbuffer();
      gl.bindFramebuffer(gl.FRAMEBUFFER, framebuffer);
      gl.bindTexture(gl.TEXTURE_2D, texture);
      gl.bindRenderbuffer(gl.RENDERBUFFER, renderbuffer);
      applySettings(gl, flipY, magnify, mininify, horizontalWrap, verticalWrap);
      gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, width, height, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
      gl.renderbufferStorage(gl.RENDERBUFFER, gl.DEPTH_COMPONENT16, width, height);
      gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, texture, 0);
      gl.framebufferRenderbuffer(gl.FRAMEBUFFER, gl.DEPTH_ATTACHMENT, gl.RENDERBUFFER, renderbuffer);
      gl.bindTexture(gl.TEXTURE_2D, null);
      gl.bindRenderbuffer(gl.RENDERBUFFER, null);
      gl.bindFramebuffer(gl.FRAMEBUFFER, null);
      return {
        texture: texture,
        framebuffer: framebuffer,
        isMipmap: isMipmap
      };
    }

  }

  return {
    size: size,
    load: F6(load),
    fromEntities: F8(fromEntities)
  };

}();
