
ns respo-spa-devtools.component.element $ :require $ [] hsl.core :refer $ [] hsl

def style-element $ {} (:display |flex)
  :border $ str "|1px solid " $ hsl 0 0 90
  :align-items |flex-start
  :margin |8px

def style-info $ {} (:display |flex)
  :flex-direction |column

def style-component $ {}
  :background-color $ hsl 240 50 50
  :color $ hsl 0 0 100
  :padding "|0 8px"
  :font-family |Menlo

def style-name $ {} (:font-family |Menlo)
  :display |inline-block
  :background-color $ hsl 140 80 70
  :color $ hsl 0 0 100
  :padding "|0 8px"
  :height |auto
  :cursor |pointer

def style-space $ {} $ :width |24px

def style-children $ {}

def element-component $ {} (:initial-state $ {})
  :render $ fn (element state)
    [] :div
      {} $ :style style-element
      [] :div
        {} $ :style style-info
        if
          some? $ :component-name element
          [] :span $ {} (:style style-component)
            :inner-text $ name $ :component-name element

        [] :span $ {} (:style style-name)
          :inner-text $ name $ :name element

      [] :div $ {} $ :style style-space
      [] :div
        {} $ :style style-children
        ->> (:children element)
          map $ fn (entry)
            [] (key entry)
              [] element-component $ val entry

          into $ sorted-map
