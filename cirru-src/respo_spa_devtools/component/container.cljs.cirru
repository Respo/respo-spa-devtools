
ns respo-spa-devtools.component.container $ :require
  [] hsl.core :refer $ [] hsl
  [] respo-spa-devtools.component.todolist :refer $ [] todolist-component

def style-container

def container-component $ {} (:name :container)
  :update-state merge
  :get-state $ fn (store)
    {}
  :render $ fn (store)
    fn (state)
      [] :div ({})
        [] todolist-component store
