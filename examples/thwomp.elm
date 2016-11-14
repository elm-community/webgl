-- Thanks to The PaperNES Guy for the texture:
-- http://the-papernes-guy.deviantart.com/art/Thwomps-Thwomps-Thwomps-186879685


module Main exposing (..)

import Math.Vector2 exposing (Vec2)
import Math.Vector3 as V3 exposing (..)
import Math.Matrix4 exposing (..)
import Mouse
import Task exposing (Task)
import WebGL exposing (..)
import Window
import Html exposing (Html)
import Html.Attributes exposing (width, height)


type alias Model =
    { size : Window.Size
    , position : Mouse.Position
    , textures : ( Maybe Texture, Maybe Texture )
    }


type Action
    = TexturesError Error
    | TexturesLoaded ( Maybe Texture, Maybe Texture )
    | Resize Window.Size
    | MouseMove Mouse.Position


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        TexturesError err ->
            ( model, Cmd.none )

        TexturesLoaded textures ->
            ( { model | textures = textures }, Cmd.none )

        Resize size ->
            ( { model | size = size }, Cmd.none )

        MouseMove position ->
            ( { model | position = position }, Cmd.none )


init : ( Model, Cmd Action )
init =
    ( { size = { width = 0, height = 0 }
      , position = { x = 0, y = 0 }
      , textures = ( Nothing, Nothing )
      }
    , Cmd.batch
        [ Task.perform Resize Window.size
        , fetchTextures
            |> Task.attempt
                (\result ->
                    case result of
                        Err err ->
                            TexturesError err

                        Ok val ->
                            TexturesLoaded val
                )
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
        , view = view face sides
        , subscriptions = subscriptions
        , update = update
        }


fetchTextures : Task Error ( Maybe Texture, Maybe Texture )
fetchTextures =
    loadTexture "texture/thwomp_face.jpg"
        |> Task.andThen
            (\faceTexture ->
                loadTexture "texture/thwomp_side.jpg"
                    |> Task.andThen
                        (\sideTexture ->
                            Task.succeed ( Just faceTexture, Just sideTexture )
                        )
            )



-- MESHES - define the mesh for a Thwomp's face


type alias Vertex =
    { position : Vec3, coord : Vec3 }


face : List ( Vertex, Vertex, Vertex )
face =
    rotatedSquare ( 0, 0 )


sides : List ( Vertex, Vertex, Vertex )
sides =
    List.concatMap rotatedSquare [ ( 90, 0 ), ( 180, 0 ), ( 270, 0 ), ( 0, 90 ), ( 0, -90 ) ]


rotatedSquare : ( Float, Float ) -> List ( Vertex, Vertex, Vertex )
rotatedSquare ( angleXZ, angleYZ ) =
    let
        x =
            makeRotate (degrees angleXZ) j

        y =
            makeRotate (degrees angleYZ) i

        t =
            mul x y

        each f ( a, b, c ) =
            ( f a, f b, f c )
    in
        List.map (each (\v -> { v | position = transform t v.position })) square


square : List ( Vertex, Vertex, Vertex )
square =
    let
        topLeft =
            Vertex (vec3 -1 1 1) (vec3 0 1 0)

        topRight =
            Vertex (vec3 1 1 1) (vec3 1 1 0)

        bottomLeft =
            Vertex (vec3 -1 -1 1) (vec3 0 0 0)

        bottomRight =
            Vertex (vec3 1 -1 1) (vec3 1 0 0)
    in
        [ ( topLeft, topRight, bottomLeft )
        , ( bottomLeft, topRight, bottomRight )
        ]



-- VIEW


perspective : Model -> Mat4
perspective { size, position } =
    let
        w =
            toFloat size.width

        h =
            toFloat size.height

        x =
            toFloat position.x

        y =
            toFloat position.y

        distance =
            6

        eyeX =
            distance * (w / 2 - x) / w

        eyeY =
            distance * (y - h / 2) / h

        eye =
            V3.scale distance (V3.normalize (vec3 eyeX eyeY distance))
    in
        mul (makePerspective 45 (w / h) 0.01 100)
            (makeLookAt eye (vec3 0 0 0) j)


view :
    List ( Vertex, Vertex, Vertex )
    -> List ( Vertex, Vertex, Vertex )
    -> Model
    -> Html Action
view mesh1 mesh2 ({ textures, size } as model) =
    let
        perspectiveMatrix =
            perspective model

        ( texture1, texture2 ) =
            textures
    in
        WebGL.toHtml
            [ width size.width, height size.height ]
            (toEntity mesh1 texture1 perspectiveMatrix
                ++ toEntity mesh2 texture2 perspectiveMatrix
            )


toEntity : List ( Vertex, Vertex, Vertex ) -> Maybe Texture -> Mat4 -> List Renderable
toEntity mesh response perspective =
    response
        |> Maybe.map
            (\texture ->
                [ render vertexShader fragmentShader (Triangle mesh) { texture = texture, perspective = perspective } ]
            )
        |> Maybe.withDefault []



-- SHADERS


vertexShader : Shader { position : Vec3, coord : Vec3 } { u | perspective : Mat4 } { vcoord : Vec2 }
vertexShader =
    [glsl|

attribute vec3 position;
attribute vec3 coord;
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
