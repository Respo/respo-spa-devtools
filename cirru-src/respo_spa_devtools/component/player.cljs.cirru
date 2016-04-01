
ns respo-spa-devtools.component.player $ :require
  [] hsl.core :refer $ [] hsl
  [] respo-value.component.value :refer $ render-value

def style-player $ {} (:display |flex)
  :flex-direction |row

def style-box $ {} (:display |flex)
  :flex-direction |column

def style-header $ {} (:display |flex)
  :margin-bottom |16px

def style-body $ {}

def style-records $ {} (:width |240px)
  :margin-right |16px

def style-record $ {} (:font-family "|Source code pro, menlo, monospace")
  :background-color $ hsl 120 70 70
  :padding "|0 8px"
  :line-height |24px
  :color |white
  :cursor |pointer

def style-tab $ {} (:display |inline-block)
  :font-family "|Source code pro, menlo, monospace"
  :background-color $ hsl 0 0 40
  :padding "|0 8px"
  :font-size |12px
  :line-height |24px
  :color $ hsl 0 0 100
  :cursor |pointer

defn select-tab (tab)
  fn (simple-event dispatch mutate)
    mutate tab

def player-component $ {} (:name :player)
  :update-state $ fn (old-state new-state)
    , new-state
  :get-state $ fn (recorder)
    , :store
  :render $ fn (recorder)
    fn (tab)
      let
        (records $ :records recorder)
          store $ :store recorder
          changes $ :changes recorder
          initial-store $ :initial recorder
        [] :div
          {} $ :style style-player
          [] :div
            {} $ :style style-records
            ->> records
              map-indexed $ fn (index record)
                [] index $ [] :div
                  {} $ :style style-record
                  [] :span $ {}
                    :inner-text $ first record

              into $ sorted-map

          [] :div
            {} $ :style style-box
            [] :div
              {} $ :style style-header
              [] :span $ {} (:style style-tab)
                :on-click $ select-tab :store
                :inner-text |store
              [] :span $ {} (:style style-tab)
                :on-click $ select-tab :changes
                :inner-text |changes
              [] :span $ {} (:style style-tab)
                :on-click $ select-tab :initial
                :inner-text |initial

            [] :div
              {} $ :style style-body
              render-value $ case tab (:store store)
                :changes changes
                :initial initial-store
                , nil
