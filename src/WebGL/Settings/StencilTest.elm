module WebGL.Settings.StencilTest
    exposing
        ( test
        , testSeparate
        , Options
        , Test
        , always
        , equal
        , never
        , less
        , greater
        , lessOrEqual
        , greaterOrEqual
        , notEqual
        , Operation
        , replace
        , keep
        , zero
        , increment
        , decrement
        , invert
        , incrementWrap
        , decrementWrap
        )

{-| You can read more about stencil-testing in the
[OpenGL wiki](https://www.khronos.org/opengl/wiki/Stencil_Test)
or [OpenGL docs](https://www.opengl.org/sdk/docs/man2/xhtml/glStencilFunc.xml).

# Stencil Test
@docs test, Options

## Tests
@docs Test, always, equal, never, less, greater, notEqual,
  lessOrEqual, greaterOrEqual

## Operations
@docs Operation, replace, keep, zero, increment, decrement, invert,
  incrementWrap, decrementWrap

# Separate Test
@docs testSeparate
-}

import WebGL.Settings exposing (Setting)
import WebGL.Settings.Internal as I


{-| -}
test : Options -> Setting
test options =
    testSeparate options options


{-| When you need to draw an intercection of two entities, e.g. a reflection in
the mirror, you can test against the stencil buffer, that has to be enabled
with [`stencil`](WebGL#stencil) option in [`toHtmlWith`](WebGL#toHtmlWith).

Stencil [test](#Test) decides if the pixel should be drawn on the screen.
Depending on the results, it performs one of the following
[operations](#Operation) on the stencil buffer:

* `fail`—the operation to use when the stencil test fails;
* `zfail`—the operation to use when the stencil test passes, but the depth
  test fails;
* `zpass`—the operation to use when both the stencil test and the depth test
  pass, or when the stencil test passes and there is no depth buffer or depth
  testing is disabled.

For example, draw the mirror `Entity` on the screen and fill the stencil buffer
with all 1's:

    test
        { test = always 1 0xFF -- pass for each pixel and set ref to 1
        , fail = keep          -- noop
        , zfail = keep         -- noop
        , zpass = replace      -- write ref to the stencil buffer
        , writeMask = 0xFF     -- enable all stencil bits for writing
        }

Crop the reflection `Entity` using the values from the stencil buffer:

    test
        { test = equal 1 0xFF -- pass when the stencil value is 1
        , fail = keep         -- noop
        , zfail = keep        -- noop
        , zpass = keep        -- noop
        , writeMask = 0       -- disable writing to the stencil buffer
        }

You can see the complete example
[here](https://github.com/elm-community/webgl/blob/master/examples/crate.elm).
-}
type alias Options =
    { test : Test
    , fail : Operation
    , zfail : Operation
    , zpass : Operation
    , writeMask : Int
    }


{-| The `Test` allows you to define how to compare the reference value
with the stencil buffer value, in order to set the conditions under which
the pixel will be drawn.

    always ref mask         -- Always pass
    equal ref mask          -- ref & mask == stencil & mask
    never ref mask          -- Never pass
    less ref mask           -- ref & mask < stencil & mask
    greater ref mask        -- ref & mask > stencil & mask
    notEqual ref mask       -- ref & mask != stencil & mask
    lessOrEqual ref mask    -- ref & mask <= stencil & mask
    greaterOrEqual ref mask -- ref & mask >= stencil & mask
-}
type Test
    = Test Int Int Int


{-| -}
always : Int -> Int -> Test
always ref =
    Test 519 ref


{-| -}
equal : Int -> Int -> Test
equal =
    Test 514


{-| -}
never : Int -> Int -> Test
never ref =
    Test 512 ref


{-| -}
less : Int -> Int -> Test
less =
    Test 513


{-| -}
greater : Int -> Int -> Test
greater =
    Test 516


{-| -}
notEqual : Int -> Int -> Test
notEqual =
    Test 517


{-| -}
lessOrEqual : Int -> Int -> Test
lessOrEqual =
    Test 515


{-| -}
greaterOrEqual : Int -> Int -> Test
greaterOrEqual =
    Test 518


{-| Defines how to update the value in the stencil buffer.
-}
type Operation
    = Operation Int


{-| Sets the stencil buffer value to `ref` from the stencil test.
-}
replace : Operation
replace =
    Operation 7681


{-| Keeps the current stencil buffer value. Use this as a noop.
-}
keep : Operation
keep =
    Operation 7680


{-| Sets the stencil buffer value to 0.
-}
zero : Operation
zero =
    Operation 0


{-| Increments the current stencil buffer value. Clamps to the maximum
representable unsigned value.
-}
increment : Operation
increment =
    Operation 7682


{-| Decrements the current stencil buffer value. Clamps to 0.
-}
decrement : Operation
decrement =
    Operation 7683


{-| Bitwise inverts the current stencil buffer value.
-}
invert : Operation
invert =
    Operation 5386


{-| Increments the current stencil buffer value. Wraps stencil buffer value to
zero when incrementing the maximum representable unsigned value.
-}
incrementWrap : Operation
incrementWrap =
    Operation 34055


{-| Decrements the current stencil buffer value.
Wraps stencil buffer value to the maximum representable unsigned
value when decrementing a stencil buffer value of zero.
-}
decrementWrap : Operation
decrementWrap =
    Operation 34056


{-| Different options for front and back facing polygons. Both options must
use the same `ref`, `mask` and `writeMask`,
[see here](https://www.khronos.org/registry/webgl/specs/latest/1.0/#6.10).
-}
testSeparate : Options -> Options -> Setting
testSeparate options1 options2 =
    let
        expandTest (Test test ref mask) fn =
            fn test ref mask

        expandOp (Operation op) fn =
            fn op

        expand { test, fail, zfail, zpass, writeMask } =
            expandTest test
                >> expandOp fail
                >> expandOp zfail
                >> expandOp zpass
                >> (|>) writeMask
    in
        I.StencilTest
            |> expand options1
            |> expand options2
