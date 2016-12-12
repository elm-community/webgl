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

{-| # Types
@docs Texture, Error

# Loading
@docs load, loadWith, TextureOptions, textureOptions

## Magnifying Filter
@docs MagnifyingFilter, magnifyLinear, magnifyNearest

## Minifying Filter
@docs MinifyingFilter, linear, nearest, nearestMipmapNearest,
      linearMipmapNearest, nearestMipmapLinear, linearMipmapLinear

## Wrapping Texture
@docs TextureWrap, repeat, clampToEdge, mirroredRepeat

# Measuring
@docs size
-}

import Task exposing (Task)
import WebGL
import Native.Texture


{-| Textures can be passed in `uniforms`, and used in the fragment shader.
You can created a texture with `load` or `loadWith`.
-}
type alias Texture =
    WebGL.Texture


{-|
-}
type alias TextureOptions =
    { magnifyingFilter : MagnifyingFilter
    , minifyingFilter : MinifyingFilter
    , horizontalWrap : TextureWrap
    , verticalWrap : TextureWrap
    }


{-|
-}
textureOptions : TextureOptions
textureOptions =
    { magnifyingFilter = magnifyLinear
    , minifyingFilter = nearestMipmapLinear
    , horizontalWrap = repeat
    , verticalWrap = repeat
    }


{-|
-}
type MagnifyingFilter
    = MagnifyingFilter Int


{-|
-}
magnifyLinear : MagnifyingFilter
magnifyLinear =
    MagnifyingFilter 9729


{-|
-}
magnifyNearest : MagnifyingFilter
magnifyNearest =
    MagnifyingFilter 9728


{-|
-}
type MinifyingFilter
    = MinifyingFilter Int


{-|
-}
linear : MinifyingFilter
linear =
    MinifyingFilter 9729


{-|
-}
nearest : MinifyingFilter
nearest =
    MinifyingFilter 9728


{-|
-}
nearestMipmapNearest : MinifyingFilter
nearestMipmapNearest =
    MinifyingFilter 9984


{-|
-}
linearMipmapNearest : MinifyingFilter
linearMipmapNearest =
    MinifyingFilter 9985


{-|
-}
nearestMipmapLinear : MinifyingFilter
nearestMipmapLinear =
    MinifyingFilter 9986


{-|
-}
linearMipmapLinear : MinifyingFilter
linearMipmapLinear =
    MinifyingFilter 9987


{-|
-}
type TextureWrap
    = TextureWrap Int


{-|
-}
repeat : TextureWrap
repeat =
    TextureWrap 10497


{-|
-}
clampToEdge : TextureWrap
clampToEdge =
    TextureWrap 33071


{-|
-}
mirroredRepeat : TextureWrap
mirroredRepeat =
    TextureWrap 33648


{-| An error which occurred while loading a texture.
-}
type Error
    = Error


{-| Loads a texture from the given url with Linear filtering.
PNG and JPEG are known to work, but other formats have not been as
well-tested yet.
-}
load : String -> Task Error Texture
load =
    loadWith textureOptions


{-| Loads a texture from the given url. PNG and JPEG are known to work, but
other formats have not been as well-tested yet. Configurable filter.
-}
loadWith : TextureOptions -> String -> Task Error Texture
loadWith options url =
    Native.Texture.loadWith options url


{-| Return the (width, height) size of a texture. Useful for sprite sheets
or other times you may want to use only a potion of a texture image.
-}
size : Texture -> ( Int, Int )
size =
    Native.Texture.size
