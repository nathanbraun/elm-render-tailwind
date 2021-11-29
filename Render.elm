module Render exposing (styledRenderer)

-- import Html exposing (Html)

import AB exposing (TestVersion, Version(..))
import Buy
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
                            div [ css [ Tw.w_full, Tw.h_full ] ]
                                (renderAll model
                                    children
                                )

                        ( "B", Just B ) ->
                            div
                                [ css
                                    [ Tw.w_full
                                    , Tw.h_full
                                    ]
                                ]
                                (renderAll model
                                    children
                                )

                        _ ->
                            div [ css [ Tw.hidden ] ] []
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
                        [ a
                            [ Attr.href "#more"
                            , css
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
                            ]
                            [ text "See more 👇"
                            ]
                        ]
                )
            , Markdown.Html.tag "buy_football"
                (\_ _ ->
                    Buy.football
                )
            , Markdown.Html.tag "gift_football"
                (\_ _ ->
                    Buy.footballGift
                )
            , Markdown.Html.tag "gift_baseball"
                (\_ _ ->
                    Buy.baseballGift
                )
            , Markdown.Html.tag "buy_baseball"
                (\url _ _ ->
                    Buy.baseball
                )
                |> Markdown.Html.withAttribute "url"
            , Markdown.Html.tag "sdk"
                (\_ _ ->
                    sdk
                )
            , Markdown.Html.tag "praise"
                (\quote name org logo headshot _ _ ->
                    praise quote name org logo headshot
                )
                |> Markdown.Html.withAttribute "quote"
                |> Markdown.Html.withAttribute "name"
                |> Markdown.Html.withAttribute "org"
                |> Markdown.Html.withOptionalAttribute "logo"
                |> Markdown.Html.withAttribute "headshot"
            , Markdown.Html.tag "football_top" footballTop
                |> Markdown.Html.withAttribute "image"
            , Markdown.Html.tag "baseball_top" baseballTop
                |> Markdown.Html.withAttribute "image"
            , Markdown.Html.tag "email_and_buy"
                (\group id url _ model ->
                    emailAndBuy group id url model
                )
                |> Markdown.Html.withAttribute "group"
                |> Markdown.Html.withAttribute "id"
                |> Markdown.Html.withAttribute "url"
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
                            , Tw.h_full
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
                (\src desc _ _ ->
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
                (\group id _ model ->
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
                (\id children model ->
                    div
                        [ css
                            [ Tw.w_screen
                            , Tw.flex
                            , Tw.items_center
                            , Tw.justify_center
                            ]
                        ]
                        [ a [ Attr.id (id |> Maybe.withDefault "") ] []
                        , div
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
                |> Markdown.Html.withOptionalAttribute "id"
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
                (\src desc size id children model ->
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
                    div []
                        [ a [ Attr.id (id |> Maybe.withDefault "") ] []
                        , img
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
                        ]
                )
                |> Markdown.Html.withAttribute "src"
                |> Markdown.Html.withAttribute "desc"
                |> Markdown.Html.withOptionalAttribute "size"
                |> Markdown.Html.withOptionalAttribute "id"
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


footballTop : String -> List (Model -> Html.Html Msg) -> Model -> Html.Html Msg
footballTop image children model =
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
                        , Tw.text_lg
                        , Tw.mx_auto
                        , Tw.text_center
                        , Tw.text_gray_500
                        ]
                    ]
                    [ text "Python. Pandas. Web Scraping. Databases. SQL. Machine Learning. APIs." ]
                , p
                    [ css
                        [ Bp.md [ Tw.text_2xl, Tw.mt_0, Tw.mb_0 ]
                        , Tw.mb_10
                        , Tw.text_lg
                        , Tw.max_w_2xl
                        , Tw.mx_auto
                        , Tw.text_center
                        , Tw.mt_2
                        , Tw.text_gray_500
                        ]
                    ]
                    [ text "All applied to Fantasy Football." ]
                , p
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
                        , Tw.mt_10
                        , Tw.mb_4
                        , Tw.leading_8
                        , Tw.font_extrabold
                        , Tw.text_red_600
                        ]
                    ]
                    [ text "Cyber Monday Sale - 25% Off" ]
                , div
                    [ css
                        [ Tw.px_2
                        , Tw.flex
                        , Tw.items_center
                        , Tw.justify_center
                        , Tw.flex_wrap
                        , Tw.text_3xl
                        , Tw.mb_4
                        , Bp.md
                            [ Tw.space_x_1
                            , Tw.my_0
                            ]
                        ]
                    ]
                    [ a
                        [ Attr.href "buy"
                        , css
                            [ Tw.border_none
                            , Tw.bg_white
                            , Tw.text_blue_600
                            , Tw.underline
                            , Tw.font_semibold
                            ]
                        ]
                        [ text "Buy Now" ]
                    , span [ css [ Tw.hidden, Bp.md [ Tw.inline_flex ] ] ]
                        [ text " — " ]
                    , span
                        [ css
                            [ Tw.hidden
                            , Bp.md [ Tw.inline_flex ]
                            , Tw.text_gray_700

                            -- , Tw.font_semibold
                            ]
                        ]
                        [ text "30 day money back guarantee!" ]
                    ]
                ]
            , div
                [ css
                    [ Tw.relative
                    , Tw.mt_0
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
                            , Tw.mt_0
                            ]
                        , Tw.mt_6
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
                    , div [] (renderAll model children)
                    ]
                , div
                    [ css
                        -- [ Tw.neg_mx_4
                        [ Tw.relative
                        , Bp.lg
                            [ Tw.mt_0
                            , Tw.order_1
                            , Tw.mt_10
                            , Tw.mb_6
                            ]
                        , Tw.mb_4
                        ]
                    , Attr.attribute "aria-hidden" "true"
                    ]
                    [ img
                        [ css
                            [ Tw.relative
                            , Tw.mx_auto
                            , Tw.object_scale_down
                            , Bp.md [ Tw.max_w_xs, Tw.w_auto ]
                            , Tw.w_3over4
                            ]
                        , Attr.src image
                        , Attr.alt ""
                        ]
                        []
                    ]
                ]
            ]
        ]


