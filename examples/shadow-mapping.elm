module Main exposing (main)

import AnimationFrame
import Color exposing (Color)
import Html exposing (Html)
import Html.Attributes exposing (width, height, style)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector3 as Vec3 exposing (vec3, Vec3)
import Math.Vector4 as Vec4 exposing (vec4, Vec4)
import Time exposing (Time)
import WebGL exposing (Mesh, Shader)
import WebGL.Texture as Texture exposing (Texture, FrameBuffer, defaultOptions)


main : Program Never Float Time
main =
    Html.program
        { init = ( 0, Cmd.none )
        , view = view
        , subscriptions = (\_ -> AnimationFrame.diffs Basics.identity)
        , update = (\dt theta -> ( theta + dt / 1000, Cmd.none ))
        }


view : Float -> Html Time
view theta =
    case maybeFrameBuffer of
        Just frameBuffer ->
            WebGL.toHtml
                [ width 600
                , height 600
                , style [ ( "display", "block" ) ]
                ]
                [ WebGL.entity
                    vertexShader
                    fragmentShader
                    cubeMesh
                    (uniforms theta frameBuffer)
                , WebGL.entity
                    vertexShader
                    fragmentShader
                    planeMesh
                    (uniforms theta frameBuffer)
                ]

        Nothing ->
            Html.text "no texture"


type alias Uniforms =
    { perspective : Mat4
    , camera : Mat4
    , lightMViewMatrix : Mat4
    , lightProjectionMatrix : Mat4
    , texture : Texture
    }


uniforms : Float -> FrameBuffer -> Uniforms
uniforms theta frameBuffer =
    let
        lightUniforms =
            { perspective = Mat4.makeOrtho -7 7 -7 7 -7 50
            , camera = Mat4.makeLookAt (vec3 (sin theta) 1 (-1 * cos theta)) (vec3 0 0 0) (vec3 0 1 0)
            }
    in
        { perspective = Mat4.makePerspective (180 / 3) 1 0.01 100
        , camera = Mat4.makeLookAt (vec3 5 10 10) (vec3 0 0 0) (vec3 0 1 0)
        , lightMViewMatrix = lightUniforms.camera
        , lightProjectionMatrix = lightUniforms.perspective
        , texture =
            Texture.fromEntities
                frameBuffer
                [ WebGL.entity
                    lightVertexShader
                    lightFragmentShader
                    cubeMesh
                    lightUniforms
                , WebGL.entity
                    lightVertexShader
                    lightFragmentShader
                    planeMesh
                    lightUniforms
                ]
        }


type alias LightUniforms =
    { perspective : Mat4
    , camera : Mat4
    }



-- Mesh


type alias Vertex =
    { color : Vec3
    , position : Vec3
    }


planeMesh : Mesh Vertex
planeMesh =
    let
        lb =
            vec3 -5 -2 5

        rb =
            vec3 5 -2 5

        rt =
            vec3 5 -2 -5

        lt =
            vec3 -5 -2 -5
    in
        face Color.grey rb rt lt lb
            |> WebGL.triangles


cubeMesh : Mesh Vertex
cubeMesh =
    let
        rft =
            vec3 1 1 1

        lft =
            vec3 -1 1 1

        lbt =
            vec3 -1 -1 1

        rbt =
            vec3 1 -1 1

        rbb =
            vec3 1 -1 -1

        rfb =
            vec3 1 1 -1

        lfb =
            vec3 -1 1 -1

        lbb =
            vec3 -1 -1 -1
    in
        [ face Color.green rft rfb rbb rbt
        , face Color.blue rft rfb lfb lft
        , face Color.yellow rft lft lbt rbt
        , face Color.red rfb lfb lbb rbb
        , face Color.purple lft lfb lbb lbt
        , face Color.orange rbt rbb lbb lbt
        ]
            |> List.concat
            |> WebGL.triangles


