module Render exposing (styledRenderer)

-- import Html exposing (Html)

import AB exposing (TestVersion, Version(..))
import Css
import Element exposing (Element)
import Element.Background
import Element.Border
import Element.Font as Font
import Element.Input
import Element.Region
import Html.Attributes
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr exposing (css)
import Html.Styled.Events exposing (onClick, onInput, onSubmit)
import List.Extra as Extra
import Markdown.Block as Block exposing (Block, Inline, ListItem(..), Task(..))
import Markdown.Html
import Markdown.Renderer
import Svg.Styled as Svg exposing (path, svg)
import Svg.Styled.Attributes as SvgAttr
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw
import Types exposing (Model, Msg(..))


styledRenderer : List Block -> Result String (Model -> Html.Html Msg)
styledRenderer blocks =
    blocks
        |> Markdown.Renderer.render engine
        |> Result.map
            (\blockViews model ->
                blockViews
                    |> renderAll model
                    |> div []
            )


engine : Markdown.Renderer.Renderer (Model -> Html.Html Msg)
engine =
    { heading = heading
    , paragraph =
        \children model ->
            div
                [ css
                    [ Tw.flex
                    , Tw.items_center
                    , Tw.justify_center
                    ]
                ]
                [ p
                    [ css
                        [ Bp.md [ Tw.mx_0 ]
                        , Tw.mx_4
                        , Tw.my_0
                        , Tw.max_w_4xl
                        ]
                    ]
                    (renderAll model children)
                ]
    , blockQuote =
        \children model ->
            p
                [ css
                    [ Bp.md
                        [ Tw.rounded
                        , Tw.bg_white
                        , Tw.shadow_lg
                        , Tw.italic
                        ]
                    , Tw.px_4
                    ]
                ]
                (renderAll model children)
    , html =
        Markdown.Html.oneOf
            [ Markdown.Html.tag "test"
                (\id version name children model ->
                    let
                        test =
                            Extra.find
                                (\x -> x.testId == id)
                                model.tests
                                |> Maybe.map .version
                    in
                    case ( version, test ) of
                        ( "A", Just A ) ->
                            div [ css [ Tw.w_full ] ]
                                (renderAll model
                                    children
                                )

                        ( "B", Just B ) ->
                            div
                                [ css
                                    [ Tw.w_full
                                    ]
                                ]
                                (renderAll model
                                    children
                                )

                        _ ->
                            div [] []
                )
                |> Markdown.Html.withAttribute "id"
                |> Markdown.Html.withAttribute "version"
                |> Markdown.Html.withAttribute "name"
            , Markdown.Html.tag "extra"
                (\children model ->
                    div
                        [ css
                            [ Tw.px_2
                            , Tw.flex
                            , Tw.items_center
                            , Tw.justify_center
                            , Tw.flex_wrap
                            , Bp.md [ Tw.space_x_1 ]
                            , Tw.my_4
                            ]
                        ]
                        [ button
                            [ css
                                [ Tw.w_full
                                , Tw.mt_3
                                , Tw.no_underline
                                , Tw.text_center
                                , Bp.md [ Tw.mt_0 ]
                                , Tw.px_6
                                , Tw.py_6
                                , Tw.text_base
                                , Tw.font_medium
                                , Tw.rounded_md
                                , Tw.bg_green_600
                                , Tw.w_64
                                , Tw.text_white
                                , Tw.text_xl
                                , Css.focus
                                    [ Tw.outline_none
                                    , Tw.ring_2
                                    , Tw.ring_offset_2
                                    , Tw.ring_blue_400
                                    ]
                                , Css.hover
                                    [ Tw.bg_green_900
                                    ]
                                ]
                            , onClick ToggleExtra
                            ]
                            [ case model.extraTestimonials of
                                False ->
                                    text "See more 👇"

                                True ->
                                    text "See less 👍"
                            ]
                        ]
                )
            , Markdown.Html.tag "buy"
                (\children model ->
                    buy
                )
            , Markdown.Html.tag "praise"
                (\children model ->
                    praise
                )
            , Markdown.Html.tag "feature"
                (\children model ->
                    feature model
                )
            , Markdown.Html.tag "link"
                (\url label children model ->
                    div
                        [ css
                            [ Tw.px_2
                            , Tw.flex
                            , Tw.items_center
                            , Tw.justify_center
                            , Tw.flex_wrap
                            , Bp.md [ Tw.space_x_1 ]
                            , Tw.mt_4
                            , Tw.mb_8
                            ]
                        ]
                        [ a
                            [ Attr.href url
                            , css
                                [ Tw.border_none
                                , Tw.bg_white
                                , Tw.text_lg
                                , Tw.text_blue_600
                                , Tw.underline
                                , Tw.font_semibold
                                ]
                            , onClick (OpenCheckout "buy")
                            ]
                            [ text label ]
                        , span [ css [ Tw.hidden, Bp.md [ Tw.inline_flex ] ] ]
                            [ text " — " ]
                        , span [ css [ Tw.inline_flex ] ] [ text "30 day money back guarantee!" ]
                        ]
                )
                |> Markdown.Html.withAttribute "url"
                |> Markdown.Html.withAttribute "label"
            , Markdown.Html.tag "button"
                (\url label extra children model ->
                    div
                        [ css
                            [ Tw.px_2
                            , Tw.flex
                            , Tw.items_center
                            , Tw.justify_center
                            , Tw.flex_wrap
                            , Bp.md [ Tw.space_x_1 ]
                            , Tw.my_4
                            ]
                        ]
                        [ a
                            [ Attr.href url
                            , css
                                ([ Tw.w_full
                                 , Tw.mt_3
                                 , Tw.no_underline
                                 , Tw.text_center
                                 , Bp.md [ Tw.mt_0 ]
                                 , Tw.px_4
                                 , Tw.py_3
                                 , Tw.text_base
                                 , Tw.font_medium
                                 , Tw.rounded_md
                                 , Tw.bg_blue_500
                                 , Tw.text_xl
                                 , Tw.w_64
                                 , Tw.text_white
                                 , Css.focus
                                    [ Tw.outline_none
                                    , Tw.ring_2
                                    , Tw.ring_offset_2
                                    , Tw.ring_blue_400
                                    ]
                                 , Css.hover
                                    [ Tw.bg_blue_600
                                    ]
                                 ]
                                    ++ (case ( extra, model.extraTestimonials ) of
                                            ( Nothing, _ ) ->
                                                []

                                            ( _, True ) ->
                                                []

                                            ( Just _, False ) ->
                                                [ Tw.hidden ]
                                       )
                                )
                            , onClick (OpenCheckout "buy")
                            ]
                            [ text label
                            ]
                        ]
                )
                |> Markdown.Html.withAttribute "url"
                |> Markdown.Html.withAttribute "label"
                |> Markdown.Html.withOptionalAttribute "extra"
            , Markdown.Html.tag "quote"
                (\name span2 link extra children model ->
                    div
                        [ css
                            ([ Bp.md
                                [ Tw.px_6
                                , Tw.py_6
                                , case span2 of
                                    Just _ ->
                                        Tw.col_span_2

                                    _ ->
                                        Tw.col_span_1
                                ]
                             , Tw.p_4
                             , Tw.rounded_md
                             , Tw.shadow_lg
                             , Tw.border
                             , Tw.border_solid
                             , Tw.border_gray_400
                             , Tw.flex
                             , Tw.items_center
                             , Tw.justify_center
                             , Tw.text_gray_700
                             ]
                                ++ (case ( extra, model.extraTestimonials ) of
                                        ( Nothing, _ ) ->
                                            []

                                        ( _, True ) ->
                                            []

                                        ( Just _, False ) ->
                                            [ Tw.hidden ]
                                   )
                            )
                        ]
                        [ div [ css [ Tw.space_y_1 ] ]
                            (renderAll model
                                children
                                ++ [ div
                                        [ css
                                            [ Tw.text_right
                                            , Tw.text_gray_500
                                            , Tw.italic
                                            ]
                                        ]
                                        [ text ("— " ++ name)
                                        ]
                                   ]
                            )
                        ]
                )
                |> Markdown.Html.withAttribute "name"
                |> Markdown.Html.withOptionalAttribute "span2"
                |> Markdown.Html.withOptionalAttribute "link"
                |> Markdown.Html.withOptionalAttribute "extra"
            , Markdown.Html.tag "row"
                (\children model ->
                    div
                        [ css
                            [ Tw.flex
                            , Tw.items_center
                            , Tw.justify_center
                            ]
                        ]
                        [ div
                            [ css
                                [ Tw.flex
                                , Tw.flex_wrap
                                , Bp.md
                                    [ Tw.space_x_12
                                    , Tw.flex_nowrap
                                    ]
                                , Tw.items_center
                                , Tw.justify_center
                                , Tw.max_w_4xl
                                ]
                            ]
                            (renderAll model
                                children
                            )
                        ]
                )
            , Markdown.Html.tag "img"
                (\src desc children model ->
                    img
                        [ css
                            [ Tw.object_scale_down
                            , Bp.md [ Tw.max_w_sm ]
                            , Tw.max_w_xs
                            ]
                        , Attr.src
                            src
                        , Attr.alt desc
                        ]
                        []
                )
                |> Markdown.Html.withAttribute "src"
                |> Markdown.Html.withAttribute "desc"
            , Markdown.Html.tag "email"
                (\group id children model ->
                    div
                        [ css [ Tw.p_3 ]
                        ]
                        [ form
                            [ css
                                [ Tw.flex
                                , Tw.flex_wrap
                                , Bp.md [ Tw.space_x_6, Tw.flex_nowrap ]
                                , Tw.items_center
                                , Tw.justify_center
                                ]
                            , onSubmit (SubmitEmail group id model.email)
                            ]
                            [ label
                                [ Attr.for "emailAddress"
                                , css []
                                ]
                                []
                            , input
                                [ Attr.id "emailAddress"
                                , Attr.name "email"
                                , Attr.type_ "email"
                                , Attr.attribute "autocomplete" "email"
                                , Attr.required True
                                , Attr.value model.email
                                , onInput UpdateEmail
                                , css
                                    [ Tw.w_full
                                    , Bp.md [ Tw.w_1over3 ]
                                    , Tw.placeholder_gray_500
                                    , Tw.border_gray_300
                                    , Tw.rounded_md
                                    , Tw.py_3
                                    , Tw.px_2
                                    , Tw.text_base
                                    , Tw.max_w_xl
                                    , Css.focus
                                        [ Tw.ring_indigo_500
                                        , Tw.border_indigo_500
                                        ]
                                    ]
                                , Attr.placeholder "Email"
                                ]
                                []
                            , div
                                [ css
                                    [ Tw.rounded_md
                                    , Tw.shadow
                                    , Tw.flex_none
                                    ]
                                ]
                                [ button
                                    [ Attr.type_ "submit"
                                    , css
                                        [ Tw.w_full
                                        , Tw.mt_3
                                        , Bp.md [ Tw.mt_0 ]
                                        , Tw.px_5
                                        , Tw.py_3
                                        , Tw.text_base
                                        , Tw.font_medium
                                        , Tw.rounded_md
                                        , Tw.text_white
                                        , Tw.bg_blue_500
                                        , Tw.font_semibold
                                        , Css.focus
                                            [ Tw.outline_none
                                            , Tw.ring_2
                                            , Tw.ring_offset_2
                                            , Tw.ring_blue_400
                                            ]
                                        , Css.hover
                                            [ Tw.bg_blue_600
                                            ]
                                        ]
                                    ]
                                    [ text "Send me a free sample chapter" ]
                                ]
                            ]
                        ]
                )
                |> Markdown.Html.withAttribute "group"
                |> Markdown.Html.withAttribute "id"
            , Markdown.Html.tag "div"
                (\bg space_y text_align children model ->
                    let
                        customCss =
                            (bg |> textToCss)
                                ++ (space_y |> textToCss)
                                ++ (text_align |> textToCss)
                                ++ []
                    in
                    div
                        [ css customCss ]
                        (renderAll model children)
                )
                |> Markdown.Html.withOptionalAttribute "bg"
                |> Markdown.Html.withOptionalAttribute "space_y"
                |> Markdown.Html.withOptionalAttribute "text_align"
            , Markdown.Html.tag "heading"
                (\h left children model ->
                    let
                        css1 =
                            [ Tw.font_header
                            , Tw.text_gray_800
                            , Tw.tracking_tight
                            , Tw.text_center
                            , Tw.font_bold
                            ]

                        commonCss =
                            case left of
                                Just _ ->
                                    css1 ++ [ Bp.md [ Tw.text_left, Tw.mx_0 ] ]

                                Nothing ->
                                    css1
                    in
                    case h of
                        "1" ->
                            h1
                                [ css
                                    ([ Bp.md [ Tw.text_4xl ]
                                     , Tw.text_3xl

                                     -- , Tw.mt_4
                                     , Tw.mb_4
                                     ]
                                        ++ commonCss
                                    )
                                ]
                                (renderAll model children)

                        "2" ->
                            h2
                                [ css
                                    ([ Tw.text_3xl
                                     , Tw.mt_6
                                     , Tw.mb_4
                                     ]
                                        ++ commonCss
                                    )
                                ]
                                (renderAll model children)

                        _ ->
                            h3
                                [ css
                                    ([ Tw.text_lg
                                     , Tw.mt_4
                                     ]
                                        ++ commonCss
                                    )
                                ]
                                (renderAll model children)
                )
                |> Markdown.Html.withAttribute "h"
                |> Markdown.Html.withOptionalAttribute "left"
            , Markdown.Html.tag "quote-grid"
                (\children model ->
                    div
                        [ css
                            [ Tw.w_screen
                            , Tw.flex
                            , Tw.items_center
                            , Tw.justify_center
                            ]
                        ]
                        [ div
                            [ css
                                [ Tw.grid
                                , Bp.md
                                    [ Tw.grid_cols_4
                                    , Tw.gap_4
                                    , Tw.mt_8
                                    , Tw.max_w_screen_2xl
                                    ]
                                , Tw.gap_y_4
                                , Tw.my_8
                                , Tw.px_4
                                , Tw.grid_cols_1
                                ]
                            ]
                            (renderAll model children)
                        ]
                )
            , Markdown.Html.tag "grid"
                (\children model ->
                    div
                        [ css
                            [ Tw.flex
                            , Tw.items_center
                            , Tw.justify_center
                            ]
                        ]
                        [ div
                            [ css
                                [ Tw.grid
                                , Tw.max_w_4xl
                                , Bp.md
                                    [ Tw.grid_cols_2
                                    , Tw.gap_x_4
                                    , Tw.gap_y_0
                                    , Tw.my_6
                                    ]
                                , Tw.mt_8
                                , Tw.px_4
                                , Tw.grid_cols_1
                                , Tw.gap_y_4
                                , Tw.items_center
                                ]
                            ]
                            (renderAll model children)
                        ]
                )
            , Markdown.Html.tag "image"
                (\src desc size children model ->
                    let
                        size_ =
                            case size of
                                Just "xs" ->
                                    Tw.max_w_xs

                                Just "sm" ->
                                    Tw.max_w_sm

                                Just "md" ->
                                    Tw.max_w_md

                                Just "lg" ->
                                    Tw.max_w_lg

                                Just "xl" ->
                                    Tw.max_w_xl

                                _ ->
                                    Tw.max_w_xs
                    in
                    img
                        [ css
                            [ Tw.object_scale_down
                            , size_
                            , Tw.mx_auto
                            , Tw.my_4
                            ]
                        , Attr.src
                            src
                        , Attr.alt desc
                        ]
                        []
                )
                |> Markdown.Html.withAttribute "src"
                |> Markdown.Html.withAttribute "desc"
                |> Markdown.Html.withOptionalAttribute "size"
            ]
    , text = \children _ -> text children
    , codeSpan = \_ _ -> div [] []
    , strong =
        \children model ->
            strong [ css [ Tw.font_bold ] ]
                (renderAll model children)
    , emphasis =
        \children model ->
            em [ css [ Tw.italic ] ]
                (renderAll model children)
    , hardLineBreak = \_ -> br [] []
    , link =
        \{ destination } body model ->
            a
                [ Attr.href destination
                , css
                    [ Tw.underline
                    ]
                ]
                (renderAll model body)
    , image =
        \image _ ->
            case image.title of
                Just _ ->
                    img
                        [ css [ Tw.object_scale_down, Tw.w_full ]
                        , Attr.src
                            image.src
                        , Attr.alt image.alt
                        ]
                        []

                Nothing ->
                    img
                        [ css [ Tw.object_scale_down, Tw.w_full ]
                        , Attr.src
                            image.src
                        , Attr.alt image.alt
                        ]
                        []
    , unorderedList =
        \items model ->
            ul [ css [ Tw.mr_2, Bp.md [ Tw.mr_0 ] ] ]
                (items
                    |> List.map
                        (\item ->
                            case item of
                                Block.ListItem task children ->
                                    let
                                        checkbox =
                                            case task of
                                                Block.NoTask ->
                                                    text ""

                                                Block.IncompleteTask ->
                                                    input
                                                        [ Attr.disabled True
                                                        , Attr.checked False
                                                        , Attr.type_ "checkbox"
                                                        ]
                                                        []

                                                Block.CompletedTask ->
                                                    input
                                                        [ Attr.disabled True
                                                        , Attr.checked True
                                                        , Attr.type_ "checkbox"
                                                        ]
                                                        []
                                    in
                                    div [ css [ Tw.flex ] ]
                                        [ span [ css [ Tw.mx_2 ] ] [ text "•" ]
                                        , div [] (renderAll model children)
                                        ]
                         -- li [] (text "•" :: renderAll model children)
                        )
                )
    , orderedList =
        \startingIndex items model ->
            ol
                (case startingIndex of
                    1 ->
                        [ Attr.start startingIndex ]

                    _ ->
                        []
                )
                (items
                    |> List.map
                        (\itemBlocks ->
                            li []
                                (renderAll model
                                    itemBlocks
                                )
                        )
                )
    , codeBlock = \_ _ -> div [] []
    , thematicBreak = \_ -> hr [] []
    , table = \children model -> div [] (renderAll model children)
    , tableHeader = \children model -> div [] (renderAll model children)
    , tableBody = \children model -> div [] (renderAll model children)
    , tableRow = \children model -> div [] (renderAll model children)
    , tableCell = \maybeAlignment children model -> div [] (renderAll model children)
    , tableHeaderCell = \_ _ _ -> div [] []
    , strikethrough =
        \children model -> Html.del [] (renderAll model children)
    }


