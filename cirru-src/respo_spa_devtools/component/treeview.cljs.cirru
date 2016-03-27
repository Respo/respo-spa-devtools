
ns respo-spa-devtools.component.treeview $ :require
  [] hsl.core :refer $ [] hsl
  [] respo-spa-devtools.component.element :refer $ [] element-component

def style-treeview $ {} $ :display |flex

def style-entry $ {} $ :display |flex

def style-key $ {} (:min-width |160px)
  :font-family |Menlo
  :display |inline-block

def style-value $ {} $ :font-family |Menlo

defn style-rect (rect)
  {}
    :background-color $ hsl 200 90 40 0.4
    :position |fixed
    :top $ str (.-top rect)
      , |px
    :left $ str (.-left rect)
      , |px
    :width $ str (.-width rect)
      , |px
    :height $ str (.-height rect)
      , |px
    :transition-duration |200ms
    :z-index |999
    :pointer-events |none

def treeview-component $ {}
  :initial-state $ {} $ :pointer nil
  :render $ fn (props state)
    [] :div
      {} $ :style style-treeview
      [] element-component $ {}
        :element $ :element props
        :store $ :devtools-store props
      [] :div ({})
        ->>
          -> props :devtools-store :focus
          filter $ fn (entry)
            not= (key entry)
              , :children

          map $ fn (entry)
            [] (key entry)
              [] :div
                {} $ :style style-entry
                [] :div $ {} (:style style-key)
                  :inner-text $ name $ key entry
                [] :div $ {} (:style style-value)
                  :inner-text $ pr-str $ val entry

          into $ sorted-map

      let
          rect $ :rect $ :devtools-store props
        if (some? rect)
          [] :div $ {} $ :style $ style-rect rect