face : Color -> Vec3 -> Vec3 -> Vec3 -> Vec3 -> List ( Vertex, Vertex, Vertex )
face rawColor a b c d =
    let
        color =
            let
                c =
                    Color.toRgb rawColor
            in
                vec3
                    (toFloat c.red / 255)
                    (toFloat c.green / 255)
                    (toFloat c.blue / 255)

        vertex position =
            Vertex color position
    in
        [ ( vertex a, vertex b, vertex c )
        , ( vertex c, vertex d, vertex a )
        ]



-- Shaders


vertexShader : Shader Vertex Uniforms { vcolor : Vec3, shadowPos : Vec4 }
vertexShader =
    [glsl|

        attribute vec3 position;
        attribute vec3 color;
        uniform mat4 perspective;
        uniform mat4 camera;
        varying vec3 vcolor;

        //attribute vec3 aVertexPosition;
        //uniform mat4 uPMatrix;
        //uniform mat4 uMVMatrix;
        uniform mat4 lightMViewMatrix;
        uniform mat4 lightProjectionMatrix;
        // Used to normalize our coordinates from clip space to (0 - 1)
        // so that we can access the corresponding point in our depth color texture
        const mat4 texUnitConverter = mat4(0.5, 0.0, 0.0, 0.0, 0.0, 0.5, 0.0, 0.0, 0.0, 0.0, 0.5, 0.0, 0.5, 0.5, 0.5, 1.0);
        //varying vec2 vDepthUv;
        varying vec4 shadowPos;

        void main (void) {
          gl_Position = perspective * camera * vec4(position, 1.0);
          vcolor = color;
          shadowPos = texUnitConverter * lightProjectionMatrix * lightMViewMatrix * vec4(position, 1.0);
        }

    |]


fragmentShader : Shader {} Uniforms { vcolor : Vec3, shadowPos : Vec4 }
fragmentShader =
    [glsl|
        precision mediump float;
        varying vec3 vcolor;
        varying vec4 shadowPos;
        uniform sampler2D texture;
        //uniform vec3 uColor;
        float decodeFloat (vec4 color) {
          const vec4 bitShift = vec4(
            1.0 / (256.0 * 256.0 * 256.0),
            1.0 / (256.0 * 256.0),
            1.0 / 256.0,
            1
          );
          return dot(color, bitShift);
        }
        void main(void) {
          vec3 fragmentDepth = shadowPos.xyz;
          float shadowAcneRemover = 0.007;
          fragmentDepth.z -= shadowAcneRemover;
          float texelSize = 1.0 / 1024.0;
          float amountInLight = 0.0;
          for (int x = -1; x <= 1; x++) {
            for (int y = -1; y <= 1; y++) {
              float texelDepth = decodeFloat(texture2D(texture, fragmentDepth.xy + vec2(x, y) * texelSize));
              if (fragmentDepth.z < texelDepth) {
                amountInLight += 1.0;
              }
            }
          }
          amountInLight /= 9.0;

          gl_FragColor = vec4(amountInLight * vcolor, 1.0);
        }
    |]


lightVertexShader : Shader Vertex LightUniforms {}
lightVertexShader =
    [glsl|
        attribute vec3 position;
        uniform mat4 perspective;
        uniform mat4 camera;
        void main (void) {
          gl_Position = perspective * camera * vec4(position, 1.0);
        }
     |]


lightFragmentShader : Shader a b {}
lightFragmentShader =
    [glsl|
        precision mediump float;
        vec4 encodeFloat (float depth) {
          const vec4 bitShift = vec4(
            256 * 256 * 256,
            256 * 256,
            256,
            1.0
          );
          const vec4 bitMask = vec4(
            0,
            1.0 / 256.0,
            1.0 / 256.0,
            1.0 / 256.0
          );
          vec4 comp = fract(depth * bitShift);
          comp -= comp.xxyz * bitMask;
          return comp;
        }
        void main (void) {
          gl_FragColor = encodeFloat(gl_FragCoord.z);
        }
    |]


maybeFrameBuffer : Maybe FrameBuffer
maybeFrameBuffer =
    Texture.frameBuffer
        { defaultOptions
            | flipY = False
            , minify = Texture.linear
            , magnify = Texture.linear
        }
        ( 1024, 1024 )
        |> Result.toMaybe