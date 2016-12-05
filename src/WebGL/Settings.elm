module WebGL.Settings
    exposing
        ( Setting
        , enable
        , disable
        , blendColor
        , blendEquation
        , blendEquationSeparate
        , blendFunc
        , clearColor
        , depthFunc
        , depthMask
        , sampleCoverageFunc
        , stencilFunc
        , stencilFuncSeparate
        , stencilOperation
        , stencilOperationSeparate
        , stencilMask
        , colorMask
        , scissor
        )

{-| The `WebGL.Setting` provides a typesafe way to call
all pre-fragment operations and some special functions.

# Settings
@docs Setting, enable, disable, blendColor, blendEquation, blendEquationSeparate, blendFunc, clearColor, depthFunc, depthMask, sampleCoverageFunc, stencilFunc, stencilFuncSeparate, stencilOperation, stencilOperationSeparate, stencilMask, colorMask, scissor

-}

import WebGL.Types as Types exposing (..)


{-| To initiate a `Setting` please use one of the following functions
-}
type alias Setting =
    Types.Setting


{-| `enable capability`
enable server-side GL capabilities
-}
enable : Capability -> Setting
enable =
    Enable


{-| `disable capability`
disable server-side GL capabilities
-}
disable : Capability -> Setting
disable =
    Disable


{-| `blendColor red green blue alpha`
set the blend color

Requires blend to be enabled.

-}
blendColor : Float -> Float -> Float -> Float -> Setting
blendColor =
    BlendColor


{-| `blendEquation mode`
specify the equation used for both the
RGB blend equation and the Alpha blend equation

Requires blend to be enabled.

+ `mode`: specifies how source and destination colors are combined
-}
blendEquation : BlendMode -> Setting
blendEquation =
    BlendEquation


{-| `blendEquationSeparate modeRGB modeAlpha`
set the RGB blend equation and the alpha blend equation separately

Requires blend to be enabled.

+ `modeRGB`: specifies the RGB blend equation, how the red, green,
and blue components of the source and destination colors are combined
+ `modeAlpha`: specifies the alpha blend equation, how the alpha component
of the source and destination colors are combined
-}
blendEquationSeparate : BlendMode -> BlendMode -> Setting
blendEquationSeparate =
    BlendEquationSeparate


{-| `blendFunc srcFactor dstFactor`
specify pixel arithmetic

Requires blend to be enabled.

+ `srcFactor`: Specifies how the red, green, blue,
and alpha source blending factors are computed
+ `dstFactor`: Specifies how the red, green, blue,
and alpha destination blending factors are computed

`SrcAlphaSaturate` should only be used for the srcFactor.

Both values may not reference a `ConstantColor` value.
-}
blendFunc : BlendOperation -> BlendOperation -> Setting
blendFunc =
    BlendFunc


{-| `clearColor red green blue alpha`
set the clear/background color,
should be set before clearing the scene
-}
clearColor : Float -> Float -> Float -> Float -> Setting
clearColor =
    ClearColor


{-| `depthFunc func`
specify the value used for depth buffer comparisons

Requires depthTest to be enabled.

+ `func`: Specifies the depth comparison function
-}
depthFunc : CompareMode -> Setting
depthFunc =
    DepthFunc


{-| `depthMask mask`

Turns drawing to the depth buffer on or off.

Requires depthTest to be enabled.

-}
depthMask : Bool -> Setting
depthMask =
    DepthMask


{-| `sampleCoverageFunc value invert`
specify multisample coverage parameters

Requires sampleAlphaToCoverage or sampleCoverage to be enabled.

+ `value`: Specify a single floating-point sample coverage value.
The value is clamped to the range 0 1. The initial value is `1`
+ `invert`: Specify a single boolean value representing
if the coverage masks should be inverted. The initial value is `False`
-}
sampleCoverageFunc : Float -> Bool -> Setting
sampleCoverageFunc =
    SampleCoverageFunc


{-| `stencilFunc func ref mask`
set front and back function and reference value for stencil testing

Requires stencilTest to be enabled.

+ `func`: Specifies the test function.  The initial value is `Always`
+ `ref`: Specifies the reference value for the stencil test. ref is
clamped to the range 0 2 n - 1 , n is the number of bitplanes
in the stencil buffer. The initial value is `0`.
+ `mask`: Specifies a mask that is ANDed with both the reference value
and the stored stencil value when the test is done.
The initial value is all `1`'s.
-}
stencilFunc : CompareMode -> Int -> Int -> Setting
stencilFunc =
    StencilFunc


{-| `stencilFuncSeparate face func ref mask`
set front and/or back function and reference value for stencil testing

Requires stencilTest to be enabled.

+ `face`: Specifies whether front and/or back stencil state is updated

See the description of `stencilFunc` for info about the other parameters
-}
stencilFuncSeparate : FaceMode -> CompareMode -> Int -> Int -> Setting
stencilFuncSeparate =
    StencilFuncSeparate


{-| `stencilOperation fail zfail pass`
set front and back stencil test actions

Requires stencilTest to be enabled.

+ `fail`: Specifies the action to take when the stencil test fails.
The initial value is `Keep`
+ `zfail`: Specifies the stencil action when the stencil test passes,
but the depth test fails. The initial value is `Keep`
+ `pass`: Specifies the stencil action when both the stencil test
and the depth test pass, or when the stencil test passes and either
there is no depth buffer or depth testing is not enabled.
The initial value is `Keep`
-}
stencilOperation : ZMode -> ZMode -> ZMode -> Setting
stencilOperation =
    StencilOperation


{-| stencilOperationSeparate face fail zfail pass`
set front and/or back stencil test actions

Requires stencilTest to be enabled.

+ `face`: Specifies whether front and/or back stencil state is updated.

See the description of `StencilOperation` for info about the other parameters.
-}
stencilOperationSeparate : FaceMode -> ZMode -> ZMode -> ZMode -> Setting
stencilOperationSeparate =
    StencilOperationSeparate


{-| `stencilMask mask`
set the stencil `mask`. This value is ANDed with anything drawn to the
stencil buffer. Usually used to turn writing to the stencil buffer
on or off.

Requires stencilTest to be enabled.

-}
stencilMask : Int -> Setting
stencilMask =
    StencilMask


{-| `colorMask red green blue alpha`

Specify whether or not each channel should be written into the frame buffer.

-}
colorMask : Bool -> Bool -> Bool -> Bool -> Setting
colorMask =
    ColorMask


{-| `scissor x y width height`
set the scissor box, which limits the drawing of fragments to the
screen to a specified rectangle.

Requires scissorTest to be enabled.

-}
scissor : Int -> Int -> Int -> Int -> Setting
scissor =
    Scissor
