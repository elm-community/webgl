module WebGL.Settings.StencilTest
    exposing
        ( test
        , testSeparate
        , Options
        , defaultOptions
        , Test
        , never
        , always
        , less
        , lessOrEqual
        , equal
        , greaterOrEqual
        , greater
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

{-|
# Stencil Test
In order to use this, [`stencil`](WebGL#stencil) option has to be used in
[`toHtmlWith`](WebGL#toHtmlWith).
@docs test, Options, defaultOptions
## Tests
@docs Test, less, never, always, equal, greater, notEqual,
  lessOrEqual, greaterOrEqual
## Operations
@docs Operation, replace, keep, zero, increment, decrement, invert,
  incrementWrap, decrementWrap
# Separate Test
@docs testSeparate
-}

import WebGL.Settings exposing (Setting)
import WebGL.Settings.Internal as I


{-| Perform the stencil test and update the stencil buffer:
-}
test : Options -> Setting
test options =
    testSeparate options options


{-| Options
* `test` - the test to run against the stencil buffer;
* `fail` - the operation to use when the stencil test fails;
* `zfail` - the operation to use when the stencil test passes, but the depth
  test fails;
* `zpass` - the operation to use when both the stencil test and the depth test
  pass, or when the stencil test passes and there is no depth buffer or depth
  testing is disabled;
* `mask` - a bit mask to enable or disable writing of individual bits in
  the stencil plane.
-}
type alias Options =
    { test : Test
    , fail : Operation
    , zfail : Operation
    , zpass : Operation
    , mask : Int
    }


{-| Defaut options for the stencil setting.

    { test = always 0
    , fail = keep
    , zfail = keep
    , zpass = keep
    , mask = 0xFF
    }

The following test will always pass without causing any changes to
the stencil buffer:

    test defaultOptions

Draw the entity, and fill the stencil buffer with all 1's:

    test { defaultOptions | test = always 1, zpass = replace }

Use the values from the stencil buffer to mask the entity and keep the
stencil buffer intact:

    test { defaultOptions | test = equal 1 0xFF, mask = 0 }

-}
defaultOptions : Options
defaultOptions =
    { test = always 0
    , fail = keep
    , zfail = keep
    , zpass = keep
    , mask = 0xFF
    }


{-| The `Test` allows you to define how to compare the incoming value
with the stencil buffer value, in order to set the conditions under which
the pixel will be drawn.
-}
type Test
    = Test Int Int Int


{-| Never pass.
-}
never : Int -> Test
never ref =
    Test 512 ref 0


{-| Always pass.
-}
always : Int -> Test
always ref =
    Test 519 ref 0


{-| For the `value` from the stencil buffer, this will pass
if `(ref & mask) < (value & mask)`:
    less ref mask
-}
less : Int -> Int -> Test
less =
    Test 513


{-| Pass if `(ref & mask) <= (value & mask)`.
-}
lessOrEqual : Int -> Int -> Test
lessOrEqual =
    Test 515


{-| Pass if `(ref & mask) == (value & mask)`.
-}
equal : Int -> Int -> Test
equal =
    Test 514


{-| Pass if `(ref & mask) >= (value & mask)`.
-}
greaterOrEqual : Int -> Int -> Test
greaterOrEqual =
    Test 518


{-| Pass if `(ref & mask) > (value & mask)`.
-}
greater : Int -> Int -> Test
greater =
    Test 516


{-| Pass if `(ref & mask) != (value & mask)`.
-}
notEqual : Int -> Int -> Test
notEqual =
    Test 517


{-| Defines what to do with the stencil buffer value.
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


{-| Different options for front and back facing polygons
-}
testSeparate : Options -> Options -> Setting
testSeparate options1 options2 =
    let
        expandTest (Test test ref mask) fn =
            fn test ref mask

        expandOp (Operation op) fn =
            fn op

        expand { test, fail, zfail, zpass, mask } =
            expandTest test
                >> expandOp fail
                >> expandOp zfail
                >> expandOp zpass
                >> (|>) mask
    in
        I.StencilTest
            |> expand options1
            |> expand options2
