module Buy exposing (baseball, baseballGift, football, footballGift)

import AB exposing (Version(..))
import Css
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr exposing (css)
import Svg.Styled as Svg exposing (path, svg)
import Svg.Styled.Attributes as SvgAttr
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw
import Types exposing (Msg(..))


type alias Product =
    { link : String
    , gift : String
    }


ltcwff : Product
ltcwff =
    Product
        "https://transactions.sendowl.com/packages/801053/D380E68E/purchase"
        "https://transactions.sendowl.com/packages/801676/F59AC077/purchase"


ltcwbb : Product
ltcwbb =
    Product
        "https://transactions.sendowl.com/packages/801126/807C451F/purchase"
        "https://transactions.sendowl.com/packages/801668/97270C6D/purchase"


bundle : Product
bundle =
    Product
        "https://transactions.sendowl.com/packages/825607/ECA74787/purchase"
        "https://transactions.sendowl.com/packages/825608/E62168F5/purchase"


football : Html.Html Msg
football =
    footballSale "Get Learn to Code with Fantasy Football"
        "Buy with the 2022 Fantasy Football Developer Kit and save."
        False


footballGift : Html.Html Msg
footballGift =
    footballSale "Gift Learn to Code with Fantasy Football"
        "The perfect present for the aspiring programmer and fantasy football fan in your life!"
        True


baseball : Html.Html Msg
baseball =
    baseballSale "Get Learn to Code with Baseball" False


baseballGift : Html.Html Msg
baseballGift =
    baseballSale "Gift Learn to Code with Baseball" True


