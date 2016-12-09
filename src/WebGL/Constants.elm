module WebGL.Constants exposing (..)

{-|
# Capabilities

@docs Capability, cullFace, dither, polygonOffsetFill, sampleAlphaToCoverage, sampleCoverage, scissorTest

# Blend Factors

@docs BlendFactor, zero, one, srcColor, oneMinusSrcColor, dstColor, oneMinusDstColor, srcAlpha, oneMinusSrcAlpha, dstAlpha, oneMinusDstAlpha, constantColor, oneMinusConstantColor, constantAlpha, oneMinusConstantAlpha, srcAlphaSaturate

# Blend Equations

@docs BlendEquation, add, subtract, reverseSubtract

# Compare Modes

@docs CompareMode, never, always, less, lessOrEqual, equal, greaterOrEqual, greater, notEqual

# ZModes

@docs ZMode, keep, none, replace, increment, decrement, invert, incrementWrap, decrementWrap
-}


{-| The `Capability` is used to enable/disable
server-side GL capabilities.
-}
type Capability
    = Capability Int


{-| Cull polygons based on their winding in window coordinates.
-}
cullFace : Capability
cullFace =
    Capability 2884


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


{-| Allows you to define which blend factor to use.
-}
type BlendFactor
    = BlendFactor Int


{-|
-}
zero : BlendFactor
zero =
    BlendFactor 0


{-|
-}
one : BlendFactor
one =
    BlendFactor 1


{-|
-}
srcColor : BlendFactor
srcColor =
    BlendFactor 768


{-|
-}
oneMinusSrcColor : BlendFactor
oneMinusSrcColor =
    BlendFactor 769


{-|
-}
dstColor : BlendFactor
dstColor =
    BlendFactor 774


{-|
-}
oneMinusDstColor : BlendFactor
oneMinusDstColor =
    BlendFactor 775


{-|
-}
srcAlpha : BlendFactor
srcAlpha =
    BlendFactor 770


{-|
-}
oneMinusSrcAlpha : BlendFactor
oneMinusSrcAlpha =
    BlendFactor 771


{-|
-}
dstAlpha : BlendFactor
dstAlpha =
    BlendFactor 772


{-|
-}
oneMinusDstAlpha : BlendFactor
oneMinusDstAlpha =
    BlendFactor 773


{-|
-}
constantColor : BlendFactor
constantColor =
    BlendFactor 32769


{-|
-}
oneMinusConstantColor : BlendFactor
oneMinusConstantColor =
    BlendFactor 32770


{-|
-}
constantAlpha : BlendFactor
constantAlpha =
    BlendFactor 32771


{-|
-}
oneMinusConstantAlpha : BlendFactor
oneMinusConstantAlpha =
    BlendFactor 32772


{-|
-}
srcAlphaSaturate : BlendFactor
srcAlphaSaturate =
    BlendFactor 776


{-| The `BlendEquation` allows you to define which blend mode to use.
-}
type BlendEquation
    = BlendEquation Int


{-|
-}
add : BlendEquation
add =
    BlendEquation 32774


{-|
-}
subtract : BlendEquation
subtract =
    BlendEquation 32778


{-|
-}
reverseSubtract : BlendEquation
reverseSubtract =
    BlendEquation 32779


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