codeBlock : { body : String, language : Maybe String } -> Element msg
codeBlock details =
    Element.el
        [ Element.Background.color (Element.rgba 0 0 0 0.03)
        , Element.htmlAttribute (Html.Attributes.style "white-space" "pre")
        , Element.padding 20
        , Font.family
            [ Font.external
                { url = "https://fonts.googleapis.com/css?family=Source+Code+Pro"
                , name = "Source Code Pro"
                }
            ]
        ]
        (Element.text details.body)


code : String -> Element msg
code snippet =
    Element.el
        [ Element.Background.color
            (Element.rgba 0 0 0 0.04)
        , Element.Border.rounded 2
        , Element.paddingXY 5 3
        , Font.family
            [ Font.external
                { url = "https://fonts.googleapis.com/css?family=Source+Code+Pro"
                , name = "Source Code Pro"
                }
            ]
        ]
        (Element.text snippet)


rawTextToId rawText =
    rawText
        |> String.split " "
        |> String.join "-"
        |> String.toLower


heading :
    { level : Block.HeadingLevel
    , rawText : String
    , children :
        List (Model -> Html.Html msg)
    }
    -> Model
    -> Html.Html msg
heading { level, rawText, children } model =
    let
        commonCss =
            [ Tw.font_header
            , Tw.text_gray_800
            , Tw.tracking_tight
            , Tw.text_center
            , Tw.mx_1
            , Tw.font_bold
            , Tw.mb_4
            ]
    in
    case level of
        Block.H1 ->
            h1
                [ css
                    ([ Bp.md [ Tw.text_4xl ]
                     , Tw.text_3xl
                     , Tw.mt_4
                     ]
                        ++ commonCss
                    )
                ]
                (renderAll model children)

        Block.H2 ->
            h2
                [ Attr.id (rawTextToId rawText)
                , Attr.attribute "name" (rawTextToId rawText)
                , css
                    ([ Tw.text_3xl
                     , Tw.mt_6
                     ]
                        ++ commonCss
                    )
                ]
                (renderAll model children)

        _ ->
            (case level of
                Block.H1 ->
                    h1

                Block.H2 ->
                    h2

                Block.H3 ->
                    h3

                Block.H4 ->
                    h4

                Block.H5 ->
                    h5

                Block.H6 ->
                    h6
            )
                [ css
                    ([ Tw.text_lg
                     , Tw.mt_4
                     ]
                        ++ commonCss
                    )
                ]
                (renderAll model children)


