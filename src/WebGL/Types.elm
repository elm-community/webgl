module WebGL.Types
    exposing
        ( Setting(..)
        , Capability(..)
        , BlendOperation(..)
        , BlendMode(..)
        , CompareMode(..)
        , FaceMode(..)
        , ZMode(..)
        , Drawable(..)
        , computeAPICall
        )

import Native.Settings


type Drawable attributes
    = Triangles (List ( attributes, attributes, attributes ))
    | Lines (List ( attributes, attributes ))
    | LineStrip (List attributes)
    | LineLoop (List attributes)
    | Points (List attributes)
    | TriangleFan (List attributes)
    | TriangleStrip (List attributes)
    | IndexedTriangles (List attributes) (List ( Int, Int, Int ))


type Setting
    = Enable Capability
    | Disable Capability
    | BlendColor Float Float Float Float
    | BlendEquation BlendMode
    | BlendEquationSeparate BlendMode BlendMode
    | BlendFunc BlendOperation BlendOperation
    | ClearColor Float Float Float Float
    | DepthFunc CompareMode
    | DepthMask Int
    | SampleCoverageFunc Float Bool
    | StencilFunc CompareMode Int Int
    | StencilFuncSeparate FaceMode CompareMode Int Int
    | StencilOperation ZMode ZMode ZMode
    | StencilOperationSeparate FaceMode ZMode ZMode ZMode
    | StencilMask Int
    | ColorMask Int Int Int Int
    | Scissor Int Int Int Int


computeCapabilityString : Capability -> String
computeCapabilityString capability =
    case capability of
        Blend ->
            "BLEND"

        CullFace ->
            "CULL_FACE"

        DepthTest ->
            "DEPTH_TEST"

        Dither ->
            "DITHER"

        PolygonOffsetFill ->
            "POLYGON_OFFSET_FILL"

        SampleAlphaToCoverage ->
            "SAMPLE_ALPHA_TO_COVERAGE"

        SampleCoverage ->
            "SAMPLE_COVERAGE"

        ScissorTest ->
            "SCISSOR_TEST"

        StencilTest ->
            "STENCIL_TEST"


type Capability
    = Blend
    | CullFace
    | DepthTest
    | Dither
    | PolygonOffsetFill
    | SampleAlphaToCoverage
    | SampleCoverage
    | ScissorTest
    | StencilTest


computeBlendOperationString : BlendOperation -> String
computeBlendOperationString operation =
    case operation of
        Zero ->
            "ZERO"

        One ->
            "ONE"

        SrcColor ->
            "SRC_COLOR"

        OneMinusSrcColor ->
            "ONE_MINUS_SRC_COLOR"

        DstColor ->
            "DST_COLOR"

        OneMinusDstColor ->
            "ONE_MINUS_DST_COLOR"

        SrcAlpha ->
            "SRC_ALPHA"

        OneMinusSrcAlpha ->
            "ONE_MINUS_SRC_ALPHA"

        DstAlpha ->
            "DST_ALPHA"

        OneMinusDstAlpha ->
            "ONE_MINUS_DST_ALPHA"

        ConstantColor ->
            "CONSTANT_COLOR"

        OneMinusConstantColor ->
            "ONE_MINUS_CONSTANT_COLOR"

        ConstantAlpha ->
            "CONSTANT_ALPHA"

        OneMinusConstantAlpha ->
            "ONE_MINUS_CONSTANT_ALPHA"

        SrcAlphaSaturate ->
            "SRC_ALPHA_SATURATE"


{-| The `BlendOperation` type allows you to define which blend operation to use.
-}
type BlendOperation
    = Zero
    | One
    | SrcColor
    | OneMinusSrcColor
    | DstColor
    | OneMinusDstColor
    | SrcAlpha
    | OneMinusSrcAlpha
    | DstAlpha
    | OneMinusDstAlpha
    | ConstantColor
    | OneMinusConstantColor
    | ConstantAlpha
    | OneMinusConstantAlpha
    | SrcAlphaSaturate


computeBlendModeString : BlendMode -> String
computeBlendModeString mode =
    case mode of
        Add ->
            "FUNC_ADD"

        Subtract ->
            "FUNC_SUBTRACT"

        ReverseSubtract ->
            "FUNC_REVERSE_SUBTRACT"


