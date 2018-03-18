module Main exposing (main)

{-
   Rotating square, that uses a texture
-}

import AnimationFrame
import Html exposing (Html, text)
import Html.Attributes exposing (height, style, width)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector2 as Vec2 exposing (Vec2)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import Time exposing (Time)
import WebGL exposing (Mesh, Shader)
import WebGL.Texture as Texture exposing (Texture, FrameBuffer)


main : Program Never Time Time
main =
    Html.program
        { init = ( 1000, Cmd.none )
        , view = view
        , subscriptions = (\model -> AnimationFrame.diffs Basics.identity)
        , update = (\elapsed currentTime -> ( elapsed + currentTime, Cmd.none ))
        }


view : Float -> Html msg
view t =
    case maybeFrameBuffer of
        Just frameBuffer ->
            WebGL.toHtml
                [ width 400
                , height 400
                , style [ ( "display", "block" ) ]
                ]
                [ WebGL.entity
                    texturedVertexShader
                    texturedFragmentShader
                    texturedMesh
                    { perspective = perspective (t / 1000)
                    , texture = Texture.fromEntities 
                          frameBuffer 
                          [ WebGL.entity vertexShader fragmentShader mesh { brightness = (1 + sin (t / 500) / 2) / 1.5 } ]
                    }
                ]

        Nothing ->
            text "no texture"


perspective : Float -> Mat4
perspective t =
    Mat4.mul
        (Mat4.makePerspective 45 1 0.01 100)
        (Mat4.makeLookAt (vec3 (4 * cos t) 0 (4 * sin t)) (vec3 0 0 0) (vec3 0 1 0))



-- Mesh


type alias Vertex =
    { position : Vec3
    , color : Vec3
    }


type alias TexturedVertex =
    { position : Vec3
    }


mesh : Mesh Vertex
mesh =
    WebGL.triangles
        [ ( Vertex (vec3 -1 1 0) (vec3 1 0 0)
          , Vertex (vec3 1 1 0) (vec3 0 1 0)
          , Vertex (vec3 -1 -1 0) (vec3 1 0 0)
          )
        , ( Vertex (vec3 -1 -1 0) (vec3 1 0 0)
          , Vertex (vec3 1 1 0) (vec3 0 1 0)
          , Vertex (vec3 1 -1 0) (vec3 0 1 0)
          )
        ]


texturedMesh : Mesh TexturedVertex
texturedMesh =
    WebGL.triangles
        [ ( TexturedVertex (vec3 -1 1 0)
          , TexturedVertex (vec3 1 1 0)
          , TexturedVertex (vec3 -1 -1 0)
          )
        , ( TexturedVertex (vec3 -1 -1 0)
          , TexturedVertex (vec3 1 1 0)
          , TexturedVertex (vec3 1 -1 0)
          )
        ]



-- Shaders


type alias Uniforms =
    { perspective : Mat4
    , texture : Texture
    }


maybeFrameBuffer : Maybe FrameBuffer
maybeFrameBuffer =
    Texture.frameBuffer Texture.defaultOptions ( 256, 256 )
        |> Result.toMaybe


vertexShader : Shader Vertex { brightness : Float } { vcolor : Vec3 }
vertexShader =
    [glsl|

        attribute vec3 position;
        attribute vec3 color;
        varying vec3 vcolor;

        void main () {
            gl_Position = vec4(position, 1.0);
            vcolor = color;
        }

    |]


fragmentShader : Shader {} { brightness : Float } { vcolor : Vec3 }
fragmentShader =
    [glsl|

        precision mediump float;
        varying vec3 vcolor;
        uniform float brightness;

        void main () {
            gl_FragColor = vec4(vcolor * brightness, 1.0);
        }

    |]


texturedVertexShader : Shader TexturedVertex Uniforms { vcoord : Vec2 }
texturedVertexShader =
    [glsl|

        attribute vec3 position;
        uniform mat4 perspective;
        varying vec2 vcoord;

        void main () {
            gl_Position = perspective * vec4(position, 1.0);
            vcoord = vec2(position.x + 1.0, position.y + 1.0) / 2.0;
        }

    |]


texturedFragmentShader : Shader {} Uniforms { vcoord : Vec2 }
texturedFragmentShader =
    [glsl|

        precision mediump float;
        uniform sampler2D texture;
        varying vec2 vcoord;

        void main () {
          gl_FragColor = texture2D(texture, vcoord);
        }

    |]
