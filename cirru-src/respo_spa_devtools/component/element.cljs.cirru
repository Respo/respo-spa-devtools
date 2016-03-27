
ns respo-spa-devtools.component.element $ :require $ [] hsl.core :refer $ [] hsl

defn style-element (focused?)
  {} (:display |flex)
    :align-items |flex-start
    :box-shadow $ str "|0 -1px 0 " $ hsl 0 0 80
    :background-color $ if focused?
      hsl 200 80 40 0.5
      , |transparent
    :transition-duration |200ms

def style-info $ {} (:display |flex)
  :flex-direction |column

def style-component $ {}
  :background-color $ hsl 240 50 50 0.5
  :color $ hsl 0 0 100
  :padding "|0 8px"
  :font-family |Menlo

def style-name $ {} (:font-family |Menlo)
  :display |inline-block
  :background-color $ hsl 140 80 70 0.5
  :color $ hsl 0 0 100
  :padding "|0 8px"
  :height |auto
  :cursor |pointer

def style-space $ {} $ :width |24px

def style-children $ {}

defn handle-click (props state)
  fn (simple-event intent set-state)
    let
        element $ :element props
        store $ :store props
        mount-point $ :mount-point store
        coord $ :coord element
        selector $ str "|[data-coord=\"" (pr-str coord)
          , "|\"]"
        target $ -> js/document (.querySelector mount-point)
          .querySelector selector
        rect $ .getBoundingClientRect target

      .log js/console selector $ js->clj rect
      intent $ {} (:focus element)
        :rect rect

def element-component $ {} (:initial-state $ {})
  :render $ fn (props state)
    let
        element $ :element props
        store $ :store props
      [] :div
        {} $ :style $ style-element $ = (:coord element)
          :coord $ :focus store
        [] :div
          {} $ :style style-info
          if
            some? $ :component-name element
            [] :span $ {} (:style style-component)
              :inner-text $ name $ :component-name element

          [] :span $ {} (:style style-name)
            :inner-text $ name $ :name element
            :on-click $ handle-click props state

        [] :div $ {} $ :style style-space
        [] :div
          {} $ :style style-children
          ->> (:children element)
            map $ fn (entry)
              [] (key entry)
                [] element-component $ {}
                  :element $ val entry
                  :store store

            into $ sorted-map
