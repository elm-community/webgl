module WebGL.Settings
    exposing
        ( Setting
        , scissor
        , colorMask
        , dither
        , polygonOffset
        , sampleCoverage
        , sampleAlphaToCoverage
        , cullFace
        , FaceMode
        , front
        , back
        , frontAndBack
        )

{-| # Settings

@docs Setting

@docs scissor, colorMask, dither, polygonOffset, sampleCoverage,
      sampleAlphaToCoverage, cullFace

## Face Modes

@docs FaceMode, front, back, frontAndBack

-}

import WebGL.Settings.Internal as I


{-| Lets you customize how an `Entity` is rendered. So if you only want to see
the red part of your entity, you would use [`entityWith`](WebGL#entityWith) and
[`colorMask`](#colorMask) to say:

    entityWith [colorMask True False False False]
        vertShader fragShader mesh uniforms

    -- vertShader : Shader attributes uniforms varyings
    -- fragShader : Shader {} uniforms varyings
    -- mesh : Mesh attributes
    -- uniforms : uniforms

-}
type alias Setting =
    I.Setting


{-| Set the scissor box, which limits the drawing of fragments to the
screen to a specified rectangle.

The arguments are the coordinates of the lower left corner, width and height.

-}
scissor : Int -> Int -> Int -> Int -> Setting
scissor =
    I.Scissor


{-| Specify whether or not each channel (red, green, blue, alpha)
should be written into the frame buffer.
-}
colorMask : Bool -> Bool -> Bool -> Bool -> Setting
colorMask =
    I.ColorMask


{-| Dither color components or indices before they
are written to the color buffer.
-}
dither : Setting
dither =
    I.Dither


{-| Add an offset to depth values of a polygon's fragments produced by
rasterization. The offset is added before the depth test is performed and
before the value is written into the depth buffer.

* the first argument is the scale factor for the variable depth offset for
  each polygon;
* the second argument is the multiplier by which an implementation-specific
  value is multiplied
  with to create a constant depth offset.
-}
polygonOffset : Float -> Float -> Setting
polygonOffset =
    I.PolygonOffset


{-| Specify multisample coverage parameters.

The fragment's coverage is ANDed with the temporary coverage value.

* the first argument specifies sample coverage value, that is clamped to
  the range 0 1;
* the second argument represents if the coverage masks should be inverted.
-}
sampleCoverage : Float -> Bool -> Setting
sampleCoverage =
    I.SampleCoverage


{-| Compute a temporary coverage value, where each bit is determined by the
alpha value at the corresponding sample location.

The temporary coverage value is then ANDed with the fragment coverage value.
-}
sampleAlphaToCoverage : Setting
sampleAlphaToCoverage =
    I.SampleAlphaToCoverage


{-| Excludes polygons based on winding (the order of the vertices) in window
coordinates. Polygons with counter-clock-wise winding are front-facing.
-}
cullFace : FaceMode -> Setting
cullFace (FaceMode faceMode) =
    I.CullFace faceMode


{-| The `FaceMode` defines the face of the polygon.
-}
type FaceMode
    = FaceMode Int


{-| Targets the front-facing polygons.
-}
front : FaceMode
front =
    FaceMode 1028


{-| Targets the back-facing polygons.
-}
back : FaceMode
back =
    FaceMode 1029


{-| Targets both front- and back-facing polygons.
-}
frontAndBack : FaceMode
frontAndBack =
    FaceMode 1032
