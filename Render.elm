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
import Html.Styled.Events exposing (onInput, onSubmit)
import List.Extra as Extra
import Markdown.Block as Block exposing (Block, Inline, ListItem(..), Task(..))
import Markdown.Html
import Markdown.Renderer
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
                        [ Tw.mx_3
                        , Tw.my_0
                        , Bp.md [ Tw.mx_0 ]
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
                            div []
                                (renderAll model
                                    children
                                )

                        ( "B", Just B ) ->
                            div []
                                (renderAll model
                                    children
                                )

                        _ ->
                            div [] []
                )
                |> Markdown.Html.withAttribute "id"
                |> Markdown.Html.withAttribute "version"
                |> Markdown.Html.withAttribute "name"
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
                        [ button
                            [ css
                                [ Tw.border_none
                                , Tw.bg_white
                                , Tw.text_lg
                                , Tw.p_0
                                ]
                            , onSubmit (ShowGumroad "buy")
                            ]
                            [ a [ Attr.href url ] [ text label ] ]
                        , span [ css [ Tw.hidden, Bp.md [ Tw.inline_flex ] ] ]
                            [ text " — " ]
                        , span [ css [ Tw.inline_flex ] ] [ text "30 day money back guarantee!" ]
                        ]
                )
                |> Markdown.Html.withAttribute "url"
                |> Markdown.Html.withAttribute "label"
            , Markdown.Html.tag "button"
                (\url label children model ->
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
                                , Bp.md [ Tw.mt_0 ]
                                , Tw.px_5
                                , Tw.py_3
                                , Tw.text_base
                                , Tw.font_medium
                                , Tw.rounded_md
                                , Tw.text_white
                                , Tw.bg_blue_500
                                , Tw.w_64
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
                            , onSubmit (ShowGumroad "buy")
                            ]
                            [ a
                                [ Attr.href url
                                , css
                                    [ Tw.no_underline
                                    , Tw.text_base
                                    , Tw.font_medium
                                    , Tw.rounded_md
                                    , Tw.text_white
                                    ]
                                ]
                                [ text label
                                ]
                            ]
                        ]
                )
                |> Markdown.Html.withAttribute "url"
                |> Markdown.Html.withAttribute "label"
            , Markdown.Html.tag "quote"
                (\name span2 link children model ->
                    div
                        [ css
                            [ Bp.md
                                [ Tw.px_8
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
                            ]
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
                                     -- , Tw.mb_4
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
                                     , Tw.p_0
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
                            [ Tw.grid
                            , Bp.md
                                [ Tw.grid_cols_4
                                , Tw.gap_4
                                , Tw.mt_8
                                ]
                            , Tw.gap_y_4
                            , Tw.my_8
                            , Tw.px_4
                            , Tw.grid_cols_1
                            ]
                        ]
                        (renderAll model children)
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
                                    , Tw.mt_0
                                    ]
                                , Tw.mt_8
                                , Tw.px_4
                                , Tw.grid_cols_1
                                , Tw.gap_y_4
                                , Tw.items_center
                                ]
                            ]
                            [ imageTw "images/pitch_speed_by_type.jpg" "scoring"
                            , imageTw "images/pitch_spin_vs_speed.jpg" "scoring"
                            , imageTw "images/n_per_inning.jpg" "scoring"
                            , imageTw "images/runs_by_home_away.jpg" "scoring"
                            ]
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
                            , Tw.w_3over4
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
                                    li [] (checkbox :: renderAll model children)
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
            ]
    in
    case level of
        Block.H1 ->
            h1
                [ css
                    ([ Bp.md [ Tw.text_4xl ]
                     , Tw.text_3xl
                     , Tw.mt_4
                     , Tw.mb_4
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



-- image : String -> String ->


imageTw : String -> String -> Html msg
imageTw src desc =
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
