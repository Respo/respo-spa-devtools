
ns respo-spa-devtools.component.player $ :require
  [] hsl.core :refer $ [] hsl

def player-component $ {} (:name :player)
  :update-state merge
  :get-state $ fn (props)
    {}
  :render $ fn (props)
    fn (state)
      [] :div ({})
        [] :span $ {}
          :inner-text $ pr-str
            :store $ :devtools-store props
