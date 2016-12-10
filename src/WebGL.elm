module WebGL
    exposing
        ( Texture
        , Shader
        , Renderable
        , Drawable
        , triangles
        , indexedTriangles
        , lines
        , lineStrip
        , lineLoop
        , points
        , triangleFan
        , triangleStrip
        , render
        , renderWithSettings
        , toHtml
        , toHtmlWith
        , unsafeShader
        )

{-| The WebGL API is for high performance rendering. Definitely read about
[how WebGL works](https://github.com/elm-community/webgl/blob/master/README.md)
and look at some examples before trying to do too much with just the
documentation provided here.

# Main Types
@docs Shader, Renderable, Texture

# Drawables
@docs Drawable, triangles, indexedTriangles, lines, lineStrip, lineLoop, points, triangleFan, triangleStrip

# Renderables
@docs render, renderWithSettings

# WebGL Html
@docs toHtml, toHtmlWith

# Unsafe Shader Creation (for library writers)
@docs unsafeShader

-}

import Html exposing (Html, Attribute)
import WebGL.Settings as Settings exposing (Setting)
import Native.WebGL
import WebGL.Options as Options exposing (Option)


{-|
WebGL has a number of rendering modes available.
See: [Library reference](https://msdn.microsoft.com/en-us/library/dn302395%28v=vs.85%29.aspx) for the description of each type.
-}
type Drawable attributes
    = Triangles (List ( attributes, attributes, attributes ))
    | Lines (List ( attributes, attributes ))
    | LineStrip (List attributes)
    | LineLoop (List attributes)
    | Points (List attributes)
    | TriangleFan (List attributes)
    | TriangleStrip (List attributes)
    | IndexedTriangles (List attributes) (List ( Int, Int, Int ))


{-| Triangles are the basic building blocks of a mesh. You can put them together
to form any shape. Each corner of a triangle is called a *vertex* and contains a
bunch of *attributes* that describe that particular corner. These attributes can
be things like position and color.

So when you create `triangles` you are really providing three sets of attributes
that describe the corners of each triangle.
-}
triangles : List ( attributes, attributes, attributes ) -> Drawable attributes
triangles =
    Triangles


{-|
-}
triangleFan : List attributes -> Drawable attributes
triangleFan =
    TriangleFan


{-|
-}
triangleStrip : List attributes -> Drawable attributes
triangleStrip =
    TriangleStrip


{-| IndexedTriangles is a special mode in which you provide a list of attributes
that describe the vertexes and and a list of indices, that are grouped in sets
of three that refer to the vertexes that form each triangle.
-}
indexedTriangles : List attributes -> List ( Int, Int, Int ) -> Drawable attributes
indexedTriangles =
    IndexedTriangles


{-|
-}
lines : List ( attributes, attributes ) -> Drawable attributes
lines =
    Lines


{-|
-}
lineStrip : List attributes -> Drawable attributes
lineStrip =
    LineStrip


{-|
-}
lineLoop : List attributes -> Drawable attributes
lineLoop =
    LineLoop


{-|
-}
points : List attributes -> Drawable attributes
points =
    Points


{-| `Shader` is a phantom data type.
-}
type Shader attributes uniforms varyings
    = Shader


{-| Shaders are programs for running many computations on the GPU in parallel.
They are written in a language called
[GLSL](http://en.wikipedia.org/wiki/OpenGL_Shading_Language). Read more about
shaders [here](https://github.com/elm-community/webgl/blob/master/README.md).

Normally you specify a shader with a `glsl` block. This is because shaders
must be compiled before they are used, imposing an overhead that is best avoided in general. This function lets you create a shader with a raw string of
GLSL. It is intended specifically for library writers who want to create shader
combinators.
-}
unsafeShader : String -> Shader attribute uniform varying
unsafeShader =
    Native.WebGL.unsafeCoerceGLSL


{-| `Texture` is a phantom data type, can be
created with `Texture.load` or `Texture.loadWith`
-}
type Texture
    = Texture


{-| Conceptually, an encapsulation of the instructions to render something
-}
type Renderable
    = Renderable


{-| Packages a vertex shader, a fragment shader, a mesh, and uniforms
as a `Renderable`. This specifies a full rendering pipeline to be run on the GPU.
You can read more about the pipeline
[here](https://github.com/elm-community/webgl/blob/master/README.md).

Values will be cached intelligently, so if you have already sent a shader or
mesh to the GPU, it will not be resent. This means it is fairly cheap to create
new entities if you are reusing shaders and meshes that have been used before.
-}
renderWithSettings : List Setting -> Shader attributes uniforms varyings -> Shader {} uniforms varyings -> Drawable attributes -> uniforms -> Renderable
renderWithSettings =
    Native.WebGL.render


{-| Same as `renderWithConfig` but without using
custom per-render configurations.
-}
render : Shader attributes uniforms varyings -> Shader {} uniforms varyings -> Drawable attributes -> uniforms -> Renderable
render =
    renderWithSettings [ Settings.depth Settings.depthOptions ]


{-| Render a WebGL scene with the given options, html attributes, and entities.

Shaders and meshes are cached so that they do not get resent to the GPU,
so it should be relatively cheap to create new entities out of existing values.

By default, alpha channel with premultiplied alpha, antialias and depth buffer
options are enabled. If you need more options, please check `toHtmlWith`.
-}
toHtml : List (Attribute msg) -> List Renderable -> Html msg
toHtml =
    toHtmlWith [ Options.alpha True, Options.antialias, Options.depth 1 ]


{-| Render a WebGL scene with the given options, html attributes, and entities.

Please note that due to browser limitations, options will be applied only once
when the canvas is created for the first time.

-}
toHtmlWith : List Option -> List (Attribute msg) -> List Renderable -> Html msg
toHtmlWith options attributes renderables =
    Native.WebGL.toHtml options attributes renderables
