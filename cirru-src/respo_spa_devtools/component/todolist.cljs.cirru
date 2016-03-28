
ns respo-spa-devtools.component.todolist $ :require
  [] hsl.core :refer $ [] hsl
  respo-spa-devtools.component.task :refer $ [] task-component

def style-todolist $ {} $ :font-family |Verdana

def style-nothing $ {} (:width |32px)
  :height |32px
  :background-color $ hsl 0 0 90
  :display |inline-block

def style-input $ {} (:line-height |32px)
  :font-size |16px
  :border |none
  :outline |none

def style-add $ {}
  :background-color $ hsl 200 80 80
  :color |white
  :padding "|0 16px"
  :line-height |32px
  :display |inline-block

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
        [] :div ({})
          [] :div $ {} $ :style style-nothing
          [] :input $ {}
            :value $ :draft state
            :on-input $ handle-change store state
            :placeholder "|new task"
            :style style-input
          [] :span $ {} (:inner-text |Add)
            :on-click $ handle-add store state
            :style style-add

        [] :div ({})
          ->> tasks
            map $ fn (task)
              [] (:id task)
                [] task-component task

            into $ sorted-map
