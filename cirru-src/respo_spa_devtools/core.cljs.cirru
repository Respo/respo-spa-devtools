
ns respo-spa-devtools.core $ :require
  [] respo.renderer.expander :refer $ [] render-app
  [] respo.controller.deliver :refer $ [] build-deliver-event
  [] respo.renderer.differ :refer $ [] find-element-diffs
  [] respo.util.format :refer $ [] purify-element
  [] respo-client.controller.client :refer $ [] initialize-instance activate-instance patch-instance
  [] devtools.core :as devtools
  [] respo-spa-devtools.schema :as schema
  [] respo-spa-devtools.component.container :refer $ [] container-component
  [] respo-spa-devtools.updater.core :refer $ [] updater

defonce global-states $ atom $ {}

defonce global-element $ atom nil

defonce global-store $ atom schema/store

defn render-element ()
  .info js/console |render-element @global-store
  render-app ([] container-component @global-store)
    , @global-states

defn intent (op-type op-data)
  .info js/console |Intent: op-type op-data
  let
      new-store $ updater @global-store op-type op-data $ .valueOf $ js/Date.
    reset! global-store new-store

defn get-root ()
  .querySelector js/document |#app

declare rerender-app

defn get-deliver-event ()
  build-deliver-event global-element intent global-states

defn mount-app ()
  let
    (element $ render-element) (app-root $ get-root)
      deliver-event $ get-deliver-event
    initialize-instance app-root deliver-event
    activate-instance element app-root deliver-event
    reset! global-element element

defn rerender-app ()
  let
    (element $ render-element) (app-root $ get-root)
      deliver-event $ get-deliver-event
      changes $ find-element-diffs ([])
        []
        purify-element @global-element
        purify-element element

    .info js/console |Changes: changes
    patch-instance changes app-root deliver-event
    reset! global-element element

defn -main ()
  devtools/enable-feature! :sanity-hints :dirac
  devtools/install!
  .info js/console "|App started"
  mount-app
  add-watch global-store :rerender rerender-app
  add-watch global-states :rerender rerender-app

set! (.-onload js/window)
  , -main

defn on-jsload ()
  .info js/console "|Reload app"
  rerender-app
