
ns respo-spa-devtools.component.devtools $ :require
  [] hsl.core :refer $ hsl
  [] respo-spa-devtools.component.player :refer $ [] player-component
  [] respo-spa-devtools.component.treeview :refer $ [] treeview-component

def style-devtools $ {} $ :background-color $ hsl 200 80 95

def style-header $ {}

defn style-tab (selected?)
  {} (:display |inline-block)
    :padding "|0 16px"
    :margin |8px
    :color $ hsl 0 0 100
    :background-color $ if selected?
      hsl 200 80 60
      hsl 200 80 70
    :line-height |32px
    :cursor |pointer

def style-content $ {} $ :background-color $ hsl 80 80 90

defn select-tab (target)
  fn (simple-event intent set-state)
    set-state $ {} $ :tab target

def devtools-component $ {}
  :initial-state $ {} $ :tab :elements
  :render $ fn (props state)
    [] :div
      {} $ :style style-devtools
      [] :div
        {} $ :style style-header
        [] :span $ {}
          :style $ style-tab $ = (:tab state)
            , :elements
          :inner-text |Elements
          :on-click $ select-tab :elements

        [] :span $ {}
          :style $ style-tab $ = (:tab state)
            , :store
          :inner-text |Store
          :on-click $ select-tab :store

      [] :section
        {} $ :style style-content
        case (:tab state)
          :elements $ [] treeview-component props
          :store $ [] player-component props
          [] :span $ {} $ :inner-text "|Nothing Selected"