footballSale : String -> String -> Bool -> Html.Html Msg
footballSale headline subHeader gift =
    div
        [ css
            [ Tw.bg_blue_900
            , Tw.w_screen
            , Tw.min_h_screen
            ]
        ]
        [ a [ Attr.id "buy" ] []
        , div
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
                    [ p
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
                        [ text headline ]
                    , p
                        [ css
                            [ Tw.text_xl
                            , Tw.text_gray_300
                            ]
                        ]
                        [ text subHeader ]
                    , if gift then
                        div
                            [ css
                                [ Tw.text_2xl

                                -- , Tw.font_extrabold
                                , Tw.flex
                                , Tw.flex_col
                                , Tw.flex
                                , Tw.items_center
                                , Tw.justify_center
                                , Tw.max_w_2xl
                                , Tw.mx_auto
                                , Tw.text_gray_200
                                , Tw.pt_6
                                ]
                            ]
                            [ text "Click the blue present icon on checkout after clicking Buy Now and you'll be able to enter reciept + e-delivery details."
                            , img
                                [ css
                                    [ Tw.object_scale_down
                                    , Tw.max_w_xs
                                    , Tw.mx_auto
                                    , Tw.p_6
                                    ]
                                , Attr.src
                                    "images/gift.jpg"
                                , Attr.alt ""
                                ]
                                []
                            ]

                      else
                        p
                            [ css
                                [ Tw.text_xl
                                , Tw.text_gray_100
                                , Tw.mt_10
                                ]
                            ]
                            [ text "Looking to give LTCWFF as a gift? - "
                            , a
                                [ Attr.href "gift"
                                , css
                                    [ Tw.text_blue_100
                                    , Tw.underline
                                    , Tw.font_semibold
                                    ]
                                ]
                                [ text "click here!" ]
                            ]
                    ]
                ]
            ]
        , div
            [ css
                [ Tw.mt_8
                , Tw.pb_12

                -- , Tw.bg_gray_50
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
                                    [ span
                                        [ css
                                            [ Tw.mr_3
                                            , Tw.my_auto
                                            , Tw.font_semibold

                                            -- , Tw.text_gray_400
                                            ]
                                        ]
                                        [ text "$59" ]
                                    , span
                                        [ css
                                            [ Tw.ml_3
                                            , Tw.font_semibold
                                            , Tw.text_gray_600
                                            , Tw.text_xl
                                            , Tw.my_auto
                                            ]
                                        ]
                                        [ text "USD" ]
                                    ]
                                , p
                                    [ css
                                        [ Tw.mt_5
                                        , Tw.text_lg
                                        , Tw.text_gray_500
                                        ]
                                    ]
                                    [ text "Includes book, datasets, example scripts, end of chapter problems with full solutions, and flashcards." ]
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
                                            [ text "The 270 page book in PDF format + files" ]
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
                                    ]
                                , div
                                    [ css
                                        []
                                    ]
                                    [ a
                                        [ Attr.href
                                            (if gift then
                                                ltcwff.gift

                                             else
                                                ltcwff.link
                                            )
                                        , css
                                            [ Tw.flex
                                            , Tw.items_center
                                            , Tw.justify_center
                                            , Tw.px_5
                                            , Tw.py_3
                                            , Tw.border
                                            , Tw.rounded_md
                                            , Tw.shadow
                                            , Tw.border_transparent
                                            , Tw.text_base
                                            , Tw.font_semibold
                                            , Tw.text_gray_900
                                            , Tw.bg_gray_300
                                            , Tw.self_end
                                            , Css.hover
                                                [ Tw.bg_gray_500
                                                ]
                                            ]
                                        , Attr.attribute "aria-describedby" "tier-standard"
                                        ]
                                        [ text "Buy Now" ]
                                    , p
                                        [ css
                                            [ Tw.text_center
                                            , Tw.mt_4

                                            -- , Tw.text_gray_600
                                            , Tw.font_semibold
                                            , Tw.text_blue_900
                                            ]
                                        ]
                                        [ text "30 day money back "
                                        , span [ css [] ] [ text "guarantee!" ]
                                        ]
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
                                        [ text "Book + 2022 Developer Kit" ]
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
                                    [ span
                                        [ css
                                            [ Tw.line_through
                                            , Tw.mr_3
                                            , Tw.text_2xl
                                            , Tw.my_auto
                                            , Tw.font_semibold
                                            , Tw.text_gray_400
                                            ]
                                        ]
                                        [ text "$169" ]
                                    , span
                                        [ css
                                            [ Tw.mr_3
                                            , Tw.my_auto
                                            , Tw.font_semibold

                                            -- , Tw.text_gray_400
                                            ]
                                        ]
                                        [ text "$99" ]
                                    , span
                                        [ css
                                            [ Tw.ml_3
                                            , Tw.font_semibold
                                            , Tw.text_gray_600
                                            , Tw.text_xl
                                            , Tw.my_auto
                                            ]
                                        ]
                                        [ text "USD" ]
                                    ]
                                , p
                                    [ css
                                        [ Tw.mt_5
                                        , Tw.text_lg
                                        , Tw.text_gray_500
                                        ]
                                    ]
                                    [ text "The book, files and flashcards, plus the "
                                    , a
                                        [ Attr.href "#kit"
                                        , css
                                            [ Tw.text_blue_600
                                            , Tw.underline
                                            , Tw.font_semibold
                                            ]
                                        ]
                                        [ text "2022 developer kit" ]
                                    , text ". Includes API and Fantasy Math web access for the 2022 season."
                                    ]
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
                                            [ text "The 270 page book in PDF format + files" ]
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
                                            [ text "Five step-by-step project guides + final code (250+ pages)" ]
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
                                            [ text "2022 Fantasy Math Simulation API Access" ]
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
                                            [ text "2022 Fantasy Math Web Access" ]
                                        ]
                                    ]
                                , div
                                    [ css
                                        []
                                    ]
                                    [ a
                                        [ Attr.href
                                            (if gift then
                                                bundle.gift

                                             else
                                                bundle.link
                                            )
                                        , css
                                            [ Tw.flex
                                            , Tw.items_center
                                            , Tw.justify_center
                                            , Tw.px_5
                                            , Tw.py_3
                                            , Tw.border
                                            , Tw.border_transparent
                                            , Tw.text_base
                                            , Tw.font_semibold
                                            , Tw.rounded_md
                                            , Tw.shadow
                                            , Tw.text_white
                                            , Tw.bg_gray_800
                                            , Css.hover
                                                [ Tw.bg_gray_900
                                                ]
                                            ]
                                        , Attr.attribute "aria-describedby" "tier-standard"
                                        ]
                                        [ text "Buy Now" ]
                                    , p
                                        [ css
                                            [ Tw.text_center
                                            , Tw.mt_4

                                            -- , Tw.text_gray_600
                                            , Tw.font_semibold
                                            , Tw.text_blue_900
                                            ]
                                        ]
                                        [ text "30 day money back "
                                        , span [ css [] ] [ text "guarantee!" ]
                                        ]
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
                                        , Tw.bg_indigo_100
                                        , Tw.text_indigo_600
                                        ]
                                    , Attr.id "tier-standard"
                                    ]
                                    [ text "2022 Developer Kit Only" ]
                                ]
                            , div
                                [ css
                                    [ Tw.mt_4
                                    , Tw.text_lg
                                    , Tw.text_gray_600
                                    ]
                                ]
                                [ text "Already own Learn to Code with Fantasy Football and just need the developer kit + API access for 2022? Get it now for "
                                , span
                                    [ css
                                        [ Tw.font_semibold
                                        , Tw.text_gray_900
                                        ]
                                    ]
                                    [ text "$69" ]
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
                                [ Attr.href "https://transactions.sendowl.com/products/78652896/D9584EF4/purchase"
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
                                [ text "Buy 2022 Developer Kit" ]
                            ]
                        ]
                    ]
                ]
            ]
        , div
            [ css
                [ Tw.max_w_7xl
                , Tw.mx_auto
                , Tw.text_center
                , Tw.px_4
                , Tw.pb_10
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
                [ p
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
                    [ text "30 Day Money Back Guarantee" ]
                , p
                    [ css
                        [ Tw.text_xl
                        , Tw.text_gray_300
                        ]
                    ]
                    [ text "Try it! If you're not satisified, contact me within 30 days and I'll refund you the purchase price." ]
                ]
            ]
        ]