quoteBig : String -> String -> String -> Maybe String -> String -> Html.Html Msg
quoteBig quote name org logo headshot =
    div
        [ css
            [ Tw.relative
            , Tw.max_w_xl
            , Bp.md [ Tw.mx_0 ]
            , Tw.mx_4
            ]
        ]
        [ case logo of
            Just logoImage ->
                img
                    [ css
                        [ Tw.mx_auto
                        , Tw.h_8
                        ]
                    , Attr.src logoImage
                    , Attr.alt "Workcation"
                    ]
                    []

            Nothing ->
                div [ css [] ] []
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
                    , text quote
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
                            , Attr.src headshot
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
                            [ text name ]
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
                            [ text org ]
                        ]
                    ]
                ]
            ]
        ]


praise : String -> String -> String -> Maybe String -> String -> Html.Html Msg
praise quote name org logo headshot =
    {- This example requires Tailwind CSS v2.0+ -}
    div [ css [ Tw.w_screen, Tw.bg_gray_200 ] ]
        [ section
            [ css
                [ Tw.py_12
                , Tw.overflow_hidden
                , Tw.flex
                , Tw.items_center
                , Tw.justify_around

                -- , Tw.w_screen
                , Bp.lg
                    [ Tw.py_24
                    , Tw.px_8
                    ]
                , Bp.md
                    [ Tw.py_20
                    ]
                , Bp.sm
                    [ Tw.px_6
                    ]
                ]
            ]
            [ quoteBig quote name org logo headshot
            ]
        ]


