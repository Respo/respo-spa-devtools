
ns respo-spa-devtools.component.player $ :require $ [] hsl.core :refer $ [] hsl

def player-component $ {} (:initial-state $ {})
  :render $ fn (props state)
    [] :div ({})
      [] :span $ {} $ :inner-text $ pr-str $ :store props
