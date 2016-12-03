module WebGL.Constants exposing (..)

{-|
# Capabilities

@docs Capability, blend, cullFace, depthTest, dither, polygonOffsetFill, sampleAlphaToCoverage, sampleCoverage, scissorTest, stencilTest

# Blend Operations

@docs BlendOperation, zero, one, srcColor, oneMinusSrcColor, dstColor, oneMinusDstColor, srcAlpha, oneMinusSrcAlpha, dstAlpha, oneMinusDstAlpha, constantColor, oneMinusConstantColor, constantAlpha, oneMinusConstantAlpha, srcAlphaSaturate

# Blend Modes

@docs BlendMode, add, subtract, reverseSubtract

# Compare Modes

@docs CompareMode, never, always, less, lessOrEqual, equal, greaterOrEqual, greater, notEqual

# Face Modes

@docs FaceMode, front, back, frontAndBack

# ZModes

@docs ZMode, keep, none, replace, increment, decrement, invert, incrementWrap, decrementWrap
-}

import WebGL.Types as Types exposing (..)


{-| The `Capability` is used to enable/disable
server-side GL capabilities.
-}
type alias Capability =
    Types.Capability


{-| Blend the computed fragment color values
with the values in the color buffers.
-}
blend : Capability
blend =
    Blend


{-| Cull polygons based on their winding in window coordinates.
-}
cullFace : Capability
cullFace =
    CullFace


{-| Do depth comparisons and update the depth buffer.
-}
depthTest : Capability
depthTest =
    DepthTest


{-| Dither color components or indices before they
are written to the color buffer.
-}
dither : Capability
dither =
    Dither


{-| Add an offset to depth values of a polygon's fragments
produced by rasterization.
-}
polygonOffsetFill : Capability
polygonOffsetFill =
    PolygonOffsetFill


{-| Compute a temporary coverage value
where each bit is determined by the alpha value at the corresponding sample location.
The temporary coverage value is then ANDed with the fragment coverage value.
-}
sampleAlphaToCoverage : Capability
sampleAlphaToCoverage =
    SampleAlphaToCoverage


{-| The fragment's coverage is ANDed with the temporary coverage value.
-}
sampleCoverage : Capability
sampleCoverage =
    SampleCoverage


{-| Discard fragments that are outside the scissor rectangle.
-}
scissorTest : Capability
scissorTest =
    ScissorTest


{-| Do stencil testing and update the stencil buffer.
-}
stencilTest : Capability
stencilTest =
    StencilTest


{-| The `BlendOperation` allows you to define which blend operation to use.
-}
type alias BlendOperation =
    Types.BlendOperation


{-|
-}
zero : BlendOperation
zero =
    Zero


{-|
-}
one : BlendOperation
one =
    One


{-|
-}
srcColor : BlendOperation
srcColor =
    SrcColor


{-|
-}
oneMinusSrcColor : BlendOperation
oneMinusSrcColor =
    OneMinusSrcColor


{-|
-}
dstColor : BlendOperation
dstColor =
    DstColor


{-|
-}
oneMinusDstColor : BlendOperation
oneMinusDstColor =
    OneMinusDstColor


{-|
-}
srcAlpha : BlendOperation
srcAlpha =
    SrcAlpha


{-|
-}
oneMinusSrcAlpha : BlendOperation
oneMinusSrcAlpha =
    OneMinusSrcAlpha


{-|
-}
dstAlpha : BlendOperation
dstAlpha =
    DstAlpha


{-|
-}
oneMinusDstAlpha : BlendOperation
oneMinusDstAlpha =
    OneMinusDstAlpha


{-|
-}
constantColor : BlendOperation
constantColor =
    ConstantColor


{-|
-}
oneMinusConstantColor : BlendOperation
oneMinusConstantColor =
    OneMinusConstantColor


{-|
-}
constantAlpha : BlendOperation
constantAlpha =
    ConstantAlpha


{-|
-}
oneMinusConstantAlpha : BlendOperation
oneMinusConstantAlpha =
    OneMinusConstantAlpha


{-|
-}
srcAlphaSaturate : BlendOperation
srcAlphaSaturate =
    SrcAlphaSaturate


{-| The `BlendMode` allows you to define which blend mode to use.
-}
type alias BlendMode =
    Types.BlendMode


{-|
-}
add : BlendMode
add =
    Add


{-|
-}
subtract : BlendMode
subtract =
    Subtract


{-|
-}
reverseSubtract : BlendMode
reverseSubtract =
    ReverseSubtract


{-| The `CompareMode` allows you to define how to compare values.
-}
type alias CompareMode =
    Types.CompareMode


{-|
-}
never : CompareMode
never =
    Never


{-|
-}
always : CompareMode
always =
    Always


{-|
-}
less : CompareMode
less =
    Less


{-|
-}
lessOrEqual : CompareMode
lessOrEqual =
    LessOrEqual


{-|
-}
equal : CompareMode
equal =
    Equal


{-|
-}
greaterOrEqual : CompareMode
greaterOrEqual =
    GreaterOrEqual


{-|
-}
greater : CompareMode
greater =
    Greater


{-|
-}
notEqual : CompareMode
notEqual =
    NotEqual


{-| The `FaceMode` defines which face of the stencil state is updated.
-}
type alias FaceMode =
    Types.FaceMode


{-|
-}
front : FaceMode
front =
    Front


{-|
-}
back : FaceMode
back =
    Back


{-|
-}
frontAndBack : FaceMode
frontAndBack =
    FrontAndBack


{-| The `ZMode` type allows you to define what to do
with the stencil buffer value.
-}
type alias ZMode =
    Types.ZMode


{-| Keeps the current value
-}
keep : ZMode
keep =
    Keep


{-| Sets the stencil buffer value to 0
-}
none : ZMode
none =
    None


{-| Sets the stencil buffer value to `ref`,
see `Settings.stencilFunc` for more information.
-}
replace : ZMode
replace =
    Replace


{-| Increments the current stencil buffer value.
Clamps to the maximum representable unsigned value.
-}
increment : ZMode
increment =
    Increment


{-| Decrements the current stencil buffer value. Clamps to 0.
-}
decrement : ZMode
decrement =
    Decrement


{-| Bitwise inverts the current stencil buffer value.
-}
invert : ZMode
invert =
    Invert


{-| Increments the current stencil buffer value.
Wraps stencil buffer value to zero when incrementing
the maximum representable unsigned value.
-}
incrementWrap : ZMode
incrementWrap =
    IncrementWrap


{-| Decrements the current stencil buffer value.
Wraps stencil buffer value to the maximum representable unsigned
value when decrementing a stencil buffer value of zero.
-}
decrementWrap : ZMode
decrementWrap =
    DecrementWrap
