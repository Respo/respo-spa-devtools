
ns respo-spa-devtools.component.todolist $ :require
  [] hsl.core :refer $ [] hsl
  respo-spa-devtools.component.task :refer $ [] task-component

def style-todolist $ {} $ :font-family |Verdana

defn handle-change (props state)
  fn (simple-event intent set-state)
    set-state $ {} $ :draft $ :value simple-event

defn handle-add (store state)
  fn (simple-event intent set-state)
    intent :add $ :draft state
    set-state $ {} $ :draft |

def todolist-component $ {}
  :initial-state $ {} $ :draft |
  :name :todolist
  :render $ fn (store state)
    let
      (tasks store)
      [] :div ({} :style style-todolist)
        [] :span $ {} :inner-text |Todolist
        [] :div ({})
          [] :input $ {}
            :value $ :draft state
            :on-input $ handle-change store state
          [] :span $ {} (:inner-text |Add)
            :on-click $ handle-add store state

        [] :div ({})
          ->> tasks
            map $ fn (task)
              [] (:id task)
                [] task-component task

            into $ sorted-map
