// eslint-disable-next-line no-unused-vars, camelcase
var _elm_community$webgl$Native_Settings = function () {

  function enable(capability) {
    return function (gl) {
      gl.enable(gl[capability]);
    };
  }

  function disable(capability) {
    return function (gl) {
      gl.disable(gl[capability]);
    };
  }

  function blendColor(r, g, b, a) {
    return function (gl) {
      gl.blendColor(r, g, b, a);
    };
  }

  function blendEquation(mode) {
    return function (gl) {
      gl.blendEquation(gl[mode]);
    };
  }

  function blendEquationSeparate(modeRGB, modeAlpha) {
    return function (gl) {
      gl.blendEquationSeparate(gl[modeRGB], gl[modeAlpha]);
    };
  }

  function blendFunc(src, dst) {
    return function (gl) {
      gl.blendFunc(gl[src], gl[dst]);
    };
  }

  function clearColor(r, g, b, a) {
    return function (gl) {
      gl.clearColor(r, g, b, a);
    };
  }

  function depthFunc(mode) {
    return function (gl) {
      gl.depthFunc(gl[mode]);
    };
  }

  function depthMask(mask) {
    return function (gl) { gl.depthMask(mask); };
  }

  function sampleCoverage(value, invert) {
    return function (gl) {
      gl.sampleCoverage(value, invert);
    };
  }

  function stencilFunc(func, ref, mask) {
    return function (gl) {
      gl.stencilFunc(gl[func], ref, mask);
    };
  }

  function stencilFuncSeparate(face, func, ref, mask) {
    return function (gl) {
      gl.stencilFuncSeparate(gl[face], gl[func], ref, mask);
    };
  }

  function stencilOperation(fail, zfail, zpass) {
    return function (gl) {
      gl.stencilOp(gl[fail], gl[zfail], gl[zpass]);
    };
  }

  function stencilOperationSeparate(face, fail, zfail, zpass) {
    return function (gl) {
      gl.stencilOpSeparate(gl[face], gl[fail], gl[zfail], gl[zpass]);
    };
  }

  function stencilMask(mask) {
    return function (gl) {
      gl.stencilMask(mask);
    };
  }

  function colorMask(r, g, b, a) {
    return function (gl) {
      gl.colorMask(r, g, b, a);
    };
  }

  function scissor(x, y, w, h) {
    return function (gl) {
      gl.scissor(x, y, w, h);
    };
  }


  return {
    enable: enable,
    disable: disable,
    blendColor: F4(blendColor),
    blendEquation: blendEquation,
    blendEquationSeparate: F2(blendEquationSeparate),
    blendFunc: F2(blendFunc),
    clearColor: F4(clearColor),
    depthFunc: depthFunc,
    depthMask: depthMask,
    sampleCoverage: F2(sampleCoverage),
    stencilFunc: F3(stencilFunc),
    stencilFuncSeparate: F4(stencilFuncSeparate),
    stencilOperation: F3(stencilOperation),
    stencilOperationSeparate: F4(stencilOperationSeparate),
    stencilMask: stencilMask,
    colorMask: F4(colorMask),
    scissor: F4(scissor)
  };

}();
