module Main exposing (main)

-- A test case for https://github.com/elm-community/elm-webgl/issues/23
-- WebGL should render a blue triangle before the first virtual-dom diffing

import Html exposing (Html)
import Html.Attributes exposing (width, height, style)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import WebGL exposing (Mesh, Shader)


main : Html ()
main =
    WebGL.toHtml
        [ width 400, height 400, style [ ( "display", "block" ) ] ]
        [ WebGL.entity
            [glsl|
                attribute vec3 position;
                uniform float scale;
                void main() {
                   gl_Position = vec4(scale * position, 1);
                }
            |]
            [glsl|
                precision mediump float;
                uniform vec3 color;
                void main() {
                  gl_FragColor = vec4(color, 1);
                }
            |]
            (WebGL.triangles
                [ ( { position = vec3 1 0 0 }
                  , { position = vec3 -1 1 0 }
                  , { position = vec3 -1 -1 0 }
                  )
                ]
            )
            { scale = 0.5, color = vec3 0 0 1 }
        ]
