
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
  :overflow-y |auto

defn style-records-list (n)
  {}
    :height $ str (* 24 n)
      , |px
    :position |relative

defn style-record (index)
  {} (:font-family "|Source code pro, menlo, monospace")
    :background-color $ hsl 120 70 70
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

def style-initial $ {} (:font-family "|Source code pro, menlo")
  :font-size |12px
  :padding "|0 8px"
  :color |white
  :line-height |24px
  :cursor |pointer
  :background-color $ hsl 170 80 60

defn select-tab (tab)
  fn (simple-event dispatch mutate)
    mutate tab

defn select-record (index)
  fn (simple-event dispatch mutate)
    .info js/console |selecting: index

defn select-initial (simple-event dispatch mutate)
  .log js/console "|select initial"

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
        [] :nav
          {} $ :style style-player
          [] :div
            {} $ :style style-records
            [] :div
              {} $ :style
                style-records-list $ count records
              ->> records (reverse)
                map-indexed $ fn (index record)
                  [] (last record)
                    [] :div
                      {}
                        :style $ style-record index
                        :on-click $ select-record index
                      [] :span $ {}
                        :inner-text $ first record

                into $ sorted-map

            [] :div
              {} (:style style-initial)
                :on-click select-initial
              [] :span $ {} (:inner-text |initial)

          [] :div
            {} $ :style style-box
            [] :div
              {} $ :style style-toolbar
              [] :span $ {} (:style style-button)
                :inner-text |commit
              [] :span $ {} (:style style-button)
                :inner-text |reset
              [] :span $ {} (:style style-button)
                :inner-text |step

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
