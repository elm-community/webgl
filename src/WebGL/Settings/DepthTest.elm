module WebGL.Settings.DepthTest
    exposing
        ( less
        , never
        , always
        , lessOrEqual
        , equal
        , greaterOrEqual
        , greater
        , notEqual
        , custom
        , Test
        , customLess
        , customNever
        , customAlways
        , customLessOrEqual
        , customEqual
        , customGreaterOrEqual
        , customGreater
        , customNotEqual
        )

{-|
# Depth Tests
@docs never, always, less, lessOrEqual, equal, greaterOrEqual,
      greater, notEqual
# Custom Tests
@docs custom, Test, customLess, customNever, customAlways, customLessOrEqual,
      customEqual, customGreaterOrEqual, customGreater, customNotEqual
-}

import WebGL.Settings exposing (Setting)
import WebGL.Settings.Internal as I


{-| Allows you to define how to compare the incoming value
with the depth buffer value, in order to set the conditions under which
the pixel will be drawn.

This will pass if the incoming value is less than the depth buffer value.
-}
less : Setting
less =
    I.DepthTest 513 True 0 1


{-| Never pass.
-}
never : Setting
never =
    I.DepthTest 512 True 0 1


{-| Always pass.
-}
always : Setting
always =
    I.DepthTest 519 True 0 1


{-| Pass if the incoming value is less than or equal to the depth buffer value.
-}
lessOrEqual : Setting
lessOrEqual =
    I.DepthTest 515 True 0 1


{-| Pass if the incoming value equals the the depth buffer value.
-}
equal : Setting
equal =
    I.DepthTest 514 True 0 1


{-| Pass if the incoming value is greater than or equal to the depth buffer
value.
-}
greaterOrEqual : Setting
greaterOrEqual =
    I.DepthTest 518 True 0 1


{-| Pass if the incoming value is greater than the depth buffer value.
-}
greater : Setting
greater =
    I.DepthTest 516 True 0 1


{-| Pass if the incoming value is not equal to the depth buffer value.
-}
notEqual : Setting
notEqual =
    I.DepthTest 517 True 0 1


{-| It is possible to turn off writing to the depth buffer and limit the
buffer’s range (0 <= near <= far <= 1). For example, this will disable
writing to the depth buffer, but still test against it:

    customTest : Setting
    customTest =
        custom
            { mask = False
            , near = 0
            , far = 1
            , test = customLess
            }

By default, [`less`](#less) writes to the depth buffer and the whole
range (0 to 1) is utilised.
-}
custom :
    { mask : Bool
    , near : Float
    , far : Float
    , test : Test
    }
    -> Setting
custom { mask, near, far, test } =
    case test of
        Test fn ->
            fn mask near far


{-| -}
type Test
    = Test (Bool -> Float -> Float -> Setting)


{-| -}
customLess : Test
customLess =
    Test (I.DepthTest 513)


{-| -}
customNever : Test
customNever =
    Test (I.DepthTest 512)


{-| -}
customAlways : Test
customAlways =
    Test (I.DepthTest 519)


{-| -}
customLessOrEqual : Test
customLessOrEqual =
    Test (I.DepthTest 515)


{-| -}
customEqual : Test
customEqual =
    Test (I.DepthTest 514)


{-| -}
customGreaterOrEqual : Test
customGreaterOrEqual =
    Test (I.DepthTest 518)


{-| -}
customGreater : Test
customGreater =
    Test (I.DepthTest 516)


{-| -}
customNotEqual : Test
customNotEqual =
    Test (I.DepthTest 517)
