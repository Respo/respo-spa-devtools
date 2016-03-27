
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
  [] respo-spa-devtools.component.devtools :refer $ [] devtools-component

defonce global-states $ atom $ {}

defonce global-element $ atom nil

defonce global-store $ atom schema/store

defonce devtools-store $ atom $ {} (:mount-point |#app)
  :visible? true

defonce devtools-states $ atom $ {}

defonce global-devtools-element $ atom nil

defn render-element ()
  render-app ([] container-component @global-store)
    , @global-states

defn render-devtools-element ()
  .info js/console "|render devtools" @devtools-states
  let
      app-element $ purify-element $ render-element
    render-app
      [] devtools-component $ {} (:element app-element)
        :devtools-store @devtools-store
        :store @global-store
        :states @global-states
        :style $ {} (:top |200px)
          :left |300px
          :width |800px
          :height |300px

      , @devtools-states

defn intent (op-type op-data)
  .info js/console |Intent: op-type op-data
  let
      new-store $ updater @global-store op-type op-data $ .valueOf $ js/Date.
    reset! global-store new-store

defn devtools-intent (changes)
  .info js/console "|DevTools intent:" changes
  swap! devtools-store merge changes

defn get-root ()
  .querySelector js/document |#app

defn get-devtools-root ()
  .querySelector js/document |#devtools

declare rerender-app

defn get-deliver-event ()
  build-deliver-event global-element intent global-states

defn get-devtools-deliver-event ()
  build-deliver-event global-devtools-element devtools-intent devtools-states

defn mount-app ()
  let
    (element $ render-element) (app-root $ get-root)
      deliver-event $ get-deliver-event
      devtools-element $ render-devtools-element
      devtools-root $ get-devtools-root
      devtools-deliver-event $ get-devtools-deliver-event
    initialize-instance app-root deliver-event
    activate-instance element app-root deliver-event
    reset! global-element element
    initialize-instance devtools-root devtools-deliver-event
    activate-instance devtools-element devtools-root devtools-deliver-event
    reset! global-devtools-element devtools-element

defn rerender-app ()
  let
    (element $ render-element) (app-root $ get-root)
      deliver-event $ get-deliver-event
      changes $ find-element-diffs ([])
        []
        purify-element @global-element
        purify-element element
      devtools-element $ render-devtools-element
      devtools-root $ get-devtools-root
      devtools-deliver-event $ get-devtools-deliver-event
      devtools-changes $ find-element-diffs ([])
        []
        purify-element @global-devtools-element
        purify-element devtools-element

    .info js/console |Changes: changes
    patch-instance changes app-root deliver-event
    reset! global-element element
    patch-instance devtools-changes devtools-root devtools-deliver-event
    reset! global-devtools-element devtools-element

defn -main ()
  devtools/enable-feature! :sanity-hints :dirac
  devtools/install!
  .info js/console "|App started"
  mount-app
  add-watch global-store :rerender rerender-app
  add-watch global-states :rerender rerender-app
  add-watch devtools-store :rerender rerender-app
  add-watch devtools-states :renderer rerender-app

set! (.-onload js/window)
  , -main

defn on-jsload ()
  .info js/console "|Reload app"
  rerender-app
