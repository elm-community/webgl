module WebGL.Options
    exposing
        ( Option
        , alpha
        , depth
        , stencil
        , antialias
        , clearColor
        )

{-| # Options
@docs Option, alpha, depth, stencil, antialias, clearColor
-}


{-| Provides a typesafe way to configure WebGLContext and the scene behavior
in `WebGL.toHtmlWith`.
-}
type Option
    = Alpha Bool
    | Depth Float
    | Stencil Int
    | Antialias
    | ClearColor Float Float Float Float


{-| Enable alpha channel in the drawing buffer. If the argument is `True`, then
the page compositor will assume the drawing buffer contains colors with
premultiplied alpha.

`alpha True` is enabled by default when you use `WebGL.toHtml`.
-}
alpha : Bool -> Option
alpha =
    Alpha


{-| Enable the depth buffer, and prefill it with given value each time before
the scene is rendered. The value is clamped between 0 and 1.

`depth 1` is enabled by default when you use `WebGL.toHtml`.
-}
depth : Float -> Option
depth =
    Depth


{-| Enable the stencil buffer, specifying the index used to fill the
stencil buffer before we render the scene. The index is masked with 2^m - 1,
where m >= 8 is the number of bits in the stencil buffer. The default is 0.
-}
stencil : Int -> Option
stencil =
    Stencil


{-| Enable antialiasing of the drawing buffer, if supported by the browser.
Useful when you want to preserve sharp edges when resizing the canvas.

`antialias` is enabled by default when you use `WebGL.toHtml`.
-}
antialias : Option
antialias =
    Antialias


{-| Set the red, green, blue and alpha channels, that will be used to
fill the drawing buffer every time before drawing the scene. The values are
clamped between 0 and 1. The default is all 0's.
-}
clearColor : Float -> Float -> Float -> Float -> Option
clearColor =
    ClearColor
