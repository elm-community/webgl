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
        , renderWith
        , toHtml
        , toHtmlWith
        , unsafeShader
        )

{-| The WebGL API is for high performance rendering. Definitely read about
[how WebGL works](https://github.com/elm-community/webgl/blob/master/README.md)
and look at some examples before trying to do too much with just the
documentation provided here.

# Mesh
@docs Drawable, triangles

Please find other kinds of drawables in the [corresponding section](#drawables).

# Shaders
@docs Shader, Texture

# Renderables
@docs Renderable, render

# WebGL Html
@docs toHtml

# Advanced Usage
@docs renderWith, toHtmlWith

# Other Drawables
@docs indexedTriangles, lines, lineStrip, lineLoop, points, triangleFan,
      triangleStrip

# Unsafe Shader Creation (for library writers)
@docs unsafeShader
-}

import Html exposing (Html, Attribute)
import WebGL.Settings as Settings exposing (Setting)
import Native.WebGL
import WebGL.Options as Options exposing (Option)


{-| Defines the mesh by forming geometry from the specified vertices.
Each vertex contains a bunch of attributes, that should be defined as
a custom record type, e.g.:

```
type alias Attributes =
    { position : Vec3
    , color : Vec3
    }
```

The supported types in attributes are: `Int`, `Float`, `WebGL.Texture`
and `Vec2`, `Vec3`, `Vec4`, `Mat4` from the
[linear-algebra](http://package.elm-lang.org/packages/elm-community/linear-algebra/latest)
package.
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
to form any shape.

So when you create `triangles` you are really providing three sets of attributes
that describe the corners of each triangle.
-}
triangles : List ( attributes, attributes, attributes ) -> Drawable attributes
triangles =
    Triangles


{-| Creates a strip of triangles where each additional vertex creates an
additional triangle once the first three vertices have been drawn.
-}
triangleStrip : List attributes -> Drawable attributes
triangleStrip =
    TriangleStrip


{-| Similar to `triangleStrip`, but creates a fan shaped output.
-}
triangleFan : List attributes -> Drawable attributes
triangleFan =
    TriangleFan


{-| IndexedTriangles is a special mode in which you provide a list of attributes
that describe the vertices and and a list of indices, that are grouped in sets
of three that refer to the vertices that form each triangle.
-}
indexedTriangles : List attributes -> List ( Int, Int, Int ) -> Drawable attributes
indexedTriangles =
    IndexedTriangles


{-| Connects each pair of vertices with a line.
-}
lines : List ( attributes, attributes ) -> Drawable attributes
lines =
    Lines


{-| Connects each two subsequent vertices in the list with a line.
-}
lineStrip : List attributes -> Drawable attributes
lineStrip =
    LineStrip


{-| Similar to `lineStrip`, but connects the last vertex back to the first.
-}
lineLoop : List attributes -> Drawable attributes
lineLoop =
    LineLoop


{-| Draws a single dot per vertex.
-}
points : List attributes -> Drawable attributes
points =
    Points


{-| Shaders are programs for running many computations on the GPU in parallel.
They are written in a language called
[GLSL](http://en.wikipedia.org/wiki/OpenGL_Shading_Language). Read more about
shaders [here](https://github.com/elm-community/webgl/blob/master/README.md).

Normally you specify a shader with a `glsl[| |]` block. This is because shaders
must be compiled before they are used, imposing an overhead that is best
avoided in general.

* `attributes` is a record type that defines [vertices in the mesh](#mesh);
* `uniforms` is a record type where you may pass custom parameters like
  transformation matrix, texture, screen size, etc.;
* `varyings` is a record type that defines the output from the shader.

Elm compiler will parse the shader code block and derive the type
signature for your shader.
-}
type Shader attributes uniforms varyings
    = Shader


{-| Creates a shader with a raw string of GLSL. It is intended specifically
for library writers, who want to create shader combinators.
-}
unsafeShader : String -> Shader attributes uniforms varyings
unsafeShader =
    Native.WebGL.unsafeCoerceGLSL


{-| Use Texture to pass the sampler2D uniform value to the shader. Please
find more about textures in `WebGL.Texture`.
-}
type Texture
    = Texture


{-| Conceptually, an encapsulation of the instructions to render something.
-}
type Renderable
    = Renderable


{-| Packages a vertex shader, a fragment shader, a mesh, and uniforms
as a `Renderable`. This specifies a full rendering pipeline to be run
on the GPU. You can read more about the pipeline
[here](https://github.com/elm-community/webgl/blob/master/README.md).

Values will be cached intelligently, so if you have already sent a shader or
mesh to the GPU, it will not be resent. This means it is fairly cheap to create
new renderables if you are reusing shaders and meshes that have been used
before.

By default, depth test setting is enabled for you. If you need more settings,
like stencil test, blending, etc., then check `renderWith`.
-}
render :
    Shader attributes uniforms varyings
    -> Shader {} uniforms varyings
    -> Drawable attributes
    -> uniforms
    -> Renderable
render =
    renderWith [ Settings.depth Settings.depthOptions ]


{-| The same as `render`, but allows to configure a renderable with a list
of settings. Check `WebGL.Settings` for the possible values.
-}
renderWith :
    List Setting
    -> Shader attributes uniforms varyings
    -> Shader {} uniforms varyings
    -> Drawable attributes
    -> uniforms
    -> Renderable
renderWith =
    Native.WebGL.render


{-| Render a WebGL scene with the given options, html attributes, and
renderables.

Shaders and meshes are cached so that they do not get resent to the GPU,
so it should be relatively cheap to create new renderables out of existing
values.

By default, alpha channel with premultiplied alpha, antialias and depth buffer
options are enabled. If you need more options, please check `toHtmlWith`.
-}
toHtml : List (Attribute msg) -> List Renderable -> Html msg
toHtml =
    toHtmlWith [ Options.alpha True, Options.antialias, Options.depth 1 ]


{-| Render a WebGL scene with the given list of options,
html attributes, and renderables.

Please note that due to browser limitations, options will be applied only once
when the canvas is created for the first time.

Check `WebGL.Options` for all possible options.
-}
toHtmlWith : List Option -> List (Attribute msg) -> List Renderable -> Html msg
toHtmlWith options attributes renderables =
    Native.WebGL.toHtml options attributes renderables
