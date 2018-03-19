module Main exposing (main)

{-
   Rotating square, that uses a texture
-}

import Html exposing (Html, text)
import Html.Attributes exposing (height, style, width)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector2 as Vec2 exposing (Vec2)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import WebGL exposing (Mesh, Shader)
import WebGL.Texture as Texture exposing (Texture, FrameBuffer)
import Crate


main : Program Never Crate.Model Crate.Msg
main =
    Html.program
        { init = Crate.init
        , view = view
        , subscriptions = Crate.subscriptions
        , update = Crate.update
        }


view : Crate.Model -> Html Crate.Msg
view { theta, texture } =
    case (maybeFrameBuffer, texture) of
        (Just frameBuffer, Just tex) ->
            WebGL.toHtmlWith
                [ WebGL.alpha True
                , WebGL.antialias
                , WebGL.depth 1
                , WebGL.stencil 0
                ]
                [ width 400
                , height 400
                , style [ ( "display", "block" ) ]
                ]
                [ WebGL.entity
                    texturedVertexShader
                    texturedFragmentShader
                    texturedMesh
                    { perspective = perspective (-theta * 5)
                    , texture = Texture.fromEntities 
                          frameBuffer 
                          (Crate.scene (Crate.perspective 0) tex)
                    }
                ]

        _ ->
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
    Texture.frameBuffer Texture.defaultOptions ( 512, 512 )
        |> Result.toMaybe

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