type BlendMode
    = Add
    | Subtract
    | ReverseSubtract


computeCompareModeString : CompareMode -> String
computeCompareModeString mode =
    case mode of
        Never ->
            "NEVER"

        Always ->
            "ALWAYS"

        Less ->
            "LESS"

        LessOrEqual ->
            "LEQUAL"

        Equal ->
            "EQUAL"

        GreaterOrEqual ->
            "GEQUAL"

        Greater ->
            "GREATER"

        NotEqual ->
            "NOTEQUAL"


type CompareMode
    = Never
    | Always
    | Less
    | LessOrEqual
    | Equal
    | GreaterOrEqual
    | Greater
    | NotEqual


computeFaceModeString : FaceMode -> String
computeFaceModeString mode =
    case mode of
        Front ->
            "FRONT"

        Back ->
            "BACK"

        FrontAndBack ->
            "FRONT_AND_BACK"


type FaceMode
    = Front
    | Back
    | FrontAndBack


computeZModeString : ZMode -> String
computeZModeString mode =
    case mode of
        Keep ->
            "KEEP"

        None ->
            "ZERO"

        Replace ->
            "REPLACE"

        Increment ->
            "INCREMENT"

        Decrement ->
            "DECREMENT"

        Invert ->
            "INVERT"

        IncrementWrap ->
            "INCREMENT_WRAP"

        DecrementWrap ->
            "DECREMENT_WRAP"


type ZMode
    = Keep
    | None
    | Replace
    | Increment
    | Decrement
    | Invert
    | IncrementWrap
    | DecrementWrap


computeAPICall : Setting -> (a -> b)
computeAPICall setting =
    case setting of
        Enable capability ->
            computeCapabilityString capability
                |> Native.Settings.enable

        Disable capability ->
            computeCapabilityString capability
                |> Native.Settings.disable

        BlendColor r g b a ->
            Native.Settings.blendColor r g b a

        BlendEquation mode ->
            computeBlendModeString mode
                |> Native.Settings.blendEquation

        BlendEquationSeparate modeRGB_ modeAlpha_ ->
            let
                modeRGB =
                    computeBlendModeString modeRGB_

                modeAlpha =
                    computeBlendModeString modeAlpha_
            in
                Native.Settings.blendEquationSeparate modeRGB modeAlpha

        BlendFunc src_ dst_ ->
            let
                src =
                    computeBlendOperationString src_

                dst =
                    computeBlendOperationString dst_
            in
                Native.Settings.blendFunc src dst

        ClearColor r g b a ->
            Native.Settings.clearColor r g b a

        DepthFunc mode ->
            computeCompareModeString mode
                |> Native.Settings.depthFunc

        DepthMask mask ->
            Native.Settings.depthMask mask

        SampleCoverageFunc value invert ->
            Native.Settings.sampleCoverage value invert

        StencilFunc func ref mask ->
            let
                mode =
                    computeCompareModeString func
            in
                Native.Settings.stencilFunc mode ref mask

        StencilFuncSeparate face_ func ref mask ->
            let
                face =
                    computeFaceModeString face_

                mode =
                    computeCompareModeString func
            in
                Native.Settings.stencilFuncSeparate face mode ref mask

        StencilOperation fail_ zfail_ zpass_ ->
            let
                fail =
                    computeZModeString fail_

                zfail =
                    computeZModeString zfail_

                zpass =
                    computeZModeString zpass_
            in
                Native.Settings.stencilOperation fail zfail zpass

        StencilOperationSeparate face_ fail_ zfail_ zpass_ ->
            let
                face =
                    computeFaceModeString face_

                fail =
                    computeZModeString fail_

                zfail =
                    computeZModeString zfail_

                zpass =
                    computeZModeString zpass_
            in
                Native.Settings.stencilOperationSeparate face fail zfail zpass

        StencilMask mask ->
            Native.Settings.stencilMask mask

        ColorMask r g b a ->
            Native.Settings.colorMask r g b a

        Scissor x y w h ->
            Native.Settings.scissor x y w h
