module Main exposing (main)

{-
   Rotating square, that uses a texture
-}

import Html exposing (Html, text)
import Html.Attributes exposing (height, style, width)
import WebGL exposing (Mesh, Shader)
import WebGL.Texture as Texture exposing (Texture, FrameBuffer, Error, defaultOptions)
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
    case ( frameBufferResult, texture ) of
        ( Ok frameBuffer, Just tex ) ->
            WebGL.toHtmlWith
                [ WebGL.alpha True
                , WebGL.antialias
                , WebGL.depth 1
                , WebGL.stencil 0
                ]
                [ width 640
                , height 640
                , style [ ( "display", "block" ) ]
                ]
                [ WebGL.entity
                    Crate.crateVertex
                    Crate.crateFragment
                    Crate.crateMesh
                    { perspective = Crate.perspective (-theta)
                    , texture =
                        Texture.fromEntities frameBuffer
                            (Crate.scene (Crate.perspective (theta * 5)) tex)
                    }
                ]

        _ ->
            text "no texture"


frameBufferOptions : Texture.Options
frameBufferOptions =
    { defaultOptions | minify = Texture.nearest }


frameBufferResult : Result Error FrameBuffer
frameBufferResult =
    Texture.frameBuffer frameBufferOptions ( 512, 512 )
