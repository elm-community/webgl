module WebGL.Settings.DepthTest
    exposing
        ( default
        , Options
        , less
        , never
        , always
        , equal
        , greater
        , notEqual
        , lessOrEqual
        , greaterOrEqual
        )

{-|
You can read more about depth-testing in the
[OpenGL wiki](https://www.khronos.org/opengl/wiki/Depth_Test)
or [OpenGL docs](https://www.opengl.org/sdk/docs/man2/xhtml/glDepthFunc.xml).
# Depth Tests
@docs default
# Custom Tests
@docs Options, less, never, always, equal, greater, notEqual,
  lessOrEqual, greaterOrEqual
-}

import WebGL.Settings exposing (Setting)
import WebGL.Settings.Internal as I


{-| With every pixel, we have to figure out which color to show.

Imagine you have many entities in the same line of sight. The floor,
then a table, then a plate. When depth-testing is off, you go through
the entities in the order they appear in your *code*! That means if
you describe the floor last, it will be “on top” of the table and plate.

Depth-testing means the color is chosen based on the distance from the
camera. So `default` uses the color closest to the camera. This means
the plate will be on top of the table, and both are on top of the floor.
Seems more reasonable!

There are a bunch of ways you can customize the depth test, shown later,
and you can use them to define `default` like this:

    default =
        less { write = True, near = 0, far = 1}
-}
default : Setting
default =
    less { write = True, near = 0, far = 1 }


{-| When rendering, you have a buffer of pixels. Depth-testing works by
creating a second buffer with exactly the same number of entries, but
instead of holding colors, each entry holds the distance from the camera.
You go through all your entities, writing into the depth buffer, and then
you draw the color of the “winner”.

Which color wins? This is based on a bunch of comparison functions:

    <TABLE>

Explain write. Specifically mention that depth testing and stencil testing
interact. That is the main usage for this.

Explain clipping planes and near/far. Speculate on why you'd want it.
-}
type alias Options =
    { write : Bool
    , near : Float
    , far : Float
    }


{-| -}
less : Options -> Setting
less { write, near, far } =
    I.DepthTest 513 write near far


{-| -}
never : Options -> Setting
never { write, near, far } =
    I.DepthTest 512 write near far


{-| -}
always : Options -> Setting
always { write, near, far } =
    I.DepthTest 519 write near far


{-| -}
equal : Options -> Setting
equal { write, near, far } =
    I.DepthTest 514 write near far


{-| -}
greater : Options -> Setting
greater { write, near, far } =
    I.DepthTest 516 write near far


{-| -}
notEqual : Options -> Setting
notEqual { write, near, far } =
    I.DepthTest 517 write near far


{-| -}
lessOrEqual : Options -> Setting
lessOrEqual { write, near, far } =
    I.DepthTest 515 write near far


{-| -}
greaterOrEqual : Options -> Setting
greaterOrEqual { write, near, far } =
    I.DepthTest 518 write near far