renderAll : model -> List (model -> view) -> List view
renderAll model =
    List.map ((|>) model)


textToCss : Maybe String -> List Css.Style
textToCss maybeColor =
    case maybeColor of
        Just "gray" ->
            [ Tw.bg_gray_200
            , Tw.py_1
            , Bp.md [ Tw.bg_white ]
            ]

        Just "y_4" ->
            [ Tw.space_y_4 ]

        Just "text_left" ->
            [ Tw.text_left ]

        Just _ ->
            []

        Nothing ->
            []


textToTW : String -> Css.Style
textToTW string_ =
    case string_ of
        "bg_gray_200" ->
            Tw.bg_gray_200

        "space_y_4" ->
            Tw.space_y_4

        "text_left" ->
            Tw.text_left

        _ ->
            Tw.transform_none



-- TODO: fix this hack


buy : Html.Html Msg
buy =
    {- This example requires Tailwind CSS v2.0+ -}
    div
        [ css
            -- [ Tw.bg_gray_900
            [ Tw.bg_blue_600
            , Tw.w_screen
            ]
        ]
        [ div
            [ css
                [ Tw.pt_12
                , Bp.lg
                    [ Tw.pt_24
                    ]
                , Bp.sm
                    [ Tw.pt_16
                    ]
                ]
            ]
            [ div
                [ css
                    [ Tw.max_w_7xl
                    , Tw.mx_auto
                    , Tw.text_center
                    , Tw.px_4
                    , Bp.lg
                        [ Tw.px_8
                        ]
                    , Bp.sm
                        [ Tw.px_6
                        ]
                    ]
                ]
                [ div
                    [ css
                        [ Tw.max_w_3xl
                        , Tw.mx_auto
                        , Tw.space_y_2
                        , Bp.lg
                            [ Tw.max_w_none
                            ]
                        ]
                    ]
                    [ h2
                        [ css
                            [ Tw.text_lg
                            , Tw.leading_6
                            , Tw.font_semibold
                            , Tw.text_gray_300
                            , Tw.uppercase
                            , Tw.tracking_wider
                            ]
                        ]
                        [ text "Pricing" ]
                    , p
                        [ css
                            [ Tw.text_3xl
                            , Tw.font_extrabold
                            , Tw.text_white
                            , Bp.lg
                                [ Tw.text_5xl
                                ]
                            , Bp.sm
                                [ Tw.text_4xl
                                ]
                            ]
                        ]
                        [ text "The right price for you, whoever you are" ]
                    , p
                        [ css
                            [ Tw.text_xl
                            , Tw.text_gray_300
                            ]
                        ]
                        [ text "Lorem ipsum dolor, sit amet consectetur adipisicing elit. Harum sequi unde repudiandae natus." ]
                    ]
                ]
            ]
        , div
            [ css
                [ Tw.mt_8
                , Tw.pb_12
                , Tw.bg_gray_50
                , Bp.lg
                    [ Tw.mt_16
                    , Tw.pb_24
                    ]
                , Bp.sm
                    [ Tw.mt_12
                    , Tw.pb_16
                    ]
                ]
            ]
            [ div
                [ css
                    [ Tw.relative
                    ]
                ]
                [ div
                    [ css
                        [ Tw.absolute
                        , Tw.inset_0
                        , Tw.h_3over4
                        , Tw.bg_blue_600
                        ]
                    ]
                    []
                , div
                    [ css
                        [ Tw.relative
                        , Tw.z_10
                        , Tw.max_w_7xl
                        , Tw.mx_auto
                        , Tw.px_4
                        , Bp.lg
                            [ Tw.px_8
                            ]
                        , Bp.sm
                            [ Tw.px_6
                            ]
                        ]
                    ]
                    [ div
                        [ css
                            [ Bp.lg
                                [ Tw.max_w_5xl
                                , Tw.grid
                                , Tw.grid_cols_2
                                , Tw.gap_5
                                , Tw.space_y_0
                                ]
                            , Tw.max_w_md
                            , Tw.mx_auto
                            , Tw.space_y_4
                            ]
                        ]
                        [ div
                            [ css
                                [ Tw.flex
                                , Tw.flex_col
                                , Tw.rounded_lg
                                , Tw.shadow_lg
                                , Tw.overflow_hidden
                                ]
                            ]
                            [ div
                                [ css
                                    [ Tw.px_6
                                    , Tw.py_8
                                    , Tw.bg_white
                                    , Bp.sm
                                        [ Tw.p_10
                                        , Tw.pb_6
                                        ]
                                    ]
                                ]
                                [ div []
                                    [ h3
                                        [ css
                                            [ Tw.inline_flex
                                            , Tw.px_4
                                            , Tw.py_1
                                            , Tw.rounded_full
                                            , Tw.text_sm
                                            , Tw.font_semibold
                                            , Tw.tracking_wide
                                            , Tw.uppercase
                                            , Tw.bg_indigo_100
                                            , Tw.text_indigo_600
                                            ]
                                        , Attr.id "tier-standard"
                                        ]
                                        [ text "Book" ]
                                    ]
                                , div
                                    [ css
                                        [ Tw.mt_4
                                        , Tw.flex
                                        , Tw.items_baseline
                                        , Tw.text_6xl
                                        , Tw.font_extrabold
                                        ]
                                    ]
                                    [ text "$60"
                                    ]
                                , p
                                    [ css
                                        [ Tw.mt_5
                                        , Tw.text_lg
                                        , Tw.text_gray_500
                                        ]
                                    ]
                                    [ text "Lorem ipsum dolor sit amet consectetur, adipisicing elit." ]
                                ]
                            , div
                                [ css
                                    [ Tw.flex_1
                                    , Tw.flex
                                    , Tw.flex_col
                                    , Tw.justify_between
                                    , Tw.px_6
                                    , Tw.pt_6
                                    , Tw.pb_8
                                    , Tw.bg_gray_50
                                    , Tw.space_y_6
                                    , Bp.sm
                                        [ Tw.p_10
                                        , Tw.pt_6
                                        ]
                                    ]
                                ]
                                [ ul
                                    [ css
                                        [ Tw.space_y_4
                                        ]
                                    ]
                                    [ li
                                        [ css
                                            [ Tw.flex
                                            , Tw.items_start
                                            ]
                                        ]
                                        [ div
                                            [ css
                                                [ Tw.flex_shrink_0
                                                ]
                                            ]
                                            [ {- Heroicon name: outline/check -}
                                              svg
                                                [ SvgAttr.css
                                                    [ Tw.h_6
                                                    , Tw.w_6
                                                    , Tw.text_green_500
                                                    ]
                                                , SvgAttr.fill "none"
                                                , SvgAttr.viewBox "0 0 24 24"
                                                , SvgAttr.stroke "currentColor"
                                                , Attr.attribute "aria-hidden" "true"
                                                ]
                                                [ path
                                                    [ SvgAttr.strokeLinecap "round"
                                                    , SvgAttr.strokeLinejoin "round"
                                                    , SvgAttr.strokeWidth "2"
                                                    , SvgAttr.d "M5 13l4 4L19 7"
                                                    ]
                                                    []
                                                ]
                                            ]
                                        , p
                                            [ css
                                                [ Tw.text_base
                                                , Tw.text_gray_700
                                                , Tw.ml_3
                                                ]
                                            ]
                                            [ text "The 270 page book in PDF format" ]
                                        ]
                                    , li
                                        [ css
                                            [ Tw.flex
                                            , Tw.items_start
                                            ]
                                        ]
                                        [ div
                                            [ css
                                                [ Tw.flex_shrink_0
                                                ]
                                            ]
                                            [ {- Heroicon name: outline/check -}
                                              svg
                                                [ SvgAttr.css
                                                    [ Tw.h_6
                                                    , Tw.w_6
                                                    , Tw.text_green_500
                                                    ]
                                                , SvgAttr.fill "none"
                                                , SvgAttr.viewBox "0 0 24 24"
                                                , SvgAttr.stroke "currentColor"
                                                , Attr.attribute "aria-hidden" "true"
                                                ]
                                                [ path
                                                    [ SvgAttr.strokeLinecap "round"
                                                    , SvgAttr.strokeLinejoin "round"
                                                    , SvgAttr.strokeWidth "2"
                                                    , SvgAttr.d "M5 13l4 4L19 7"
                                                    ]
                                                    []
                                                ]
                                            ]
                                        , p
                                            [ css
                                                [ Tw.ml_3
                                                , Tw.text_base
                                                , Tw.text_gray_700
                                                ]
                                            ]
                                            [ text "23 example scripts, 3 datasets, 100+ problems & full solutions " ]
                                        ]
                                    , li
                                        [ css
                                            [ Tw.flex
                                            , Tw.items_start
                                            ]
                                        ]
                                        [ div
                                            [ css
                                                [ Tw.flex_shrink_0
                                                ]
                                            ]
                                            [ {- Heroicon name: outline/check -}
                                              svg
                                                [ SvgAttr.css
                                                    [ Tw.h_6
                                                    , Tw.w_6
                                                    , Tw.text_green_500
                                                    ]
                                                , SvgAttr.fill "none"
                                                , SvgAttr.viewBox "0 0 24 24"
                                                , SvgAttr.stroke "currentColor"
                                                , Attr.attribute "aria-hidden" "true"
                                                ]
                                                [ path
                                                    [ SvgAttr.strokeLinecap "round"
                                                    , SvgAttr.strokeLinejoin "round"
                                                    , SvgAttr.strokeWidth "2"
                                                    , SvgAttr.d "M5 13l4 4L19 7"
                                                    ]
                                                    []
                                                ]
                                            ]
                                        , p
                                            [ css
                                                [ Tw.ml_3
                                                , Tw.text_base
                                                , Tw.text_gray_700
                                                ]
                                            ]
                                            [ text "300+ spaced repetition flash cards " ]
                                        ]

                                    -- , li
                                    --     [ css
                                    --         [ Tw.flex
                                    --         , Tw.items_start
                                    --         ]
                                    --     ]
                                    --     [ div
                                    --         [ css
                                    --             [ Tw.flex_shrink_0
                                    --             ]
                                    --         ]
                                    --         [ {- Heroicon name: outline/check -}
                                    --           svg
                                    --             [ SvgAttr.css
                                    --                 [ Tw.h_6
                                    --                 , Tw.w_6
                                    --                 , Tw.text_green_500
                                    --                 ]
                                    --             , SvgAttr.fill "none"
                                    --             , SvgAttr.viewBox "0 0 24 24"
                                    --             , SvgAttr.stroke "currentColor"
                                    --             , Attr.attribute "aria-hidden" "true"
                                    --             ]
                                    --             [ path
                                    --                 [ SvgAttr.strokeLinecap "round"
                                    --                 , SvgAttr.strokeLinejoin "round"
                                    --                 , SvgAttr.strokeWidth "2"
                                    --                 , SvgAttr.d "M5 13l4 4L19 7"
                                    --                 ]
                                    --                 []
                                    --             ]
                                    --         ]
                                    --     , p
                                    --         [ css
                                    --             [ Tw.ml_3
                                    --             , Tw.text_base
                                    --             , Tw.text_gray_700
                                    --             ]
                                    --         ]
                                    --         [ text "Itaque cupiditate adipisci quibusdam" ]
                                    --     ]
                                    ]
                                , div
                                    [ css
                                        [ Tw.rounded_md
                                        , Tw.shadow
                                        ]
                                    ]
                                    [ a
                                        [ Attr.href "#"
                                        , css
                                            [ Tw.flex
                                            , Tw.items_center
                                            , Tw.justify_center
                                            , Tw.px_5
                                            , Tw.py_3
                                            , Tw.border
                                            , Tw.border_transparent
                                            , Tw.text_base
                                            , Tw.font_medium
                                            , Tw.rounded_md
                                            , Tw.text_gray_900
                                            , Tw.bg_gray_200
                                            , Css.hover
                                                [ Tw.bg_gray_400
                                                ]
                                            ]
                                        , Attr.attribute "aria-describedby" "tier-standard"
                                        ]
                                        [ text "Buy Now" ]
                                    ]
                                ]
                            ]
                        , div
                            [ css
                                [ Tw.flex
                                , Tw.flex_col
                                , Tw.rounded_lg
                                , Tw.shadow_lg
                                , Tw.overflow_hidden
                                ]
                            ]
                            [ div
                                [ css
                                    [ Tw.px_6
                                    , Tw.py_8
                                    , Tw.bg_white
                                    , Bp.sm
                                        [ Tw.p_10
                                        , Tw.pb_6
                                        ]
                                    ]
                                ]
                                [ div []
                                    [ h3
                                        [ css
                                            [ Tw.inline_flex
                                            , Tw.px_4
                                            , Tw.py_1
                                            , Tw.rounded_full
                                            , Tw.text_sm
                                            , Tw.font_semibold
                                            , Tw.tracking_wide
                                            , Tw.uppercase
                                            , Tw.bg_indigo_100
                                            , Tw.text_indigo_600
                                            ]
                                        , Attr.id "tier-standard"
                                        ]
                                        [ text "Book + 2021 Developer Kit" ]
                                    ]
                                , div
                                    [ css
                                        [ Tw.mt_4
                                        , Tw.flex
                                        , Tw.items_baseline
                                        , Tw.text_6xl
                                        , Tw.font_extrabold
                                        ]
                                    ]
                                    [ text "$140"
                                    ]
                                , p
                                    [ css
                                        [ Tw.mt_5
                                        , Tw.text_lg
                                        , Tw.text_gray_500
                                        ]
                                    ]
                                    [ text "Lorem ipsum dolor sit amet consectetur, adipisicing elit." ]
                                ]
                            , div
                                [ css
                                    [ Tw.flex_1
                                    , Tw.flex
                                    , Tw.flex_col
                                    , Tw.justify_between
                                    , Tw.px_6
                                    , Tw.pt_6
                                    , Tw.pb_8
                                    , Tw.bg_gray_50
                                    , Tw.space_y_6
                                    , Bp.sm
                                        [ Tw.p_10
                                        , Tw.pt_6
                                        ]
                                    ]
                                ]
                                [ ul
                                    [ css
                                        [ Tw.space_y_4
                                        ]
                                    ]
                                    [ li
                                        [ css
                                            [ Tw.flex
                                            , Tw.items_start
                                            ]
                                        ]
                                        [ div
                                            [ css
                                                [ Tw.flex_shrink_0
                                                ]
                                            ]
                                            [ {- Heroicon name: outline/check -}
                                              svg
                                                [ SvgAttr.css
                                                    [ Tw.h_6
                                                    , Tw.w_6
                                                    , Tw.text_green_500
                                                    ]
                                                , SvgAttr.fill "none"
                                                , SvgAttr.viewBox "0 0 24 24"
                                                , SvgAttr.stroke "currentColor"
                                                , Attr.attribute "aria-hidden" "true"
                                                ]
                                                [ path
                                                    [ SvgAttr.strokeLinecap "round"
                                                    , SvgAttr.strokeLinejoin "round"
                                                    , SvgAttr.strokeWidth "2"
                                                    , SvgAttr.d "M5 13l4 4L19 7"
                                                    ]
                                                    []
                                                ]
                                            ]
                                        , p
                                            [ css
                                                [ Tw.ml_3
                                                , Tw.text_base
                                                , Tw.text_gray_700
                                                ]
                                            ]
                                            [ text "The 270 page book in PDF format" ]
                                        ]
                                    , li
                                        [ css
                                            [ Tw.flex
                                            , Tw.items_start
                                            ]
                                        ]
                                        [ div
                                            [ css
                                                [ Tw.flex_shrink_0
                                                ]
                                            ]
                                            [ {- Heroicon name: outline/check -}
                                              svg
                                                [ SvgAttr.css
                                                    [ Tw.h_6
                                                    , Tw.w_6
                                                    , Tw.text_green_500
                                                    ]
                                                , SvgAttr.fill "none"
                                                , SvgAttr.viewBox "0 0 24 24"
                                                , SvgAttr.stroke "currentColor"
                                                , Attr.attribute "aria-hidden" "true"
                                                ]
                                                [ path
                                                    [ SvgAttr.strokeLinecap "round"
                                                    , SvgAttr.strokeLinejoin "round"
                                                    , SvgAttr.strokeWidth "2"
                                                    , SvgAttr.d "M5 13l4 4L19 7"
                                                    ]
                                                    []
                                                ]
                                            ]
                                        , p
                                            [ css
                                                [ Tw.ml_3
                                                , Tw.text_base
                                                , Tw.text_gray_700
                                                ]
                                            ]
                                            [ text "23 example scripts, 3 datasets, 100+ problems & full solutions " ]
                                        ]
                                    , li
                                        [ css
                                            [ Tw.flex
                                            , Tw.items_start
                                            ]
                                        ]
                                        [ div
                                            [ css
                                                [ Tw.flex_shrink_0
                                                ]
                                            ]
                                            [ {- Heroicon name: outline/check -}
                                              svg
                                                [ SvgAttr.css
                                                    [ Tw.h_6
                                                    , Tw.w_6
                                                    , Tw.text_green_500
                                                    ]
                                                , SvgAttr.fill "none"
                                                , SvgAttr.viewBox "0 0 24 24"
                                                , SvgAttr.stroke "currentColor"
                                                , Attr.attribute "aria-hidden" "true"
                                                ]
                                                [ path
                                                    [ SvgAttr.strokeLinecap "round"
                                                    , SvgAttr.strokeLinejoin "round"
                                                    , SvgAttr.strokeWidth "2"
                                                    , SvgAttr.d "M5 13l4 4L19 7"
                                                    ]
                                                    []
                                                ]
                                            ]
                                        , p
                                            [ css
                                                [ Tw.ml_3
                                                , Tw.text_base
                                                , Tw.text_gray_700
                                                ]
                                            ]
                                            [ text "300+ spaced repetition flash cards " ]
                                        ]
                                    , li
                                        [ css
                                            [ Tw.flex
                                            , Tw.items_start
                                            ]
                                        ]
                                        [ div
                                            [ css
                                                [ Tw.flex_shrink_0
                                                ]
                                            ]
                                            [ {- Heroicon name: outline/check -}
                                              svg
                                                [ SvgAttr.css
                                                    [ Tw.h_6
                                                    , Tw.w_6
                                                    , Tw.text_green_500
                                                    ]
                                                , SvgAttr.fill "none"
                                                , SvgAttr.viewBox "0 0 24 24"
                                                , SvgAttr.stroke "currentColor"
                                                , Attr.attribute "aria-hidden" "true"
                                                ]
                                                [ path
                                                    [ SvgAttr.strokeLinecap "round"
                                                    , SvgAttr.strokeLinejoin "round"
                                                    , SvgAttr.strokeWidth "2"
                                                    , SvgAttr.d "M5 13l4 4L19 7"
                                                    ]
                                                    []
                                                ]
                                            ]
                                        , p
                                            [ css
                                                [ Tw.ml_3
                                                , Tw.text_base
                                                , Tw.text_gray_700
                                                ]
                                            ]
                                            [ text "Four step-by-step project guides + final code" ]
                                        ]
                                    , li
                                        [ css
                                            [ Tw.flex
                                            , Tw.items_start
                                            ]
                                        ]
                                        [ div
                                            [ css
                                                [ Tw.flex_shrink_0
                                                ]
                                            ]
                                            [ {- Heroicon name: outline/check -}
                                              svg
                                                [ SvgAttr.css
                                                    [ Tw.h_6
                                                    , Tw.w_6
                                                    , Tw.text_green_500
                                                    ]
                                                , SvgAttr.fill "none"
                                                , SvgAttr.viewBox "0 0 24 24"
                                                , SvgAttr.stroke "currentColor"
                                                , Attr.attribute "aria-hidden" "true"
                                                ]
                                                [ path
                                                    [ SvgAttr.strokeLinecap "round"
                                                    , SvgAttr.strokeLinejoin "round"
                                                    , SvgAttr.strokeWidth "2"
                                                    , SvgAttr.d "M5 13l4 4L19 7"
                                                    ]
                                                    []
                                                ]
                                            ]
                                        , p
                                            [ css
                                                [ Tw.ml_3
                                                , Tw.text_base
                                                , Tw.text_gray_700
                                                ]
                                            ]
                                            [ text "2021 Fantasy Math Simulation API Access" ]
                                        ]
                                    , li
                                        [ css
                                            [ Tw.flex
                                            , Tw.items_start
                                            ]
                                        ]
                                        [ div
                                            [ css
                                                [ Tw.flex_shrink_0
                                                ]
                                            ]
                                            [ {- Heroicon name: outline/check -}
                                              svg
                                                [ SvgAttr.css
                                                    [ Tw.h_6
                                                    , Tw.w_6
                                                    , Tw.text_green_500
                                                    ]
                                                , SvgAttr.fill "none"
                                                , SvgAttr.viewBox "0 0 24 24"
                                                , SvgAttr.stroke "currentColor"
                                                , Attr.attribute "aria-hidden" "true"
                                                ]
                                                [ path
                                                    [ SvgAttr.strokeLinecap "round"
                                                    , SvgAttr.strokeLinejoin "round"
                                                    , SvgAttr.strokeWidth "2"
                                                    , SvgAttr.d "M5 13l4 4L19 7"
                                                    ]
                                                    []
                                                ]
                                            ]
                                        , p
                                            [ css
                                                [ Tw.ml_3
                                                , Tw.text_base
                                                , Tw.text_gray_700
                                                ]
                                            ]
                                            [ text "2021 Fantasy Math Web Access" ]
                                        ]
                                    ]
                                , div
                                    [ css
                                        [ Tw.rounded_md
                                        , Tw.shadow
                                        ]
                                    ]
                                    [ a
                                        [ Attr.href "#"
                                        , css
                                            [ Tw.flex
                                            , Tw.items_center
                                            , Tw.justify_center
                                            , Tw.px_5
                                            , Tw.py_3
                                            , Tw.border
                                            , Tw.border_transparent
                                            , Tw.text_base
                                            , Tw.font_medium
                                            , Tw.rounded_md
                                            , Tw.text_white
                                            , Tw.bg_gray_800
                                            , Css.hover
                                                [ Tw.bg_gray_900
                                                ]
                                            ]
                                        , Attr.attribute "aria-describedby" "tier-standard"
                                        ]
                                        [ text "Buy Now" ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            , div
                [ css
                    [ Tw.mt_4
                    , Tw.relative
                    , Tw.max_w_7xl
                    , Tw.mx_auto
                    , Tw.px_4
                    , Bp.lg
                        [ Tw.px_8
                        , Tw.mt_5
                        ]
                    , Bp.sm
                        [ Tw.px_6
                        ]
                    ]
                ]
                [ div
                    [ css
                        [ Tw.max_w_md
                        , Tw.mx_auto
                        , Bp.lg
                            [ Tw.max_w_5xl
                            ]
                        ]
                    ]
                    [ div
                        [ css
                            [ Tw.rounded_lg
                            , Tw.bg_gray_100
                            , Tw.px_6
                            , Tw.py_8
                            , Bp.lg
                                [ Tw.flex
                                , Tw.items_center
                                ]
                            , Bp.sm
                                [ Tw.p_10
                                ]
                            ]
                        ]
                        [ div
                            [ css
                                [ Tw.flex_1
                                ]
                            ]
                            [ div []
                                [ h3
                                    [ css
                                        [ Tw.inline_flex
                                        , Tw.px_4
                                        , Tw.py_1
                                        , Tw.rounded_full
                                        , Tw.text_sm
                                        , Tw.font_semibold
                                        , Tw.tracking_wide
                                        , Tw.uppercase
                                        , Tw.bg_white
                                        , Tw.text_gray_800
                                        ]
                                    ]
                                    [ text "Api Access Only" ]
                                ]
                            , div
                                [ css
                                    [ Tw.mt_4
                                    , Tw.text_lg
                                    , Tw.text_gray_600
                                    ]
                                ]
                                [ text "Already own Learn to Code with Fantasy Football and just need API access? Get it now for "
                                , span
                                    [ css
                                        [ Tw.font_semibold
                                        , Tw.text_gray_900
                                        ]
                                    ]
                                    [ text "$100" ]
                                , text "."
                                ]
                            ]
                        , div
                            [ css
                                [ Tw.mt_6
                                , Tw.rounded_md
                                , Tw.shadow
                                , Bp.lg
                                    [ Tw.mt_0
                                    , Tw.ml_10
                                    , Tw.flex_shrink_0
                                    ]
                                ]
                            ]
                            [ a
                                [ Attr.href "#"
                                , css
                                    [ Tw.flex
                                    , Tw.items_center
                                    , Tw.justify_center
                                    , Tw.px_5
                                    , Tw.py_3
                                    , Tw.border
                                    , Tw.border_transparent
                                    , Tw.text_base
                                    , Tw.font_medium
                                    , Tw.rounded_md
                                    , Tw.text_gray_900
                                    , Tw.bg_white
                                    , Css.hover
                                        [ Tw.bg_gray_50
                                        ]
                                    ]
                                ]
                                [ text "Buy 2021 Developer Kit" ]
                            ]
                        ]
                    ]
                ]
            ]
        ]


feature : Model -> Html.Html Msg
feature model =
    let
        id =
            "main"

        group =
            "107409184"
    in
    div
        [ css
            [ Tw.overflow_hidden
            , Bp.lg [ Tw.mt_32 ]
            , Bp.md [ Tw.mt_16 ]
            , Tw.mt_8
            ]
        ]
        [ div
            [ css
                [ Tw.relative
                , Tw.max_w_xl
                , Tw.mx_auto
                , Tw.px_4
                , Bp.lg
                    [ Tw.px_8
                    , Tw.max_w_7xl
                    ]
                , Bp.sm
                    [ Tw.px_6
                    ]
                ]
            ]
            [ svg
                [ SvgAttr.css
                    [ Tw.hidden
                    , Tw.absolute
                    , Tw.left_full
                    , Tw.transform
                    , Tw.neg_translate_x_1over2
                    , Tw.neg_translate_y_1over4
                    , Bp.lg
                        [ Tw.block
                        ]
                    ]
                , SvgAttr.width "404"
                , SvgAttr.height "784"
                , SvgAttr.fill "none"
                , SvgAttr.viewBox "0 0 404 784"
                , Attr.attribute "aria-hidden" "true"
                ]
                [ Svg.defs []
                    [ Svg.pattern
                        [ SvgAttr.id "b1e6e422-73f8-40a6-b5d9-c8586e37e0e7"
                        , SvgAttr.x "0"
                        , SvgAttr.y "0"
                        , SvgAttr.width "20"
                        , SvgAttr.height "20"
                        , SvgAttr.patternUnits "userSpaceOnUse"
                        ]
                        [ Svg.rect
                            [ SvgAttr.x "0"
                            , SvgAttr.y "0"
                            , SvgAttr.width "4"
                            , SvgAttr.height "4"
                            , SvgAttr.css
                                [ Tw.text_gray_200
                                ]
                            , SvgAttr.fill "currentColor"
                            ]
                            []
                        ]
                    ]
                , Svg.rect
                    [ SvgAttr.width "404"
                    , SvgAttr.height "784"
                    , SvgAttr.fill "url(#b1e6e422-73f8-40a6-b5d9-c8586e37e0e7)"
                    ]
                    []
                ]
            , div
                [ css
                    [ Tw.relative
                    ]
                ]
                [ h2
                    [ css
                        [ Bp.md
                            [ Tw.text_5xl
                            , Tw.tracking_tight
                            , Tw.max_w_3xl
                            ]
                        , Tw.max_w_sm
                        , Tw.text_4xl
                        , Tw.text_center
                        , Tw.mx_auto
                        , Tw.leading_8
                        , Tw.font_extrabold
                        , Tw.text_gray_900
                        ]
                    ]
                    [ text "Learn to Code with Fantasy Football" ]
                , p
                    [ css
                        [ Bp.md [ Tw.text_2xl, Tw.max_w_3xl ]
                        , Tw.max_w_sm
                        , Tw.mt_4
                        , Tw.text_xl
                        , Tw.mx_auto
                        , Tw.text_center
                        , Tw.text_gray_500
                        ]
                    ]
                    [ text "Python. Pandas. Web Scraping. Databases. SQL. Machine Learning. APIs." ]
                , p
                    [ css
                        [ Bp.md [ Tw.text_2xl, Tw.mt_0 ]
                        , Tw.text_xl
                        , Tw.max_w_2xl
                        , Tw.mx_auto
                        , Tw.text_center
                        , Tw.mt_2
                        , Tw.text_gray_500
                        ]
                    ]
                    [ text "All applied to Fantasy Football." ]
                ]
            , div
                [ css
                    [ Tw.relative
                    , Tw.mt_8
                    , Tw.flex
                    , Tw.flex_wrap
                    , Tw.items_center
                    , Tw.justify_around
                    ]
                ]
                [ div
                    [ css
                        [ Bp.lg
                            [ Tw.w_1over2
                            , Tw.order_1
                            ]
                        , Tw.mx_4
                        , Tw.order_2
                        , Tw.h_full
                        ]
                    ]
                    [ h3
                        [ css
                            [ Tw.text_2xl
                            , Bp.md
                                [ Tw.text_3xl
                                , Tw.tracking_tight
                                ]
                            , Tw.font_extrabold
                            , Tw.text_gray_900
                            , Tw.tracking_tight
                            ]
                        ]
                        [ text "Learn Python & Data Science Fundamentals with Fantasy Football" ]
                    , p
                        [ css
                            [ Tw.mt_3
                            , Tw.text_lg
                            , Tw.text_gray_500
                            ]
                        ]
                        [ text "Learning to code isn't "
                        , span [ css [ Tw.italic ] ] [ text "hard" ]
                        , text ", there's just a learning curve. That's why the most important thing is starting with a project you're excited about."
                        ]
                    , p
                        [ css
                            [ Tw.mt_3
                            , Tw.text_lg
                            , Tw.text_gray_500
                            ]
                        ]
                        [ text "This book will take you from playing around with stats in Excel to scraping websites, building databases and running your own machine learning models."
                        ]
                    , form
                        [ css
                            [ Tw.flex
                            , Tw.flex_wrap
                            , Bp.md [ Tw.flex_nowrap ]
                            , Tw.items_center
                            , Tw.justify_start
                            , Tw.w_full
                            , Tw.mt_8
                            ]
                        , onSubmit (SubmitEmail group id model.email)
                        ]
                        [ label
                            [ Attr.for "emailAddress"
                            , css []
                            ]
                            []
                        , input
                            [ Attr.id "emailAddress"
                            , Attr.name "email"
                            , Attr.type_ "email"
                            , Attr.attribute "autocomplete" "email"
                            , Attr.required True
                            , Attr.value model.email
                            , onInput UpdateEmail
                            , css
                                [ Tw.w_full
                                , Tw.placeholder_gray_500
                                , Tw.border_gray_200
                                , Tw.rounded_xl
                                , Tw.py_3
                                , Tw.px_2
                                , Tw.text_base
                                , Tw.mr_2
                                , Css.focus
                                    [ Tw.ring_indigo_500
                                    , Tw.border_indigo_500
                                    ]
                                ]
                            , Attr.placeholder "Email"
                            ]
                            []
                        , div
                            [ css
                                [ Tw.rounded_md
                                , Tw.shadow
                                , Tw.flex_none
                                , Tw.mx_auto
                                ]
                            ]
                            [ button
                                [ Attr.type_ "submit"
                                , css
                                    [ Tw.w_full
                                    , Tw.mt_3
                                    , Bp.md [ Tw.mt_0 ]
                                    , Tw.px_5
                                    , Tw.py_3
                                    , Tw.text_base
                                    , Tw.font_medium
                                    , Tw.rounded_md
                                    , Tw.text_white
                                    , Tw.bg_blue_500
                                    , Tw.font_semibold
                                    , Css.focus
                                        [ Tw.outline_none
                                        , Tw.ring_2
                                        , Tw.ring_offset_2
                                        , Tw.ring_blue_400
                                        ]
                                    , Css.hover
                                        [ Tw.bg_blue_600
                                        ]
                                    ]
                                ]
                                [ text "Send me a free sample chapter" ]
                            ]
                        ]
                    , div
                        [ css
                            [ Tw.px_2
                            , Tw.flex
                            , Tw.items_center
                            , Tw.justify_center
                            , Tw.flex_wrap
                            , Bp.md [ Tw.space_x_1 ]
                            , Tw.mt_4
                            , Tw.mb_8
                            ]
                        ]
                        [ a
                            [ Attr.href "https://transactions.sendowl.com/packages/801053/D380E68E/purchase"
                            , css
                                [ Tw.border_none
                                , Tw.bg_white
                                , Tw.text_lg
                                , Tw.text_blue_600
                                , Tw.underline
                                , Tw.font_semibold
                                ]
                            , onClick (OpenCheckout "buy")
                            ]
                            [ text "Ready to buy now?" ]
                        , span [ css [ Tw.hidden, Bp.md [ Tw.inline_flex ] ] ]
                            [ text " — " ]
                        , span [ css [ Tw.inline_flex ] ] [ text "30 day money back guarantee!" ]
                        ]
                    ]
                , div
                    [ css
                        [ Tw.neg_mx_4
                        , Tw.relative
                        , Bp.lg
                            [ Tw.mt_0
                            , Tw.order_1
                            , Tw.mt_10
                            ]
                        , Tw.mb_6
                        ]
                    , Attr.attribute "aria-hidden" "true"
                    ]
                    [ svg
                        [ SvgAttr.css
                            [ Tw.absolute
                            , Tw.left_1over2
                            , Tw.transform
                            , Tw.neg_translate_x_1over2
                            , Tw.translate_y_16
                            , Bp.lg
                                [ Tw.hidden
                                ]
                            ]
                        , SvgAttr.width "784"
                        , SvgAttr.height "404"
                        , SvgAttr.fill "none"
                        , SvgAttr.viewBox "0 0 784 404"
                        ]
                        [ Svg.defs []
                            [ Svg.pattern
                                [ SvgAttr.id "ca9667ae-9f92-4be7-abcb-9e3d727f2941"
                                , SvgAttr.x "0"
                                , SvgAttr.y "0"
                                , SvgAttr.width "20"
                                , SvgAttr.height "20"
                                , SvgAttr.patternUnits "userSpaceOnUse"
                                ]
                                [ Svg.rect
                                    [ SvgAttr.x "0"
                                    , SvgAttr.y "0"
                                    , SvgAttr.width "4"
                                    , SvgAttr.height "4"
                                    , SvgAttr.css
                                        [ Tw.text_gray_200
                                        ]
                                    , SvgAttr.fill "currentColor"
                                    ]
                                    []
                                ]
                            ]
                        , Svg.rect
                            [ SvgAttr.width "784"
                            , SvgAttr.height "404"
                            , SvgAttr.fill "url(#ca9667ae-9f92-4be7-abcb-9e3d727f2941)"
                            ]
                            []
                        ]
                    , img
                        [ css
                            [ Tw.relative
                            , Tw.mx_auto
                            ]
                        , Attr.width 350
                        , Attr.src "images/ltcwff_open_no_bg.png"
                        , Attr.alt ""
                        ]
                        []
                    ]
                ]
            , svg
                [ SvgAttr.css
                    [ Tw.hidden
                    , Tw.absolute
                    , Tw.right_full
                    , Tw.transform
                    , Tw.translate_x_1over2
                    , Tw.translate_y_12
                    , Bp.lg
                        [ Tw.block
                        ]
                    ]
                , SvgAttr.width "404"
                , SvgAttr.height "784"
                , SvgAttr.fill "none"
                , SvgAttr.viewBox "0 0 404 784"
                , Attr.attribute "aria-hidden" "true"
                ]
                [ Svg.defs []
                    [ Svg.pattern
                        [ SvgAttr.id "64e643ad-2176-4f86-b3d7-f2c5da3b6a6d"
                        , SvgAttr.x "0"
                        , SvgAttr.y "0"
                        , SvgAttr.width "20"
                        , SvgAttr.height "20"
                        , SvgAttr.patternUnits "userSpaceOnUse"
                        ]
                        [ Svg.rect
                            [ SvgAttr.x "0"
                            , SvgAttr.y "0"
                            , SvgAttr.width "4"
                            , SvgAttr.height "4"
                            , SvgAttr.css
                                [ Tw.text_gray_200
                                ]
                            , SvgAttr.fill "currentColor"
                            ]
                            []
                        ]
                    ]
                , Svg.rect
                    [ SvgAttr.width "404"
                    , SvgAttr.height "784"
                    , SvgAttr.fill "url(#64e643ad-2176-4f86-b3d7-f2c5da3b6a6d)"
                    ]
                    []
                ]
            ]
        ]


praise : Html.Html Msg
praise =
    {- This example requires Tailwind CSS v2.0+ -}
    div [ css [ Tw.w_screen, Tw.bg_gray_100 ] ]
        [ section
            [ css
                [ Tw.py_12
                , Tw.bg_gray_100
                , Tw.overflow_hidden

                -- , Tw.w_screen
                , Bp.lg
                    [ Tw.py_24
                    ]
                , Bp.md
                    [ Tw.py_20
                    ]
                ]
            ]
            [ div
                [ css
                    [ Tw.relative

                    -- , Tw.max_w_7xl
                    , Tw.mx_auto
                    , Tw.px_4
                    , Bp.lg
                        [ Tw.px_8
                        ]
                    , Bp.sm
                        [ Tw.px_6
                        ]
                    ]
                ]
                [ svg
                    [ SvgAttr.css
                        [ Tw.absolute
                        , Tw.top_full
                        , Tw.right_full
                        , Tw.transform
                        , Tw.translate_x_1over3
                        , Tw.neg_translate_y_1over4
                        , Bp.lg
                            [ Tw.translate_x_1over2
                            ]
                        , Bp.xl
                            [ Tw.neg_translate_y_1over2
                            ]
                        ]
                    , SvgAttr.width "404"
                    , SvgAttr.height "404"
                    , SvgAttr.fill "none"
                    , SvgAttr.viewBox "0 0 404 404"
                    , Attr.attribute "role" "img"
                    , Attr.attribute "aria-labelledby" "svg-workcation"
                    ]
                    [ Svg.title
                        [ SvgAttr.id "svg-workcation"
                        ]
                        [ text "Workcation" ]
                    , Svg.defs []
                        [ Svg.pattern
                            [ SvgAttr.id "ad119f34-7694-4c31-947f-5c9d249b21f3"
                            , SvgAttr.x "0"
                            , SvgAttr.y "0"
                            , SvgAttr.width "20"
                            , SvgAttr.height "20"
                            , SvgAttr.patternUnits "userSpaceOnUse"
                            ]
                            [ Svg.rect
                                [ SvgAttr.x "0"
                                , SvgAttr.y "0"
                                , SvgAttr.width "4"
                                , SvgAttr.height "4"
                                , SvgAttr.css
                                    [ Tw.text_gray_200
                                    ]
                                , SvgAttr.fill "currentColor"
                                ]
                                []
                            ]
                        ]
                    , Svg.rect
                        [ SvgAttr.width "404"
                        , SvgAttr.height "404"
                        , SvgAttr.fill "url(#ad119f34-7694-4c31-947f-5c9d249b21f3)"
                        ]
                        []
                    ]
                , div
                    [ css
                        [ Tw.relative
                        ]
                    ]
                    [ img
                        [ css
                            [ Tw.mx_auto
                            , Tw.h_8
                            ]
                        , Attr.src "images/espn.svg"
                        , Attr.alt "Workcation"
                        ]
                        []
                    , blockquote
                        [ css
                            [ Tw.mt_10
                            ]
                        ]
                        [ div
                            [ css
                                [ Tw.max_w_3xl
                                , Tw.mx_auto
                                , Tw.text_center
                                , Tw.text_2xl
                                , Tw.leading_9
                                , Tw.font_medium
                                , Tw.text_gray_900
                                ]
                            ]
                            [ p []
                                [ text "“"
                                , text "This book was really, really well done."
                                , text "”"
                                ]
                            ]
                        , footer
                            [ css
                                [ Tw.mt_8
                                ]
                            ]
                            [ div
                                [ css
                                    [ Bp.md
                                        [ Tw.flex
                                        , Tw.items_center
                                        , Tw.justify_center
                                        ]
                                    ]
                                ]
                                [ div
                                    [ css
                                        [ Bp.md
                                            [ Tw.flex_shrink_0
                                            ]
                                        ]
                                    ]
                                    [ img
                                        [ css
                                            [ Tw.mx_auto
                                            , Tw.h_10
                                            , Tw.w_10
                                            , Tw.rounded_full
                                            ]
                                        , Attr.src "images/billc_headshot.jpg"
                                        , Attr.alt ""
                                        ]
                                        []
                                    ]
                                , div
                                    [ css
                                        [ Tw.mt_3
                                        , Tw.text_center
                                        , Bp.md
                                            [ Tw.mt_0
                                            , Tw.ml_4
                                            , Tw.flex
                                            , Tw.items_center
                                            ]
                                        ]
                                    ]
                                    [ div
                                        [ css
                                            [ Tw.text_base
                                            , Tw.font_medium
                                            , Tw.text_gray_900
                                            ]
                                        ]
                                        [ text "Bill Connelly" ]
                                    , svg
                                        [ SvgAttr.css
                                            [ Tw.hidden
                                            , Tw.mx_1
                                            , Tw.h_5
                                            , Tw.w_5
                                            , Tw.text_indigo_600
                                            , Bp.md
                                                [ Tw.block
                                                ]
                                            ]
                                        , SvgAttr.fill "currentColor"
                                        , SvgAttr.viewBox "0 0 20 20"
                                        ]
                                        [ path
                                            [ SvgAttr.d "M11 0h3L9 20H6l5-20z"
                                            ]
                                            []
                                        ]
                                    , div
                                        [ css
                                            [ Tw.text_base
                                            , Tw.font_medium
                                            , Tw.text_gray_500
                                            ]
                                        ]
                                        [ text "ESPN" ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
