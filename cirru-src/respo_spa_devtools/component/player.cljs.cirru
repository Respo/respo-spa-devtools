
ns respo-spa-devtools.component.player $ :require
  [] hsl.core :refer $ [] hsl
  [] respo-value.component.value :refer $ render-value
  [] respo.alias :refer $ [] create-comp div span

def style-player $ {} (:display |flex)
  :flex-direction |row

def style-box $ {} (:display |flex)
  :flex-direction |column

def style-header $ {} (:display |flex)
  :margin-bottom |16px

def style-body $ {}

def style-records $ {} (:width |240px)
  :margin-right |16px
  :overflow-y |auto
  :flex-shrink |0
  :flex-grow |0

defn style-records-list (n)
  {}
    :height $ str (* 24 n)
      , |px
    :position |relative
    :transition-duration |200ms

defn style-record (index selected?)
  {} (:font-family "|Source code pro, menlo, monospace")
    :background-color $ if selected?
      hsl 120 80 80
      hsl 120 70 70
    :padding "|0 8px"
    :line-height |24px
    :color |white
    :cursor |pointer
    :top $ str (* index 24)
      , |px
    :position |absolute
    :width |100%
    :transition-duration |200ms

def style-tab $ {} (:display |inline-block)
  :font-family "|Source code pro, menlo, monospace"
  :background-color $ hsl 0 0 40
  :padding "|0 8px"
  :font-size |12px
  :line-height |24px
  :color $ hsl 0 0 100
  :cursor |pointer
  :margin-right |8px

def style-toolbar $ {} (:margin-bottom |16px)

def style-button $ {} (:padding "|0 8px")
  :background-color $ hsl 30 70 50
  :margin-right |8px
  :color |white
  :font-family "|Source code pro, menlo, monospace"
  :line-height |24px
  :height |24px
  :display |inline-block
  :cursor |pointer

defn style-initial (selected?)
  {} (:font-family "|Source code pro, menlo")
    :font-size |12px
    :padding "|0 8px"
    :color |white
    :line-height |24px
    :cursor |pointer
    :background-color $ if selected?
      hsl 120 80 80
      hsl 120 70 70

def style-text-only $ {} (:pointer-events |none)

defn select-tab (mutate tab)
  fn (simple-event dispatch)
    mutate tab

defn select-record (index)
  fn (simple-event dispatch mutate)
    dispatch :visit index

defn select-initial (simple-event dispatch mutate)
  dispatch :visit 0

defn do-commit (simple-event dispatch mutate)
  dispatch :commit

defn do-reset (simple-event dispatch mutate)
  dispatch :reset

defn do-step (simple-event dispatch mutate)
  dispatch :step

defn do-run (simple-event dispatch mutate)
  dispatch :run

def player-component $ create-comp :player
  fn (recorder)
    , :store
  fn (old-state new-state)
    , new-state
  fn (recorder)
    fn (tab mutate)
      let
        (records $ :records recorder)
          store $ :store recorder
          changes $ :changes recorder
          initial-store $ :initial recorder
          pointer $ :pointer recorder
        div
          {} $ :style style-player
          div
            {} $ :style style-records
            div
              {} $ :style
                style-records-list $ count records
              ->> records (reverse)
                map-indexed $ fn (index record)
                  [] (last record)
                    div
                      {}
                        :style $ style-record index
                          = pointer $ - (count records)
                            , index

                        :event $ {} :click
                          select-record $ - (count records)
                            , index

                      span $ {} (:style style-text-only)
                        :attrs $ {} :inner-text (first record)

                into $ sorted-map

            div
              {}
                :style $ style-initial (= pointer 0)
                :on-click select-initial

              span $ {} (:inner-text |initial)
                :style style-text-only

          div
            {} $ :style style-box
            div
              {} $ :style style-toolbar
              span $ {} (:style style-button)
                :attrs $ {} :inner-text |commit
                :event $ {} :click do-commit
              span $ {} (:style style-button)
                :attrs $ {} :inner-text |reset
                :event $ {} :click do-reset
              span $ {} (:style style-button)
                :attrs $ {} :inner-text |step
                :event $ {} :click do-step
              span $ {} (:style style-button)
                :attrs $ {} :inner-text |run
                :event $ {} :click do-run

            div
              {} $ :style style-header
              span $ {} (:style style-tab)
                :event $ {} :click (select-tab mutate :store)
                :attrs $ {} :inner-text |store

              span $ {} (:style style-tab)
                :event $ {} :click (select-tab mutate :changes)
                :attrs $ {} :inner-text |changes

              span $ {} (:style style-tab)
                :event $ {} :click (select-tab mutate :action)
                :attrs $ {} :inner-text |action

            div
              {} $ :style style-body
              render-value $ case tab (:store store)
                :changes changes
                :action $ get records (dec pointer)
                , nil
