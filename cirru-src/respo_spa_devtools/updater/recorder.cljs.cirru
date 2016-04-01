
ns respo-spa-devtools.updater.recorder $ :require
  [] respo-spa-devtools.schema :as schema

defn regenerate-store (initial-store updater records)
  if
    = (count records)
      , 0
    , initial-store
    recur
      let
        (action $ last records)
          action-type $ get action 0
          action-data $ get action 1
          action-id $ get action 2
        updater initial-store action-type action-data action-id

      , updater
      into ([])
        butlast records

defn update-recorder
  old-recorder updater op-type op-data op-id
  case op-type
    :state $ update old-recorder :state
      fn (old-state)
        merge old-state op-data

    :record $ if (:visiting? old-recorder)
      update old-recorder :records $ fn (records)
        conj records op-data
      -> old-recorder
        update :records $ fn (records)
          conj records op-data
        assoc :store $ updater (:store old-recorder)
          get op-data 0
          get op-data 1
          get op-data 2
        update :pointer inc

    :commit $ -> old-recorder
      assoc :initial $ :store old-recorder
      assoc :pointer 0
      assoc :records $ []
      assoc :visiting? false
      assoc :changes nil
    :reset $ -> old-recorder
      assoc :records $ []
      assoc :pointer 0
      assoc :visiting? false
      assoc :changes nil
      assoc :store $ :initial old-recorder
    :visit $ if (= op-data 0)
      -> old-recorder (assoc :pointer 0)
        assoc :visiting? true
        assoc :store $ :initial old-recorder
        assoc :diff nil
      -> old-recorder (assoc :pointer op-data)
        assoc :visiting? true
        assoc :store $ regenerate-store (:initial old-recorder)
          , updater
          subvec (:records old-recorder)
            , 0 op-data

    :run $ -> old-recorder (assoc :visiting? false)
      assoc :pointer $ count (:records old-recorder)
      assoc :store $ regenerate-store (:initial old-recorder)
        , updater
        :records old-recorder
      assoc :changes nil

    :step $ if
      > (:pointer old-recorder)
        , 0
      -> old-recorder (update :pointer dec)
        assoc :store $ regenerate-store (:initial old-recorder)
          , updater
          subvec (:records old-recorder)
            , 0
            dec $ :pointer old-recorder

        assoc :diff nil

      , old-recorder

    :step-back $ if
      < (:pointer old-recorder)
        count $ :records old-recorder
      -> old-recorder (update :pointer inc)
        assoc :store $ regenerate-store (:initial old-recorder)
          , updater
          subvec (:records old-recorder)
            , 0
            inc $ :pointer old-recorder

        assoc :diff nil

      , old-recorder

    , old-recorder
