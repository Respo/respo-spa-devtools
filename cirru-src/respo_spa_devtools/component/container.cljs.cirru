
ns respo-spa-devtools.component.container $ :require
  [] hsl.core :refer $ [] hsl
  [] respo-spa-devtools.component.todolist :refer $ [] todolist-component
  [] respo.alias :refer $ [] create-comp div span

def style-container

def container-component $ create-comp :container
  fn (store)
    fn (state mutate)
      div ({})
        todolist-component store