baseballSale : String -> Bool -> Html.Html Msg
baseballSale headline gift =
    div
        [ css
            [ Tw.bg_blue_900
            , Tw.w_screen
            , Tw.min_h_screen
            ]
        ]
        [ a [ Attr.id "buy" ] []
        , div
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
                    [ p
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
                        [ text headline ]
                    , if gift then
                        div
                            [ css
                                [ Tw.text_2xl

                                -- , Tw.font_extrabold
                                , Tw.flex
                                , Tw.flex_col
                                , Tw.flex
                                , Tw.items_center
                                , Tw.justify_center
                                , Tw.max_w_2xl
                                , Tw.mx_auto
                                , Tw.text_gray_200
                                , Tw.pt_6
                                ]
                            ]
                            [ text "Click the blue present icon on checkout after clicking Buy Now and you'll be able to enter reciept + e-delivery details."
                            , img
                                [ css
                                    [ Tw.object_scale_down
                                    , Tw.max_w_xs
                                    , Tw.mx_auto
                                    , Tw.p_6
                                    ]
                                , Attr.src
                                    "images/gift.jpg"
                                , Attr.alt ""
                                ]
                                []
                            ]

                      else
                        p
                            [ css
                                [ Tw.text_xl
                                , Tw.text_gray_100
                                , Tw.mt_10
                                ]
                            ]
                            [ text "Looking to give LTCWBB as a gift? - "
                            , a
                                [ Attr.href "gift"
                                , css
                                    [ Tw.text_blue_100
                                    , Tw.underline
                                    , Tw.font_semibold
                                    ]
                                ]
                                [ text "click here!" ]
                            ]
                    ]
                ]
            ]
        , div
            [ css
                [ Tw.mt_8
                , Tw.pb_12
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
                                [ Tw.max_w_md
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
                                [ div
                                    [ css
                                        [ Tw.mt_4
                                        , Tw.flex
                                        , Tw.items_baseline
                                        , Tw.text_6xl
                                        , Tw.font_extrabold
                                        ]
                                    ]
                                    [ span
                                        [ css
                                            [ Tw.mr_3
                                            , Tw.my_auto
                                            , Tw.font_semibold

                                            -- , Tw.text_gray_400
                                            ]
                                        ]
                                        [ text "$59" ]
                                    , span
                                        [ css
                                            [ Tw.ml_3
                                            , Tw.font_semibold
                                            , Tw.text_gray_600
                                            , Tw.text_xl
                                            , Tw.my_auto
                                            ]
                                        ]
                                        [ text "USD" ]
                                    ]
                                , p
                                    [ css
                                        [ Tw.mt_5
                                        , Tw.text_lg
                                        , Tw.text_gray_500
                                        ]
                                    ]
                                    [ text "Includes book, datasets, example scripts, end of chapter problems with full solutions, and flashcards." ]
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
                                            [ text "300+ spaced repetition flash cards" ]
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
                                            [ text "23 example scripts, 10 datasets" ]
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
                                            [ text "100+ practice problems with full solutions" ]
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
                                            [ text "lifetime updates" ]
                                        ]
                                    ]
                                , div
                                    [ css
                                        []
                                    ]
                                    [ a
                                        [ Attr.href
                                            (if gift then
                                                ltcwbb.link

                                             else
                                                ltcwbb.gift
                                            )
                                        , css
                                            [ Tw.flex
                                            , Tw.items_center
                                            , Tw.justify_center
                                            , Tw.px_5
                                            , Tw.py_3
                                            , Tw.border
                                            , Tw.rounded_md
                                            , Tw.shadow
                                            , Tw.border_transparent
                                            , Tw.text_base
                                            , Tw.font_semibold
                                            , Tw.self_end
                                            , Tw.text_white
                                            , Tw.bg_gray_800
                                            , Css.hover
                                                [ Tw.bg_gray_900
                                                ]
                                            ]
                                        , Attr.attribute "aria-describedby" "tier-standard"
                                        ]
                                        [ text "Buy Now" ]
                                    , p
                                        [ css
                                            [ Tw.text_center
                                            , Tw.mt_4
                                            , Tw.font_semibold
                                            , Tw.text_blue_900
                                            ]
                                        ]
                                        [ text "30 day money back "
                                        , span [ css [] ] [ text "guarantee!" ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        , div
            [ css
                [ Tw.max_w_7xl
                , Tw.mx_auto
                , Tw.text_center
                , Tw.px_4
                , Tw.pb_10
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
                [ p
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
                    [ text "30 Day Money Back Guarantee" ]
                , p
                    [ css
                        [ Tw.text_xl
                        , Tw.text_gray_300
                        ]
                    ]
                    [ text "Try it! If you're not satisified, contact me within 30 days and I'll refund you the purchase price." ]
                ]
            ]
        ]
