
ns respo-spa-devtools.component.task $ :require $ [] hsl.core :refer $ [] hsl

def style-task $ {} $ :display |flex

defn style-toggle (done?)
  {} (:width |32px)
    :height |32px
    :background-color $ if done?
      hsl 0 0 80
      hsl 0 80 60
    :cursor |pointer

def style-input $ {} (:outline |none)
  :line-height |32px
  :padding "|0 8px"
  :border |none
  :font-size |16px
  :font-family |Verdana

def style-remove $ {} (:width |32px)
  :height |32px
  :background-color $ hsl 0 80 80
  :style |pointer

defn handle-toggle (task state)
  fn (simple-event intent set-state)
    intent :toggle $ :id task

defn handle-change (task state)
  fn (simple-event intent set-state)
    intent :update $ {}
      :id $ :id task
      :text $ :value simple-event

defn handle-remove (task state)
  fn (simple-event intent set-state)
    intent :rm $ :id task

def task-component $ {}
  :initial-state $ {} $ :draft |
  :name :task
  :render $ fn (task state)
    [] :div
      {} $ :style style-task
      [] :div $ {}
        :on-click $ handle-toggle task state
        :style $ style-toggle $ :done? task
      [] :input $ {}
        :on-change $ handle-change task state
        :value $ :text task
        :style style-input
      [] :div $ {}
        :on-click $ handle-remove task state
        :style style-remove
