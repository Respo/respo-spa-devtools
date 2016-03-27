
ns respo-spa-devtools.component.container $ :require
  [] hsl.core :refer $ [] hsl
  [] respo-spa-devtools.component.todolist :refer $ [] todolist-component

def style-container

def container-component $ {} (:name :container)
  :initial-state $ {}
  :render $ fn (store state)
    [] :div ({})
      [] todolist-component store
