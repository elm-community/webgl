module WebGL.Settings.Internal exposing (Setting(..))


type Setting
    = Blend Int Int Int Int Int Int Float Float Float Float
    | DepthTest Int Bool Float Float
    | StencilTest Int Int Int Int Int Int Int Int Int Int Int
    | Scissor Int Int Int Int
    | ColorMask Bool Bool Bool Bool
    | CullFace Int
    | PolygonOffset Float Float
    | SampleCoverage Float Bool
    | SampleAlphaToCoverage
