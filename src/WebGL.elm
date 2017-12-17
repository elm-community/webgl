module WebGL
    exposing
        ( Texture
        , Shader
        , Entity
        , Mesh
        , triangles
        , indexedTriangles
        , lines
        , lineStrip
        , lineLoop
        , points
        , triangleFan
        , triangleStrip
        , entity
        , entityWith
        , toHtml
        , toHtmlWith
        , Option
        , alpha
        , depth
        , stencil
        , antialias
        , clearColor
        , unsafeShader
        )

{-| The WebGL API is for high performance rendering. Definitely read about
[how WebGL works](http://package.elm-lang.org/packages/elm-community/webgl/latest)
and look at [some examples](https://github.com/elm-community/webgl/tree/master/examples)
before trying to do too much with just the documentation provided here.

# Mesh
@docs Mesh, triangles

# Shaders
@docs Shader, Texture

# Entities
@docs Entity, entity

# WebGL Html
@docs toHtml

# Advanced Usage
@docs entityWith, toHtmlWith, Option, alpha, depth, stencil, antialias,
  clearColor

# Meshes
@docs indexedTriangles, lines, lineStrip, lineLoop, points, triangleFan,
  triangleStrip

# Unsafe Shader Creation (for library writers)
@docs unsafeShader
-}

import Html exposing (Html, Attribute)
import WebGL.Settings as Settings exposing (Setting)
import WebGL.Settings.DepthTest as DepthTest
import Native.WebGL


{-| Mesh forms geometry from the specified vertices. Each vertex contains a
bunch of attributes, defined as a custom record type, e.g.:

    type alias Attributes =
        { position : Vec3
        , color : Vec3
        }

The supported types in attributes are: `Int`, `Float`, `WebGL.Texture`
and `Vec2`, `Vec3`, `Vec4`, `Mat4` from the
[linear-algebra](http://package.elm-lang.org/packages/elm-community/linear-algebra/latest)
package.

Do not generate meshes in `view`, [read more about this here](http://package.elm-lang.org/packages/elm-community/webgl/latest#making-the-most-of-the-gpu).
-}
type Mesh attributes
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
triangles : List ( attributes, attributes, attributes ) -> Mesh attributes
triangles =
    Triangles


{-| Creates a strip of triangles where each additional vertex creates an
additional triangle once the first three vertices have been drawn.
-}
triangleStrip : List attributes -> Mesh attributes
triangleStrip =
    TriangleStrip


{-| Similar to [`triangleStrip`](#triangleStrip), but creates a fan shaped
output.
-}
triangleFan : List attributes -> Mesh attributes
triangleFan =
    TriangleFan


{-| Create triangles from vertices and indices, grouped in sets of three to
define each triangle by refering the vertices.

This helps to avoid duplicated vertices whenever two triangles share an
edge. For example, if you want to define a rectangle using
[`triangles`](#triangles), `v0` and `v2` will have to be duplicated:

    -- v2 +---+ v1
    --    |\  |
    --    | \ |
    --    |  \|
    -- v3 +---+ v0

    rectangle =
        triangles [(v0, v1, v2), (v2, v3, v0)]

This will use two vertices less:

    rectangle =
        indexedTriangles [v0, v1, v2, v3] [(0, 1, 2), (2, 3, 0)]
-}
indexedTriangles : List attributes -> List ( Int, Int, Int ) -> Mesh attributes
indexedTriangles =
    IndexedTriangles


{-| Connects each pair of vertices with a line.
-}
lines : List ( attributes, attributes ) -> Mesh attributes
lines =
    Lines


{-| Connects each two subsequent vertices with a line.
-}
lineStrip : List attributes -> Mesh attributes
lineStrip =
    LineStrip


{-| Similar to [`lineStrip`](#lineStrip), but connects the last vertex back to
the first.
-}
lineLoop : List attributes -> Mesh attributes
lineLoop =
    LineLoop


{-| Draws a single dot per vertex.
-}
points : List attributes -> Mesh attributes
points =
    Points


{-| Shaders are programs for running many computations on the GPU in parallel.
They are written in a language called
[GLSL](http://en.wikipedia.org/wiki/OpenGL_Shading_Language). Read more about
shaders [here](https://github.com/elm-community/webgl/blob/master/README.md).

Normally you specify a shader with a `glsl[| |]` block. Elm compiler will parse
the shader code block and derive the type signature for your shader.

* `attributes` define vertices in the [mesh](#Mesh);
* `uniforms` allow you to pass scene parameters like
  transformation matrix, texture, screen size, etc.;
* `varyings` define the output from the vertex shader.

`attributes`, `uniforms` and `varyings` are records with the fields of the
following types: `Int`, `Float`, [`Texture`](#Texture) and `Vec2`, `Vec3`, `Vec4`,
`Mat4` from the
[linear-algebra](http://package.elm-lang.org/packages/elm-community/linear-algebra/latest)
package.
-}
type Shader attributes uniforms varyings
    = Shader


{-| Creates a shader with a raw string of GLSL. It is intended specifically
for library writers, who want to create shader combinators.
-}
unsafeShader : String -> Shader attributes uniforms varyings
unsafeShader =
    Native.WebGL.unsafeCoerceGLSL


{-| Use `Texture` to pass the `sampler2D` uniform value to the shader. Find
more about textures in [`WebGL.Texture`](WebGL-Texture).
-}
type Texture
    = Texture


{-| Conceptually, an encapsulation of the instructions to render something.
-}
type Entity
    = Entity


{-| Packages a vertex shader, a fragment shader, a mesh, and uniforms
as an `Entity`. This specifies a full rendering pipeline to be run
on the GPU. You can read more about the pipeline
[here](https://github.com/elm-community/webgl/blob/master/README.md).

The vertex shader receives `attributes` and `uniforms` and returns `varyings`
and `gl_Position`—the position of the vertex on the screen, defined as
`vec4(x, y, z, w)`, that means `(x/w, y/w, z/w)` in the clip space coordinates:

    --   (-1,1,1) +================+ (1,1,1)
    --           /|               /|
    --          / |     |        / |
    --(-1,1,-1)+================+ (1,1,-1)
    --         |  |     | /     |  |
    --         |  |     |/      |  |
    --         |  |     +-------|->|
    -- (-1,-1,1|) +--(0,0,0)----|--+ (1,-1,1)
    --         | /              | /
    --         |/               |/
    --         +================+
    --   (-1,-1,-1)         (1,-1,-1)

The fragment shader is called for each pixel inside the clip space with
`varyings` and `uniforms` and returns `gl_FragColor`—the color of
the pixel, defined as `vec4(r, g, b, a)` where each color component is a float
from 0 to 1.

Shaders and a mesh are cached so that they do not get resent to the GPU.
It should be relatively cheap to create new entities out of existing
values.

By default, [depth test](WebGL-Settings-DepthTest#default) is enabled for you.
If you need more [settings](WebGL-Settings), like
[blending](WebGL-Settings-Blend) or [stencil test](WebG-Settings-StencilTest),
then use [`entityWith`](#entityWith).

    entity =
        entityWith [ DepthTest.default ]
-}
entity :
    Shader attributes uniforms varyings
    -> Shader {} uniforms varyings
    -> Mesh attributes
    -> uniforms
    -> Entity
entity =
    entityWith [ DepthTest.default ]


{-| The same as [`entity`](#entity), but allows to configure an entity with
[settings](WebGL-Settings).
-}
entityWith :
    List Setting
    -> Shader attributes uniforms varyings
    -> Shader {} uniforms varyings
    -> Mesh attributes
    -> uniforms
    -> Entity
entityWith =
    Native.WebGL.entity


{-| Render a WebGL scene with the given html attributes, and entities.

`width` and `height` html attributes resize the drawing buffer, while
the corresponding css properties scale the canvas element.

To prevent blurriness on retina screens, you may want the drawing buffer 
to be twice the size of the canvas element.

To remove an extra whitespace around the canvas, set `display: block`.

By default, alpha channel with premultiplied alpha, antialias and depth buffer
are enabled. Use [`toHtmlWith`](#toHtmlWith) for custom options.

    toHtml =
        toHtmlWith [ alpha True, antialias, depth 1 ]
-}
toHtml : List (Attribute msg) -> List Entity -> Html msg
toHtml =
    toHtmlWith [ alpha True, antialias, depth 1 ]


{-| Render a WebGL scene with the given options, html attributes, and entities.

Due to browser limitations, options will be applied only once,
when the canvas is created for the first time.
-}
toHtmlWith : List Option -> List (Attribute msg) -> List Entity -> Html msg
toHtmlWith options attributes entities =
    Native.WebGL.toHtml options attributes entities


{-| Provides a way to enable features and change the scene behavior
in [`toHtmlWith`](#toHtmlWith).
-}
type Option
    = Alpha Bool
    | Depth Float
    | Stencil Int
    | Antialias
    | ClearColor Float Float Float Float


{-| Enable alpha channel in the drawing buffer. If the argument is `True`, then
the page compositor will assume the drawing buffer contains colors with
premultiplied alpha `(r * a, g * a, b * a, a)`.
-}
alpha : Bool -> Option
alpha =
    Alpha


{-| Enable the depth buffer, and prefill it with given value each time before
the scene is rendered. The value is clamped between 0 and 1.
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


{-| Enable multisample antialiasing of the drawing buffer, if supported by
the platform. Useful when you need to have smooth lines and smooth edges of
triangles at a lower cost than supersampling (rendering to larger dimensions and
then scaling down with CSS transform).
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
