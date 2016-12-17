module Main exposing (..)

{-|
    This example was inspired by https://open.gl/depthstencils
    It demonstrates how to use the stencil buffer.
-}

import Math.Vector2 exposing (Vec2)
import Math.Vector3 exposing (..)
import Math.Matrix4 exposing (..)
import Task
import Time exposing (Time)
import WebGL exposing (..)
import WebGL.Texture as Texture exposing (Error)
import WebGL.Settings exposing (..)
import WebGL.Settings.DepthTest as DepthTest
import WebGL.Settings.StencilTest as StencilTest exposing (defaultOptions)
import Html exposing (Html)
import AnimationFrame
import Html.Attributes exposing (width, height)


type alias Model =
    { texture : Maybe Texture
    , theta : Float
    }


type Action
    = TextureError Error
    | TextureLoaded Texture
    | Animate Time


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        TextureError err ->
            ( model, Cmd.none )

        TextureLoaded texture ->
            ( { model | texture = Just texture }, Cmd.none )

        Animate dt ->
            ( { model | theta = model.theta + dt / 10000 }, Cmd.none )


init : ( Model, Cmd Action )
init =
    ( { texture = Nothing, theta = 0 }
    , Texture.load "texture/woodCrate.jpg"
        |> Task.attempt
            (\result ->
                case result of
                    Err err ->
                        TextureError err

                    Ok val ->
                        TextureLoaded val
            )
    )


main : Program Never Model Action
main =
    Html.program
        { init = init
        , view = view
        , subscriptions = (\model -> AnimationFrame.diffs Animate)
        , update = update
        }



-- MESHES


crate : Mesh { pos : Vec3, coord : Vec3 }
crate =
    triangles <|
        List.concatMap rotatedFace [ ( 0, 0 ), ( 90, 0 ), ( 180, 0 ), ( 270, 0 ), ( 0, 90 ), ( 0, -90 ) ]


rotatedFace : ( Float, Float ) -> List ( { pos : Vec3, coord : Vec3 }, { pos : Vec3, coord : Vec3 }, { pos : Vec3, coord : Vec3 } )
rotatedFace ( angleX, angleY ) =
    let
        x =
            makeRotate (degrees angleX) (vec3 1 0 0)

        y =
            makeRotate (degrees angleY) (vec3 0 1 0)

        t =
            mul (mul x y) (makeTranslate (vec3 0 0 1))

        each f ( a, b, c ) =
            ( f a, f b, f c )
    in
        List.map (each (\x -> { x | pos = Math.Vector3.add (vec3 0 1 0) (transform t x.pos) })) face


face : List ( { pos : Vec3, coord : Vec3 }, { pos : Vec3, coord : Vec3 }, { pos : Vec3, coord : Vec3 } )
face =
    let
        topLeft =
            { pos = vec3 -1 1 0, coord = vec3 0 1 0 }

        topRight =
            { pos = vec3 1 1 0, coord = vec3 1 1 0 }

        bottomLeft =
            { pos = vec3 -1 -1 0, coord = vec3 0 0 0 }

        bottomRight =
            { pos = vec3 1 -1 0, coord = vec3 1 0 0 }
    in
        [ ( topLeft, topRight, bottomLeft )
        , ( bottomLeft, topRight, bottomRight )
        ]


floor : Mesh { pos : Vec3 }
floor =
    let
        topLeft =
            { pos = vec3 -2 0 -2 }

        topRight =
            { pos = vec3 2 0 -2 }

        bottomLeft =
            { pos = vec3 -2 0 2 }

        bottomRight =
            { pos = vec3 2 0 2 }
    in
        triangles
            [ ( topLeft, topRight, bottomLeft )
            , ( bottomLeft, topRight, bottomRight )
            ]



-- VIEW


perspective : Float -> Mat4
perspective angle =
    List.foldr mul
        Math.Matrix4.identity
        [ perspectiveMatrix
        , camera
        , makeRotate (3 * angle) (vec3 0 1 0)
        ]


perspectiveMatrix : Mat4
perspectiveMatrix =
    makePerspective 45 1 0.01 100


camera : Mat4
camera =
    makeLookAt (vec3 0 3 8) (vec3 0 0 0) (vec3 0 1 0)


view : Model -> Html Action
view { texture, theta } =
    WebGL.toHtmlWith
        [ alpha True, antialias, depth 1, stencil 0 ]
        [ width 400, height 400 ]
        (case texture of
            Nothing ->
                []

            Just tex ->
                let
                    camera =
                        perspective theta
                in
                    [ renderBox
                        [ DepthTest.less ]
                        Math.Matrix4.identity
                        (vec3 1 1 1)
                        tex
                        camera
                    , renderFloor
                        [ DepthTest.custom
                            { test = DepthTest.customLess
                            , near = 0
                            , far = 1
                            , mask = False
                            }
                        , StencilTest.test
                            { defaultOptions
                                | test = StencilTest.always 1
                                , zpass = StencilTest.replace
                            }
                        ]
                        camera
                    , renderBox
                        [ StencilTest.test
                            { defaultOptions
                                | test = StencilTest.equal 1 0xFFFFFFFF
                            }
                        , DepthTest.less
                        ]
                        (makeScale (vec3 1 -1 1))
                        (vec3 0.6 0.6 0.6)
                        tex
                        camera
                    ]
        )


renderBox : List Setting -> Mat4 -> Vec3 -> Texture -> Mat4 -> Entity
renderBox settings worldTransform overrideColor tex camera =
    entityWith settings
        boxVert
        boxFrag
        crate
        { texture = tex
        , overrideColor = overrideColor
        , modelViewMatrix = worldTransform
        , perspective = camera
        }


renderFloor : List Setting -> Mat4 -> Entity
renderFloor settings camera =
    entityWith settings
        floorVert
        floorFrag
        floor
        { perspective = camera }



-- SHADERS


boxVert : Shader { pos : Vec3, coord : Vec3 } { u | modelViewMatrix : Mat4, perspective : Mat4 } { vcoord : Vec2 }
boxVert =
    [glsl|

attribute vec3 pos;
attribute vec3 coord;
uniform mat4 perspective;
uniform mat4 modelViewMatrix;
varying vec2 vcoord;

void main () {
  gl_Position = perspective * modelViewMatrix * vec4(pos, 1.0);
  vcoord = coord.xy;
}

|]


boxFrag : Shader {} { u | texture : Texture, overrideColor : Vec3 } { vcoord : Vec2 }
boxFrag =
    [glsl|

precision mediump float;
uniform sampler2D texture;
uniform vec3 overrideColor;
varying vec2 vcoord;

void main () {
  gl_FragColor = vec4(overrideColor, 1.0) * texture2D(texture, vcoord);
}

|]


floorVert : Shader { pos : Vec3 } { u | perspective : Mat4 } {}
floorVert =
    [glsl|

attribute vec3 pos;
uniform mat4 perspective;

void main () {
  gl_Position = perspective * vec4(pos, 1.0);
}

|]


floorFrag : Shader attributes uniforms {}
floorFrag =
    [glsl|

precision mediump float;

void main () {
  gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
}

|]
