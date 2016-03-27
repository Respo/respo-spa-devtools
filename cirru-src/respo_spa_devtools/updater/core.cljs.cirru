
ns respo-spa-devtools.updater.core $ :require $ [] respo-spa-devtools.schema :as schema

defn updater
  old-store op-type op-data op-id
  case op-type
    :add $ conj old-store $ merge schema/task $ {} (:id op-id)
      :text op-data
    :rm $ ->> old-store
      filter $ fn (task)
        not= (:id task)
          , op-data

      into $ []

    :update $ ->> old-store
      map $ fn (task)
        if
          = (:id task)
            :id op-data
          assoc task :text $ :text op-data
          , task

      into $ []

    :toggle $ ->> old-store
      map $ fn (task)
        if
          = (:id task)
            , op-data
          update task :done? $ fn (done?)
            not done?
          , task

      into $ []

    , old-store
