
ns respo-spa-devtools.component.devtools $ :require
  [] hsl.core :refer $ hsl
  [] respo-spa-devtools.component.player :refer $ [] player-component
  [] respo-spa-devtools.component.treeview :refer $ [] treeview-component

defn style-devtools (style)
  merge
    {} (:position |absolute)
      :top |0
      :left |0
      :width |100%
      :height |100%
      :background-color $ hsl 200 0 100
      :font-size |12px
      :transition-duration |200ms
      :box-shadow $ str "|0 0 1px "
        hsl 0 0 30 0.5

    , style

def style-header $ {} (:margin-bottom |12px)

defn style-tab (selected?)
  {} (:display |inline-block)
    :padding "|0 8px"
    :margin-right |8px
    :color $ hsl 0 0 100
    :background-color $ if selected?
      hsl 200 80 60
      hsl 200 80 70
    :line-height |24px
    :cursor |pointer
    :font-family "|Source code pro, Menlo, monospace"

def style-content $ {}
  :background-color $ hsl 80 80 100

defn select-tab (target)
  fn (simple-event dispatch mutate)
    mutate $ {} (:tab target)

def devtools-component $ {} (:name :devtools)
  :update-state merge
  :get-state $ fn (props)
    {} $ :tab :elements
  :render $ fn (props)
    fn (state)
      if (:visible? props)
        [] :div
          {} $ :style
            style-devtools $ :style props
          [] :div
            {} $ :style style-header
            [] :span $ {}
              :style $ style-tab
                = (:tab state)
                  , :elements

              :inner-text |Elements
              :on-click $ select-tab :elements

            [] :span $ {}
              :style $ style-tab
                = (:tab state)
                  , :store

              :inner-text |Store
              :on-click $ select-tab :store

          [] :section
            {} $ :style style-content
            case (:tab state)
              :elements $ [] treeview-component props
              :store $ [] player-component (:devtools-store props)
              [] :span $ {} (:inner-text "|Nothing Selected")

        [] :noscript $ {}
