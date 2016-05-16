-- Try adding the ability to crouch or to land on top of the crate.

import Keyboard
import Math.Vector2 exposing (Vec2)
import Math.Vector3 exposing (..)
import Math.Vector3 as V3
import Math.Matrix4 exposing (..)
import Task exposing (Task)
import Time exposing (..)
import WebGL exposing (..)
import Html exposing (Html, text, div)
import Html.App as Html
import Html.Attributes exposing (width, height, style)
import AnimationFrame
import Window


-- MODEL

type alias Person =
    { position : Vec3
    , velocity : Vec3
    }


type alias Keys =
  { left : Bool
  , right : Bool
  , up : Bool
  , down : Bool
  , space : Bool
  }


type alias Model =
  { texture : Maybe Texture
  , keys : Keys
  , size : Window.Size
  , person : Person
  }


type Action
  = TextureError Error
  | TextureLoaded Texture
  | KeyChange (Keys -> Keys)
  | Animate Time
  | Resize Window.Size


eyeLevel : Float
eyeLevel = 2


defaultPerson : Person
defaultPerson =
  { position = vec3 0 eyeLevel -10
  , velocity = vec3 0 0 0
  }


update : Action -> Model -> (Model, Cmd Action)
update action model =
  case action of
    TextureError err ->
      (model, Cmd.none)
    TextureLoaded texture ->
      ({model | texture = Just texture}, Cmd.none)
    KeyChange keyfunc ->
      ({model | keys = keyfunc model.keys}, Cmd.none)
    Resize size ->
      ({model | size = size}, Cmd.none)
    Animate dt ->
      ( { model
        | person = model.person
            |> walk (directions model.keys)
            |> jump model.keys.space
            |> gravity (dt / 500)
            |> physics (dt / 500)
        }
      , Cmd.none
      )


init : (Model, Cmd Action)
init =
  ( { texture = Nothing
    , person = defaultPerson
    , keys = Keys False False False False False
    , size = Window.Size 0 0
    }
  , Cmd.batch
      [ loadTexture "/texture/woodCrate.jpg"
        |> Task.perform TextureError TextureLoaded
      , Window.size |> Task.perform (always Resize (0, 0)) Resize
      ]
  )


subscriptions : Model -> Sub Action
subscriptions _ =
  [ AnimationFrame.diffs Animate
  , Keyboard.downs (keyChange True)
  , Keyboard.ups (keyChange False)
  , Window.resizes Resize
  ]
  |> Sub.batch


keyChange : Bool -> Keyboard.KeyCode -> Action
keyChange on keyCode =
  (case keyCode of
    32 -> \k -> {k | space = on}
    37 -> \k -> {k | left = on}
    39 -> \k -> {k | right = on}
    38 -> \k -> {k | up = on}
    40 -> \k -> {k | down = on}
    _ -> Basics.identity
  ) |> KeyChange


main : Program Never
main =
  Html.program
    { init = init
    , view = view
    , subscriptions = subscriptions
    , update = update
    }


directions : Keys -> {x : Int, y : Int}
directions {left, right, up, down} =
  let
    direction a b =
      case (a, b) of
        (True, False) -> -1
        (False, True) -> 1
        _ -> 0
  in
  { x = direction left right
  , y = direction down up
  }


walk : { x:Int, y:Int } -> Person -> Person
walk directions person =
  if getY person.position > eyeLevel then
    person
  else
    let
      vx = toFloat -directions.x
      vz = toFloat  directions.y
    in
      { person |
          velocity = vec3 vx (getY person.velocity) vz
      }


jump : Bool -> Person -> Person
jump isJumping person =
  if not isJumping || getY person.position > eyeLevel then
    person
  else
    let
      (vx,_,vz) = toTuple person.velocity
    in
      { person |
          velocity = vec3 vx 2 vz
      }


physics : Float -> Person -> Person
physics dt person =
  let
    position =
      person.position `add` V3.scale dt person.velocity

    (x,y,z) = toTuple position
  in
    { person |
        position =
            if y < eyeLevel then vec3 x eyeLevel z else position
    }


gravity : Float -> Person -> Person
gravity dt person =
  if getY person.position <= eyeLevel then
    person
  else
    let
      v = toRecord person.velocity
    in
      { person |
          velocity = vec3 v.x (v.y - 2 * dt) v.z
      }


world : Maybe Texture -> Mat4 -> List Renderable
world maybeTexture perspective =
  case maybeTexture of
    Nothing ->
        []

    Just tex ->
        [render vertexShader fragmentShader crate { crate=tex, perspective=perspective }]


-- VIEW

perspective : (Int,Int) -> Person -> Mat4
perspective (w,h) person =
  mul (makePerspective 45 (toFloat w / toFloat h) 0.01 100)
      (makeLookAt person.position (person.position `add` k) j)


view : Model -> Html Action
view {size, person, texture} =
  let
    perspectiveMatrix = perspective (size.width, size.height) person
    entities = world texture perspectiveMatrix
  in
    div
      [ style
          [ ("width", toString size.width ++ "px")
          , ("height", toString size.height ++ "px")
          , ("position", "relative")
          ]
      ]
      [ WebGL.toHtml
          [width size.width, height size.height, style [("display", "block")]]
          entities
      , div
          [ style
              [ ("position", "absolute")
              , ("font-family", "monospace")
              , ("text-align", "center")
              , ("left", "20px")
              , ("right", "20px")
              , ("top", "20px")
              ]
          ]
          [text message]
      ]


message : String
message =
  "Walk around with a first person perspective.\n"
  ++ "Arrows keys to move, space bar to jump."


-- Define the mesh for a crate

type alias Vertex =
    { position : Vec3
    , coord : Vec3
    }


crate : Drawable Vertex
crate =
  Triangle (List.concatMap rotatedFace [ (0,0), (90,0), (180,0), (270,0), (0,90), (0,-90) ])


rotatedFace : (Float,Float) -> List (Vertex, Vertex, Vertex)
rotatedFace (angleXZ,angleYZ) =
  let
    x = makeRotate (degrees angleXZ) j
    y = makeRotate (degrees angleYZ) i
    t = x `mul` y
    each f (a,b,c) = (f a, f b, f c)
  in
    List.map (each (\v -> {v | position = transform t v.position })) face


face : List (Vertex, Vertex, Vertex)
face =
  let
    topLeft     = Vertex (vec3 -1  1 1) (vec3 0 1 0)
    topRight    = Vertex (vec3  1  1 1) (vec3 1 1 0)
    bottomLeft  = Vertex (vec3 -1 -1 1) (vec3 0 0 0)
    bottomRight = Vertex (vec3  1 -1 1) (vec3 1 0 0)
  in
    [ (topLeft,topRight,bottomLeft)
    , (bottomLeft,topRight,bottomRight)
    ]


-- Shaders

vertexShader : Shader { position:Vec3, coord:Vec3 } { u | perspective:Mat4 } { vcoord:Vec2 }
vertexShader = [glsl|

attribute vec3 position;
attribute vec3 coord;
uniform mat4 perspective;
varying vec2 vcoord;

void main () {
  gl_Position = perspective * vec4(position, 1.0);
  vcoord = coord.xy;
}

|]


fragmentShader : Shader {} { u | crate:Texture } { vcoord:Vec2 }
fragmentShader = [glsl|

precision mediump float;
uniform sampler2D crate;
varying vec2 vcoord;

void main () {
  gl_FragColor = texture2D(crate, vcoord);
}

|]
