
ns respo-spa-devtools.component.task $ :require
  [] hsl.core :refer $ [] hsl
  [] respo.alias :refer $ [] create-comp div input

def style-task $ {} (:display |flex)
  :width |100%
  :padding |4px
  :background-color $ hsl 0 0 100
  :margin-bottom |4px

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
  :flex |1

def style-remove $ {} (:width |32px)
  :height |32px
  :background-color $ hsl 0 80 80
  :cursor |pointer

defn handle-toggle (task state)
  fn (simple-event dispatch)
    dispatch :toggle $ :id task

defn handle-change (task state)
  fn (simple-event dispatch)
    dispatch :update $ {}
      :id $ :id task
      :text $ :value simple-event

defn handle-remove (task state)
  fn (simple-event dispatch mutate)
    dispatch :rm $ :id task

def task-component $ create-comp :task
  fn (task)
    {} $ :draft |
  , merge
  fn (task)
    fn (state mutate)
      div
        {} $ :style style-task
        div $ {}
          :event $ {} :click (handle-toggle task state)
          :style $ style-toggle (:done? task)

        input $ {} :style style-input :event
          :change $ handle-change task state
          , :attrs
          {} :value (:text task)
            , :placeholder "|Describe the task"

        div $ {}
          :event $ {} :click (handle-remove task state)
          :style style-remove
