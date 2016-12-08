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


{-| The `Capability` is used to enable/disable
server-side GL capabilities.
-}
type Capability
    = Capability Int


{-| Blend the computed fragment color values
with the values in the color buffers.
-}
blend : Capability
blend =
    Capability 3042


{-| Cull polygons based on their winding in window coordinates.
-}
cullFace : Capability
cullFace =
    Capability 2884


{-| Do depth comparisons and update the depth buffer.
-}
depthTest : Capability
depthTest =
    Capability 2929


{-| Dither color components or indices before they
are written to the color buffer.
-}
dither : Capability
dither =
    Capability 3024


{-| Add an offset to depth values of a polygon's fragments
produced by rasterization.
-}
polygonOffsetFill : Capability
polygonOffsetFill =
    Capability 32823


{-| Compute a temporary coverage value
where each bit is determined by the alpha value at the corresponding sample location.
The temporary coverage value is then ANDed with the fragment coverage value.
-}
sampleAlphaToCoverage : Capability
sampleAlphaToCoverage =
    Capability 32926


{-| The fragment's coverage is ANDed with the temporary coverage value.
-}
sampleCoverage : Capability
sampleCoverage =
    Capability 32928


{-| Discard fragments that are outside the scissor rectangle.
-}
scissorTest : Capability
scissorTest =
    Capability 3089


{-| Do stencil testing and update the stencil buffer.
-}
stencilTest : Capability
stencilTest =
    Capability 2960


{-| The `BlendOperation` allows you to define which blend operation to use.
-}
type BlendOperation
    = BlendOperation Int


{-|
-}
zero : BlendOperation
zero =
    BlendOperation 0


{-|
-}
one : BlendOperation
one =
    BlendOperation 1


{-|
-}
srcColor : BlendOperation
srcColor =
    BlendOperation 768


{-|
-}
oneMinusSrcColor : BlendOperation
oneMinusSrcColor =
    BlendOperation 769


{-|
-}
dstColor : BlendOperation
dstColor =
    BlendOperation 774


{-|
-}
oneMinusDstColor : BlendOperation
oneMinusDstColor =
    BlendOperation 775


{-|
-}
srcAlpha : BlendOperation
srcAlpha =
    BlendOperation 770


{-|
-}
oneMinusSrcAlpha : BlendOperation
oneMinusSrcAlpha =
    BlendOperation 771


{-|
-}
dstAlpha : BlendOperation
dstAlpha =
    BlendOperation 772


{-|
-}
oneMinusDstAlpha : BlendOperation
oneMinusDstAlpha =
    BlendOperation 773


{-|
-}
constantColor : BlendOperation
constantColor =
    BlendOperation 32769


{-|
-}
oneMinusConstantColor : BlendOperation
oneMinusConstantColor =
    BlendOperation 32770


{-|
-}
constantAlpha : BlendOperation
constantAlpha =
    BlendOperation 32771


{-|
-}
oneMinusConstantAlpha : BlendOperation
oneMinusConstantAlpha =
    BlendOperation 32772


{-|
-}
srcAlphaSaturate : BlendOperation
srcAlphaSaturate =
    BlendOperation 776


{-| The `BlendMode` allows you to define which blend mode to use.
-}
type BlendMode
    = BlendMode Int


{-|
-}
add : BlendMode
add =
    BlendMode 32774


{-|
-}
subtract : BlendMode
subtract =
    BlendMode 32778


{-|
-}
reverseSubtract : BlendMode
reverseSubtract =
    BlendMode 32779


{-| The `CompareMode` allows you to define how to compare values.
-}
type CompareMode
    = CompareMode Int


{-|
-}
never : CompareMode
never =
    CompareMode 512


{-|
-}
always : CompareMode
always =
    CompareMode 519


{-|
-}
less : CompareMode
less =
    CompareMode 513


{-|
-}
lessOrEqual : CompareMode
lessOrEqual =
    CompareMode 515


{-|
-}
equal : CompareMode
equal =
    CompareMode 514


{-|
-}
greaterOrEqual : CompareMode
greaterOrEqual =
    CompareMode 518


{-|
-}
greater : CompareMode
greater =
    CompareMode 516


{-|
-}
notEqual : CompareMode
notEqual =
    CompareMode 517


{-| The `FaceMode` defines which face of the stencil state is updated.
-}
type FaceMode
    = FaceMode Int


{-|
-}
front : FaceMode
front =
    FaceMode 1028


{-|
-}
back : FaceMode
back =
    FaceMode 1029


{-|
-}
frontAndBack : FaceMode
frontAndBack =
    FaceMode 1032


{-| The `ZMode` type allows you to define what to do
with the stencil buffer value.
-}
type ZMode
    = ZMode Int


{-| Keeps the current value
-}
keep : ZMode
keep =
    ZMode 7680


{-| Sets the stencil buffer value to 0.
Should be named `zero`, but it is taken.
-}
none : ZMode
none =
    ZMode 0


{-| Sets the stencil buffer value to `ref`,
see `Settings.stencilFunc` for more information.
-}
replace : ZMode
replace =
    ZMode 7681


{-| Increments the current stencil buffer value.
Clamps to the maximum representable unsigned value.
-}
increment : ZMode
increment =
    ZMode 7682


{-| Decrements the current stencil buffer value. Clamps to 0.
-}
decrement : ZMode
decrement =
    ZMode 7683


{-| Bitwise inverts the current stencil buffer value.
-}
invert : ZMode
invert =
    ZMode 5386


{-| Increments the current stencil buffer value.
Wraps stencil buffer value to zero when incrementing
the maximum representable unsigned value.
-}
incrementWrap : ZMode
incrementWrap =
    ZMode 34055


{-| Decrements the current stencil buffer value.
Wraps stencil buffer value to the maximum representable unsigned
value when decrementing a stencil buffer value of zero.
-}
decrementWrap : ZMode
decrementWrap =
    ZMode 34056
