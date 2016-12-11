module WebGL.Texture
    exposing
        ( Texture
        , Error
        , TextureFilter(..)
        , load
        , loadWith
        , size
        )

{-| # Types
@docs Texture, TextureFilter, Error

# Loading Textures
@docs load, loadWith, size
-}

import Task exposing (Task)
import WebGL
import Native.Texture


{-| Textures can be passed in `uniforms`, and used in the fragment shader.
You can created a texture with `load` or `loadWith`.
-}
type alias Texture =
    WebGL.Texture


{-| Textures work in two ways when looking up a pixel value: Linear or Nearest.
-}
type TextureFilter
    = Linear
    | Nearest


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
    loadWith Linear


{-| Loads a texture from the given url. PNG and JPEG are known to work, but
other formats have not been as well-tested yet. Configurable filter.
-}
loadWith : TextureFilter -> String -> Task Error Texture
loadWith =
    Native.Texture.loadWith


{-| Return the (width, height) size of a texture. Useful for sprite sheets
or other times you may want to use only a potion of a texture image.
-}
size : Texture -> ( Int, Int )
size =
    Native.Texture.size
