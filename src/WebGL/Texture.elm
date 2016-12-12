module WebGL.Texture
    exposing
        ( Texture
        , Error
        , load
        , loadWith
        , TextureOptions
        , textureOptions
        , MagnifyingFilter
        , magnifyLinear
        , magnifyNearest
        , MinifyingFilter
        , linear
        , nearest
        , nearestMipmapNearest
        , linearMipmapNearest
        , nearestMipmapLinear
        , linearMipmapLinear
        , TextureWrap
        , repeat
        , clampToEdge
        , mirroredRepeat
        , size
        )

{-| # Texture
@docs Texture, load, Error, size

# Custom Loading
@docs loadWith, TextureOptions, textureOptions

## Magnifying Filter
@docs MagnifyingFilter, magnifyLinear, magnifyNearest

## Minifying Filter
@docs MinifyingFilter, nearestMipmapLinear, linear, nearest,
      nearestMipmapNearest, linearMipmapNearest, linearMipmapLinear

## Wrapping Texture
@docs TextureWrap, repeat, clampToEdge, mirroredRepeat

# Measuring
@docs size
-}

import Task exposing (Task)
import WebGL
import Native.Texture


{-| Textures can be passed in `uniforms`, and used in the fragment shader.
You can create a texture with `load` or `loadWith` and measure its dimesions
with `size`.
-}
type alias Texture =
    WebGL.Texture


{-| Loads a texture from the given url with default options.
PNG and JPEG are known to work, but other formats have not been as
well-tested yet.

The Y axis of the texture is flipped automatically for you, so it has
the same direction as in the clip-space, i.e. pointing up.

If you need to change wrapping or filtering, you can use `loadWith`.
-}
load : String -> Task Error Texture
load =
    loadWith textureOptions


{-| An error which occurred while loading a texture.
-}
type Error
    = Error


{-| Same as
-}
loadWith : TextureOptions -> String -> Task Error Texture
loadWith options url =
    Native.Texture.loadWith options url


{-| Possible options when loading a texture

* `magnifyingFilter` - texture magnification filter,
  the default is `magnifyLinear`;
* `minifyingFilter` - texture minification filter,
  the default is `nearestMipmapLinear`;
* `horizontalWrap` - wrapping function for texture coordinate s,
  the default is `repeat`;
* `verticalWrap` - wrapping function for texture coordinate t,
  the default is `repeat`.

You can read more about these parameters in the
[specification](https://www.khronos.org/opengles/sdk/docs/man/xhtml/glTexParameter.xml).
-}
type alias TextureOptions =
    { magnifyingFilter : MagnifyingFilter
    , minifyingFilter : MinifyingFilter
    , horizontalWrap : TextureWrap
    , verticalWrap : TextureWrap
    }


{-| Default options for texture loading.
-}
textureOptions : TextureOptions
textureOptions =
    { magnifyingFilter = magnifyLinear
    , minifyingFilter = nearestMipmapLinear
    , horizontalWrap = repeat
    , verticalWrap = repeat
    }


{-| The texture magnification filter is used when the pixel being textured
maps to an area less than or equal to one texture element.
-}
type MagnifyingFilter
    = MagnifyingFilter Int


{-| Returns the weighted average of the four texture elements that are closest
to the center of the pixel being textured. This is the default value of
magnifying filter.
-}
magnifyLinear : MagnifyingFilter
magnifyLinear =
    MagnifyingFilter 9729


{-| Returns the value of the texture element that is nearest (in Manhattan
distance) to the center of the pixel being textured.
-}
magnifyNearest : MagnifyingFilter
magnifyNearest =
    MagnifyingFilter 9728


{-| The texture minifying filter is used whenever the pixel being
textured maps to an area greater than one texture element.
-}
type MinifyingFilter
    = MinifyingFilter Int


{-| Chooses the mipmap that most closely matches the size of the pixel being
textured and uses the `nearest` criterion (the texture element nearest to
the center of the pixel) to produce a texture value.

A mipmap is an ordered set of arrays representing the same image at
progressively lower resolutions.

This is the default value of the minifying filter.
-}
nearestMipmapNearest : MinifyingFilter
nearestMipmapNearest =
    MinifyingFilter 9984


{-| Returns the weighted average of the four texture elements that are closest
to the center of the pixel being textured.
-}
linear : MinifyingFilter
linear =
    MinifyingFilter 9729


{-| Returns the value of the texture element that is nearest
(in Manhattan distance) to the center of the pixel being textured.
-}
nearest : MinifyingFilter
nearest =
    MinifyingFilter 9728


{-| Chooses the mipmap that most closely matches the size of the pixel being
textured and uses the `linear` criterion (a weighted average of the four
texture elements that are closest to the center of the pixel) to produce a
texture value.
-}
linearMipmapNearest : MinifyingFilter
linearMipmapNearest =
    MinifyingFilter 9985


{-| Chooses the two mipmaps that most closely match the size of the pixel being
textured and uses the `nearest` criterion (the texture element nearest to the
center of the pixel) to produce a texture value from each mipmap. The final
texture value is a weighted average of those two values.
-}
nearestMipmapLinear : MinifyingFilter
nearestMipmapLinear =
    MinifyingFilter 9986


{-| Chooses the two mipmaps that most closely match the size of the pixel being
textured and uses the `linear` criterion (a weighted average of the four
texture elements that are closest to the center of the pixel) to produce a
texture value from each mipmap. The final texture value is a weighted average
of those two values.
-}
linearMipmapLinear : MinifyingFilter
linearMipmapLinear =
    MinifyingFilter 9987


{-| Sets the wrap parameter for texture coordinate.
-}
type TextureWrap
    = TextureWrap Int


{-| Causes the integer part of the coordinate to be ignored. This is the
default value for both texture axis.
-}
repeat : TextureWrap
repeat =
    TextureWrap 10497


{-| Causes coordinates to be clamped to the range 1 2N 1 - 1 2N, where N is
the size of the texture in the direction of clamping.
-}
clampToEdge : TextureWrap
clampToEdge =
    TextureWrap 33071


{-| Causes the coordinate c to be set to the fractional part of the texture
coordinate if the integer part is even; if the integer part is odd, then
the coordinate is set to 1 - frac, where frac represents the fractional part
of the coordinate.
-}
mirroredRepeat : TextureWrap
mirroredRepeat =
    TextureWrap 33648


{-| Return the (width, height) size of a texture. Useful for sprite sheets
or other times you may want to use only a potion of a texture image.
-}
size : Texture -> ( Int, Int )
size =
    Native.Texture.size