emailAndBuy : String -> String -> String -> Model -> Html.Html Msg
emailAndBuy group id url model =
    div []
        [ form
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
                [ text "Ready to buy now?" ]
            , span [ css [ Tw.hidden, Bp.md [ Tw.inline_flex ] ] ]
                [ text " — " ]
            , span
                [ css
                    [ Tw.inline_flex
                    , Tw.text_gray_700
                    , Tw.font_semibold
                    ]
                ]
                [ text "30 day money back guarantee!" ]
            ]
        ]


sdk : Html.Html Msg
sdk =
    div
        [ css
            [ Tw.w_screen
            , Tw.min_h_screen
            , Tw.pb_24
            ]
        ]
        [ a [ Attr.id "kit" ] []
        , div
            [ css
                [ Tw.relative
                , Tw.pt_24
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
                [ text "2021 Fantasy Football Developer Kit" ]
            , p
                [ css
                    [ Bp.md [ Tw.text_2xl, Tw.max_w_3xl ]
                    , Tw.max_w_sm
                    , Tw.mt_4
                    , Tw.text_lg
                    , Tw.mx_auto
                    , Tw.text_center
                    , Tw.text_gray_500
                    ]
                ]
                [ text "A project based guide to help you "
                , span [ css [ Tw.underline ] ]
                    [ text "get better at Python "
                    , span [ css [ Tw.italic ] ] [ text "and" ]
                    , text " fantasy football."
                    ]
                , text " Analyze your team using state of the art tools that "
                , span [ css [ Tw.italic ] ] [ text "you" ]
                , text " build."
                ]
            , h3
                [ css
                    [ Bp.md
                        [ Tw.text_4xl
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
                    , Tw.mt_8
                    , Tw.mb_6
                    ]
                ]
                [ text "What We'll Make" ]
            ]
        , div
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
                [ img
                    [ css
                        [ Tw.object_scale_down
                        , Bp.md [ Tw.max_w_sm ]
                        , Tw.max_w_xs
                        ]
                    , Attr.src "images/team_zoom.jpg"
                    , Attr.alt "team"
                    ]
                    []
                , img
                    [ css
                        [ Tw.object_scale_down
                        , Bp.md [ Tw.max_w_sm ]
                        , Tw.max_w_xs
                        ]
                    , Attr.src "images/matchup_text.jpg"
                    , Attr.alt "results"
                    ]
                    []
                , img
                    [ css
                        [ Tw.object_scale_down
                        , Bp.md [ Tw.max_w_sm ]
                        , Tw.max_w_xs
                        ]
                    , Attr.src "images/pairplot.jpg"
                    , Attr.alt "results"
                    ]
                    []
                , img
                    [ css
                        [ Tw.object_scale_down
                        , Bp.md [ Tw.max_w_sm ]
                        , Tw.max_w_xs
                        ]
                    , Attr.src "images/rb_bb.jpg"
                    , Attr.alt "results"
                    ]
                    []
                ]
            ]
        , h3
            [ css
                [ Bp.md
                    [ Tw.text_4xl
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
                , Tw.mt_8
                ]
            ]
            [ text "2021 Projects" ]
        , h3
            [ css
                [ Bp.md
                    [ Tw.text_3xl
                    , Tw.tracking_tight
                    , Tw.max_w_3xl
                    ]
                , Tw.max_w_sm
                , Tw.text_2xl
                , Tw.text_center
                , Tw.mx_auto
                , Tw.leading_8
                , Tw.font_extrabold
                , Tw.text_gray_900
                , Tw.mt_8
                , Tw.mb_4
                , Tw.text_gray_700
                ]
            ]
            [ text "Automatic Team & League Import - NEW" ]
        , div
            [ css
                [ Tw.flex
                , Tw.flex_col
                , Tw.items_center
                , Tw.justify_center
                , Tw.space_y_3
                ]
            ]
            [ p
                [ css
                    [ Bp.md [ Tw.mx_0 ]
                    , Tw.mx_4
                    , Tw.my_0
                    , Tw.max_w_3xl
                    ]
                ]
                [ text "We'll write code to pull down player and matchup info from your ESPN, Yahoo, Fleaflicker or Sleeper leagues, learning more about real life APIs, authentication and more along the way."
                ]
            , p
                [ css
                    [ Bp.md [ Tw.mx_0 ]
                    , Tw.mx_4
                    , Tw.my_0
                    , Tw.max_w_3xl
                    ]
                ]
                [ text "After that, we'll connect this project to the league analyzer and who do I start calculator projects below for instant analysis."
                ]
            ]
        , h3
            [ css
                [ Bp.md
                    [ Tw.text_3xl
                    , Tw.tracking_tight
                    , Tw.max_w_3xl
                    ]
                , Tw.max_w_sm
                , Tw.text_2xl
                , Tw.text_center
                , Tw.mx_auto
                , Tw.leading_8
                , Tw.font_extrabold
                , Tw.text_gray_900
                , Tw.mt_8
                , Tw.mb_4
                , Tw.text_gray_700
                ]
            ]
            [ text "Who Do I Start Calculator" ]
        , div
            [ css
                [ Tw.flex
                , Tw.flex_col
                , Tw.items_center
                , Tw.justify_center
                , Tw.space_y_3
                ]
            ]
            [ p
                [ css
                    [ Bp.md [ Tw.mx_0 ]
                    , Tw.mx_4
                    , Tw.my_0
                    , Tw.max_w_3xl
                    ]
                ]
                [ text "We'll build a tool that takes in you and your opponents lineup, a list of guys you're thinking about starting and returns the probability of winning with each one."
                ]
            , p
                [ css
                    [ Bp.md [ Tw.mx_0 ]
                    , Tw.mx_4
                    , Tw.my_0
                    , Tw.max_w_3xl
                    ]
                ]
                [ text "Access to the 2021 API means you'll be able to use it to help your team this year. And the same, best-in-class simulations Fantasy Math uses means you'll be able to take into account variance and real life correlations among players to start the guy who maximizes your probability of winning."
                ]
            ]
        , h3
            [ css
                [ Bp.md
                    [ Tw.text_3xl
                    , Tw.tracking_tight
                    , Tw.max_w_3xl
                    ]
                , Tw.max_w_sm
                , Tw.text_2xl
                , Tw.text_center
                , Tw.mx_auto
                , Tw.leading_8
                , Tw.font_extrabold
                , Tw.text_gray_900
                , Tw.mt_8
                , Tw.mb_4
                , Tw.text_gray_700
                ]
            ]
            [ text "League Analyzer" ]
        , div
            [ css
                [ Tw.flex
                , Tw.flex_col
                , Tw.items_center
                , Tw.justify_center
                , Tw.space_y_3
                ]
            ]
            [ p
                [ css
                    [ Bp.md [ Tw.mx_0 ]
                    , Tw.mx_4
                    , Tw.my_0
                    , Tw.max_w_3xl
                    ]
                ]
                [ text "We'll build a league analysis tool to get get projections, betting lines, over-under and probability each team gets the high or low. Whether you share the results with your league or keep the intel to yourself is up to you."
                ]
            ]
        , h3
            [ css
                [ Bp.md
                    [ Tw.text_3xl
                    , Tw.tracking_tight
                    , Tw.max_w_3xl
                    , Tw.text_gray_700
                    ]
                , Tw.max_w_sm
                , Tw.text_2xl
                , Tw.text_center
                , Tw.mx_auto
                , Tw.leading_8
                , Tw.font_extrabold
                , Tw.text_gray_900
                , Tw.mt_8
                , Tw.mb_4
                ]
            ]
            [ text "Best Ball Projector" ]
        , div
            [ css
                [ Tw.flex
                , Tw.flex_col
                , Tw.items_center
                , Tw.justify_center
                , Tw.space_y_3
                ]
            ]
            [ p
                [ css
                    [ Bp.md [ Tw.mx_0 ]
                    , Tw.mx_4
                    , Tw.my_0
                    , Tw.max_w_3xl
                    ]
                ]
                [ text "Enter in different best ball lineups and get back projected scores, utilization percentages and more. Traditionally, projecting best ball lineups has been difficult/impossible to do with any real accuracy, but working with simulated point projections makes it easy. Plus we'll learn a lot in in the process."
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
                , Tw.mt_16
                , Tw.h_full
                ]
            ]
            [ a
                [ Attr.href "#buy"
                , css
                    [ Tw.w_full
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
                , onClick (OpenCheckout "buy")
                ]
                [ text "Buy 2021 developer kit!"
                ]
            ]
        ]


baseballTop : String -> List (Model -> Html.Html Msg) -> Model -> Html.Html Msg
baseballTop image children model =
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
                    [ text "Learn to Code with Baseball" ]
                , p
                    [ css
                        [ Bp.md [ Tw.text_2xl, Tw.max_w_3xl ]
                        , Tw.max_w_sm
                        , Tw.mt_4
                        , Tw.text_lg
                        , Tw.mx_auto
                        , Tw.text_center
                        , Tw.text_gray_500
                        ]
                    ]
                    [ text "Python. Pandas. Web Scraping. Databases. SQL. Machine Learning. APIs." ]
                , p
                    [ css
                        [ Bp.md [ Tw.text_2xl, Tw.mt_0, Tw.mb_0 ]
                        , Tw.mb_10
                        , Tw.text_lg
                        , Tw.max_w_2xl
                        , Tw.mx_auto
                        , Tw.text_center
                        , Tw.mt_2
                        , Tw.text_gray_500
                        ]
                    ]
                    [ text "All applied to Baseball Statistics" ]
                , p
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
                        , Tw.mt_10
                        , Tw.mb_4
                        , Tw.leading_8
                        , Tw.font_extrabold
                        , Tw.text_red_600
                        ]
                    ]
                    [ text "Cyber Monday Sale - 25% Off" ]
                , div
                    [ css
                        [ Tw.px_2
                        , Tw.flex
                        , Tw.items_center
                        , Tw.justify_center
                        , Tw.flex_wrap
                        , Tw.text_3xl
                        , Tw.mb_4
                        , Bp.md
                            [ Tw.space_x_1
                            , Tw.my_0
                            ]
                        ]
                    ]
                    [ a
                        [ Attr.href "buy"
                        , css
                            [ Tw.border_none
                            , Tw.bg_white
                            , Tw.text_blue_600
                            , Tw.underline
                            , Tw.font_semibold
                            ]
                        ]
                        [ text "Buy Now" ]
                    , span [ css [ Tw.hidden, Bp.md [ Tw.inline_flex ] ] ]
                        [ text " — " ]
                    , span
                        [ css
                            [ Tw.hidden
                            , Bp.md [ Tw.inline_flex ]
                            , Tw.text_gray_700

                            -- , Tw.font_semibold
                            ]
                        ]
                        [ text "30 day money back guarantee!" ]
                    ]
                ]
            , div
                [ css
                    [ Tw.relative
                    , Tw.mt_0
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
                            , Tw.mt_0
                            ]
                        , Tw.mt_6
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
                        [ text "Learn Python & Data Science Fundamentals with Baseball" ]
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
                    , div [] (renderAll model children)
                    ]
                , div
                    [ css
                        -- [ Tw.neg_mx_4
                        [ Tw.relative
                        , Bp.lg
                            [ Tw.mt_0
                            , Tw.order_1
                            , Tw.mt_10
                            , Tw.mb_6
                            ]
                        , Tw.mb_4
                        ]
                    , Attr.attribute "aria-hidden" "true"
                    ]
                    [ img
                        [ css
                            [ Tw.relative
                            , Tw.mx_auto
                            , Tw.object_scale_down
                            , Bp.md [ Tw.max_w_xs, Tw.w_auto ]
                            , Tw.w_3over4
                            ]
                        , Attr.src image
                        , Attr.alt ""
                        ]
                        []
                    ]
                ]
            ]
        ]
