
ns respo-spa-devtools.component.treeview $ :require
  [] hsl.core :refer $ [] hsl
  [] respo-spa-devtools.component.element :refer $ [] element-component
  [] respo.controller.resolver :refer $ [] get-element-at
  [] respo-value.component.value :refer $ [] render-value

def style-treeview $ {} (:display |flex)

def style-entry $ {} (:display |flex)
  :min-height |20px

def style-key $ {} (:min-width |160px)
  :font-family |Menlo
  :display |inline-block

def style-value $ {} (:font-family |Menlo)

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

def treeview-component $ {} (:name :treeview)
  :update-state merge
  :get-state $ fn (props)
    {} $ :pointer nil
  :render $ fn (props)
    fn (state)
      let
        (element $ :element props)
          devtools-store $ :devtools-store props
          focused-coord $ :focus (:state devtools-store)

        [] :div
          {} $ :style style-treeview
          [] element-component $ {} (:element element)
            :mount-point $ :mount-point props
            :focused focused-coord
          [] :div ({})
            if (some? focused-coord)
              let
                (target-element $ get-element-at (:element props) (, focused-coord))

                ->> target-element
                  filter $ fn (entry)
                    not= (key entry)
                      , :children

                  map $ fn (entry)
                    [] (key entry)
                      [] :div
                        {} $ :style style-entry
                        [] :div
                          {} $ :style style-key
                          render-value $ key entry
                        [] :div
                          {} $ :style style-value
                          render-value $ val entry

                  into $ sorted-map

          let
            (rect $ :rect (:state $ :devtools-store props))

            if (some? rect)
              [] :div $ {}
                :style $ style-rect rect
