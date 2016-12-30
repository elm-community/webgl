-- Thanks to The PaperNES Guy for the texture:
-- http://the-papernes-guy.deviantart.com/art/Thwomps-Thwomps-Thwomps-186879685


module Main exposing (..)

import Math.Vector2 exposing (Vec2, vec2)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Mouse
import Task exposing (Task)
import WebGL exposing (Mesh, Shader, Entity)
import WebGL.Texture as Texture exposing (Texture, defaultOptions, Error)
import Window
import Html exposing (Html, text)
import Html.Attributes exposing (width, height, style)


type alias Model =
    { size : Window.Size
    , position : Mouse.Position
    , textures : Maybe ( Texture, Texture )
    }


type Action
    = TexturesError Error
    | TexturesLoaded ( Texture, Texture )
    | Resize Window.Size
    | MouseMove Mouse.Position


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        TexturesError err ->
            ( model, Cmd.none )

        TexturesLoaded textures ->
            ( { model | textures = Just textures }, Cmd.none )

        Resize size ->
            ( { model | size = size }, Cmd.none )

        MouseMove position ->
            ( { model | position = position }, Cmd.none )


init : ( Model, Cmd Action )
init =
    ( { size = { width = 0, height = 0 }
      , position = { x = 0, y = 0 }
      , textures = Nothing
      }
    , Cmd.batch
        [ Task.perform Resize Window.size
        , fetchTextures
        ]
    )


subscriptions : Model -> Sub Action
subscriptions _ =
    Sub.batch
        [ Window.resizes Resize
        , Mouse.moves MouseMove
        ]


main : Program Never Model Action
main =
    Html.program
        { init = init
        , view = view
        , subscriptions = subscriptions
        , update = update
        }


fetchTextures : Cmd Action
fetchTextures =
    [ "texture/thwomp_face.jpg"
    , "texture/thwomp_side.jpg"
    ]
        |> List.map
            (Texture.loadWith
                { defaultOptions
                    | magnify = Texture.nearest
                    , minify = Texture.nearest
                }
            )
        |> Task.sequence
        |> Task.andThen
            (\textures ->
                case textures of
                    face :: side :: _ ->
                        Task.succeed ( face, side )

                    _ ->
                        Task.fail Texture.LoadError
            )
        |> Task.attempt
            (\result ->
                case result of
                    Err error ->
                        TexturesError error

                    Ok textures ->
                        TexturesLoaded textures
            )



-- MESHES - define the mesh for a Thwomp's face


type alias Vertex =
    { position : Vec3
    , coord : Vec2
    }


face : Mesh Vertex
face =
    WebGL.triangles square


sides : Mesh Vertex
sides =
    [ ( 90, 0 ), ( 180, 0 ), ( 270, 0 ), ( 0, 90 ), ( 0, -90 ) ]
        |> List.concatMap rotatedSquare
        |> WebGL.triangles


rotatedSquare : ( Float, Float ) -> List ( Vertex, Vertex, Vertex )
rotatedSquare ( angleXZ, angleYZ ) =
    let
        x =
            Mat4.makeRotate (degrees angleXZ) Vec3.j

        y =
            Mat4.makeRotate (degrees angleYZ) Vec3.i

        transform vertex =
            { vertex
                | position =
                    Mat4.transform
                        (Mat4.mul x y)
                        vertex.position
            }

        transformTriangle ( a, b, c ) =
            ( transform a, transform b, transform c )
    in
        List.map transformTriangle square


square : List ( Vertex, Vertex, Vertex )
square =
    let
        topLeft =
            Vertex (vec3 -1 1 1) (vec2 0 1)

        topRight =
            Vertex (vec3 1 1 1) (vec2 1 1)

        bottomLeft =
            Vertex (vec3 -1 -1 1) (vec2 0 0)

        bottomRight =
            Vertex (vec3 1 -1 1) (vec2 1 0)
    in
        [ ( topLeft, topRight, bottomLeft )
        , ( bottomLeft, topRight, bottomRight )
        ]



-- VIEW


view : Model -> Html Action
view { textures, size, position } =
    case textures of
        Just ( faceTexture, sideTexture ) ->
            WebGL.toHtml
                [ width size.width
                , height size.height
                , style [ ( "display", "block" ) ]
                ]
                [ toEntity face faceTexture size position
                , toEntity sides sideTexture size position
                ]

        Nothing ->
            text "Loading textures..."


toEntity : Mesh Vertex -> Texture -> Window.Size -> Mouse.Position -> Entity
toEntity mesh texture { width, height } { x, y } =
    WebGL.entity
        vertexShader
        fragmentShader
        mesh
        { texture = texture
        , perspective =
            perspective
                (toFloat width)
                (toFloat height)
                (toFloat x)
                (toFloat y)
        }


perspective : Float -> Float -> Float -> Float -> Mat4
perspective width height x y =
    let
        eye =
            vec3 (0.5 - x / width) -(0.5 - y / height) 1
                |> Vec3.normalize
                |> Vec3.scale 6
    in
        Mat4.mul (Mat4.makePerspective 45 (width / height) 0.01 100)
            (Mat4.makeLookAt eye (vec3 0 0 0) Vec3.j)



-- SHADERS


vertexShader : Shader Vertex { u | perspective : Mat4 } { vcoord : Vec2 }
vertexShader =
    [glsl|

attribute vec3 position;
attribute vec2 coord;
uniform mat4 perspective;
varying vec2 vcoord;

void main () {
  gl_Position = perspective * vec4(position, 1.0);
  vcoord = coord.xy;
}

|]


fragmentShader : Shader {} { u | texture : Texture } { vcoord : Vec2 }
fragmentShader =
    [glsl|

precision mediump float;
uniform sampler2D texture;
varying vec2 vcoord;

void main () {
  gl_FragColor = texture2D(texture, vcoord);
}

|]
