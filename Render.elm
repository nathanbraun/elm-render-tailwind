module Render exposing (styledRenderer)

-- import Html exposing (Html)

import Css
import Element exposing (Element)
import Element.Background
import Element.Border
import Element.Font as Font
import Element.Input
import Element.Region
import Form
import Html.Attributes
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr exposing (css)
import Markdown.Block as Block exposing (Block, Inline, ListItem(..), Task(..))
import Markdown.Html
import Markdown.Renderer
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw
import Types exposing (Model)


styledRenderer : List Block -> Result String (Model -> Html.Html msg)
styledRenderer blocks =
    blocks
        |> Markdown.Renderer.render engine
        |> Result.map
            (\blockViews model ->
                blockViews
                    |> renderAll model
                    |> div []
            )


engine : Markdown.Renderer.Renderer (Model -> Html.Html msg)
engine =
    { heading = heading
    , paragraph =
        \children model ->
            p [ css [ Tw.mx_3, Bp.md [ Tw.mx_0 ] ] ]
                (renderAll model children)
    , blockQuote =
        \children model ->
            p
                [ css
                    [ Bp.md
                        [ Tw.border
                        , Tw.border_solid
                        , Tw.border
                        , Tw.rounded
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
            [ Markdown.Html.tag "row"
                (\children model ->
                    div
                        [ css
                            [ Tw.flex
                            , Tw.flex_wrap
                            , Tw.place_content_evenly
                            , Tw.space_x_1
                            ]
                        ]
                        (renderAll model
                            children
                        )
                )
            , Markdown.Html.tag "image"
                (\src desc children model ->
                    img
                        [ css [ Tw.object_scale_down, Tw.max_w_xs ]
                        , Attr.src
                            src
                        , Attr.alt desc
                        ]
                        []
                )
                |> Markdown.Html.withAttribute "src"
                |> Markdown.Html.withAttribute "desc"
            , Markdown.Html.tag "test"
                (\_ model ->
                    text model.test
                )
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



-- elmUiRenderer : Markdown.Renderer.Renderer (Element msg)
-- elmUiRenderer =
--     { heading = heading2
--     , paragraph =
--         Element.paragraph
--             [ Element.spacing 8, Element.width Element.fill ]
--     , thematicBreak =
--         Element.row
--             [ Element.width Element.fill
--             , Element.Border.widthEach
--                 { top = 0
--                 , right = 0
--                 , bottom = 3
--                 , left = 0
--                 }
--             , Element.paddingXY 0 10
--             , Element.Border.color (Element.rgb255 145 145 145)
--             , Element.Background.color (Element.rgb255 245 245 245)
--             ]
--             [ Element.none ]
--     , text = Element.text
--     , strong = Element.row [ Font.bold ]
--     , emphasis = Element.row [ Font.italic ]
--     , codeSpan = code
--     , link =
--         \{ title, destination } body ->
--             Element.link
--                 [ Element.htmlAttribute
--                     (Html.Attributes.style "display"
--                         "inline-flex"
--                     )
--                 ]
--                 { url = destination
--                 , label =
--                     Element.paragraph
--                         [ Font.color (Element.rgb255 7 81 219)
--                         ]
--                         body
--                 }
--     , hardLineBreak = Html.br [] [] |> Element.html
--     , image =
--         \image ->
--             Element.image [ Element.width Element.fill ]
--                 { src =
--                     image.src
--                 , description = image.alt
--                 }
--     , blockQuote =
--         \children ->
--             Element.column
--                 [ Element.Border.widthEach
--                     { top = 0
--                     , right = 0
--                     , bottom = 0
--                     , left = 10
--                     }
--                 , Element.padding 10
--                 , Element.Border.color (Element.rgb255 145 145 145)
--                 , Element.Background.color (Element.rgb255 245 245 245)
--                 ]
--                 children
--     , unorderedList =
--         \items ->
--             Element.paragraph
--                 [ Element.spacing 8
--                 , Element.paddingXY 5 0
--                 , Element.width Element.fill
--                 ]
--                 (items
--                     |> List.map
--                         (\(ListItem task children) ->
--                             Element.row [ Element.spacing 8 ]
--                                 [ Element.row
--                                     [ Element.alignTop ]
--                                     ((case task of
--                                         IncompleteTask ->
--                                             Element.Input.defaultCheckbox False
--                                         CompletedTask ->
--                                             Element.Input.defaultCheckbox True
--                                         NoTask ->
--                                             Element.el
--                                                 [ Font.size 24
--                                                 , Element.paddingXY 10 0
--                                                 , Element.alignTop
--                                                 ]
--                                                 (Element.text "⁃")
--                                       -- (Element.text "•")
--                                       -- (Element.text "◦")
--                                      )
--                                         :: Element.text " "
--                                         :: [ Element.paragraph [ Element.spacing 8 ] children ]
--                                     )
--                                 ]
--                         )
--                 )
--     , orderedList =
--         \startingIndex items ->
--             Element.column [ Element.spacing 15 ]
--                 (items
--                     |> List.indexedMap
--                         (\index itemBlocks ->
--                             Element.paragraph
--                                 [ Element.spacing 8
--                                 ]
--                                 [ Element.paragraph [ Element.alignTop ]
--                                     (Element.text
--                                         (String.fromInt
--                                             (index
--                                                 + startingIndex
--                                             )
--                                             ++ ". "
--                                         )
--                                         :: itemBlocks
--                                     )
--                                 ]
--                         )
--                 )
--     , codeBlock = codeBlock
--     , html =
--         Markdown.Html.oneOf
--             [ Markdown.Html.tag "emphasize"
--                 (\name children ->
--                     Element.column [ Font.size 56 ] (Element.text name :: children)
--                 )
--                 |> Markdown.Html.withAttribute "name"
--             , Markdown.Html.tag "ul"
--                 (\children ->
--                     Element.row [ Font.underline ] children
--                 )
--             , Markdown.Html.tag "strike"
--                 (\children ->
--                     Element.row [ Font.strike ] children
--                 )
--             , Markdown.Html.tag "custom-image2"
--                 (\src1 alt1 src2 alt2 width children ->
--                     Element.wrappedRow
--                         [ Element.spacing 20
--                         , Element.centerX
--                         , Element.padding 25
--                         ]
--                         [ Element.image
--                             [ Element.width
--                                 (Element.px
--                                     (width
--                                         |> String.toInt
--                                         |> Maybe.withDefault 100
--                                     )
--                                 )
--                             , Element.centerX
--                             ]
--                             { src = src1
--                             , description = alt1
--                             }
--                         , Element.image
--                             [ Element.width
--                                 (Element.px
--                                     (width
--                                         |> String.toInt
--                                         |> Maybe.withDefault 100
--                                     )
--                                 )
--                             , Element.centerX
--                             ]
--                             { src = src2
--                             , description = alt2
--                             }
--                         ]
--                 )
--                 |> Markdown.Html.withAttribute "src1"
--                 |> Markdown.Html.withAttribute "alt1"
--                 |> Markdown.Html.withAttribute "src2"
--                 |> Markdown.Html.withAttribute "alt1"
--                 |> Markdown.Html.withAttribute "width"
--             , Markdown.Html.tag "custom-image"
--                 (\src alt width children ->
--                     Element.image
--                         [ Element.width
--                             (Element.px
--                                 (width
--                                     |> String.toInt
--                                     |> Maybe.withDefault 100
--                                 )
--                             )
--                         , Element.centerX
--                         , Element.padding 25
--                         ]
--                         { src = src
--                         , description = alt
--                         }
--                 )
--                 |> Markdown.Html.withAttribute "src"
--                 |> Markdown.Html.withAttribute "alt"
--                 |> Markdown.Html.withAttribute "width"
--             , Markdown.Html.tag "contact-form"
--                 (\children -> Form.view [] |> Element.html)
--             ]
--     , table = Element.column []
--     , tableHeader = Element.column []
--     , tableBody = Element.column []
--     , tableRow = Element.row []
--     , tableHeaderCell =
--         \maybeAlignment children ->
--             Element.paragraph [] children
--     , tableCell = Element.paragraph []
--     }


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
            , Tw.mx_3
            , Bp.md [ Tw.text_left, Tw.mx_0 ]
            ]
    in
    case level of
        Block.H1 ->
            h1
                [ css
                    ([ Tw.text_4xl
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
