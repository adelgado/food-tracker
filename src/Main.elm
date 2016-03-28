module Main where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

-- Model

type alias ViewModel =
    { name: String
    , calories: String
    }

type alias ApplicationModel = List Food

type alias Model =
    { view: ViewModel
    , data: ApplicationModel
    }

type alias Food =
    { name: String
    , calories: String
    -- , date: Date
    }
food name calories =
    { name = name, calories = calories }


init : Model
init =
    { view =
        { name = ""
        , calories = ""
        }
    , data = []
    }


-- Update

type Action
    = NoOp
    | SetName String
    | SetCalories String
    | Submit


updateViewName : Model -> String -> Model
updateViewName model name' =
    let
        view = model.view
        newView = { view | name = name' }
    in
        { model | view = newView }

updateViewCalories : Model -> String -> Model
updateViewCalories model calories' =
    let
        view = model.view
        newView = { view | calories = calories' }
    in
        { model | view = newView }

updateData : Model -> Model
updateData model =
    { view = init.view
    , data = (food model.view.name model.view.calories) :: model.data
    }

update : Action -> Model -> Model
update action model =
    case action of
        NoOp ->
            model

        SetName name' ->
            updateViewName model name'

        SetCalories calories' ->
            updateViewCalories model calories'

        Submit ->
            updateData model


-- Signals

main : Signal Html
main =
    Signal.map view model

model : Signal Model
model = Signal.foldp update init actions.signal

actions : Signal.Mailbox Action
actions =
    Signal.mailbox NoOp


-- View

renderAddFood : ViewModel -> Html
renderAddFood viewModel =
    div [ class "add-food" ]
        [ input
            [ class "add-food__name"
            , value viewModel.name
            , on "input" targetValue
                (Signal.message actions.address << SetName)
            ]
            []
        , input
            [ class "add-food__calories"
            , value viewModel.calories
            , on "input" targetValue
                (Signal.message actions.address << SetCalories)
            ]
            []
        , button
            [ class "add-food__submit"
            , onClick actions.address <| Submit
            ]
            [ text "Submit" ]
        ]

renderFoodListItem : Food -> Html
renderFoodListItem item =
    li [] [ text <| item.name ++ " (" ++ item.calories ++ ")" ]

renderFoodList : List Food -> Html
renderFoodList list =
    ul [] <| List.map renderFoodListItem list

view : Model -> Html
view model =
    div [ class "application" ]
        [ renderAddFood model.view
        , renderFoodList model.data
        ]
