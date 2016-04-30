
ns respo-spa-devtools.core $ :require
  [] respo.renderer.expander :refer $ [] render-app
  [] respo.controller.deliver :refer $ [] build-deliver-event mutate-factory
  [] respo.renderer.differ :refer $ [] find-element-diffs
  [] respo.util.format :refer $ [] purify-element
  [] respo-client.controller.client :refer $ [] initialize-instance activate-instance patch-instance
  [] devtools.core :as devtools
  [] respo-spa-devtools.schema :as schema
  [] respo-spa-devtools.component.container :refer $ [] container-component
  [] respo-spa-devtools.updater.core :refer $ [] updater
  [] respo-spa-devtools.updater.recorder :refer $ [] update-recorder
  [] respo-spa-devtools.component.devtools :refer $ [] devtools-component
  [] cljs.reader :refer $ [] read-string

defonce global-states $ atom ({})

defonce global-element $ atom nil

defonce devtools-store $ atom
  assoc schema/recorder :state ({})
    , :initial
    []

defonce devtools-states $ atom ({})

defonce global-devtools-element $ atom nil

defn render-element ()
  let
    (build-mutate $ mutate-factory global-element global-states)
    render-app
      container-component $ :store @devtools-store
      , @global-states build-mutate

defn render-devtools-element ()
  .info js/console "|render devtools" @devtools-states
  let
    (app-element $ render-element)
      build-mutate $ mutate-factory global-devtools-element devtools-states
    .log js/console @devtools-store
    render-app
      devtools-component $ {} (:element app-element)
        :devtools-store @devtools-store
        :store $ :store @devtools-store
        :style $ {} (:top |200px)
          :left |300px
          :width |800px
          :height |300px
        :visible? true
        :mount-point |#app

      , @devtools-states build-mutate

defn devtools-dispatch (op-type op-data)
  .info js/console "|DevTools dispatch:" op-type op-data
  let
    (op-id $ .valueOf (js/Date.))
      new-store $ update-recorder @devtools-store updater op-type op-data op-id

    reset! devtools-store new-store

defn dispatch (op-type op-data)
  .info js/console |dispatch: op-type op-data
  devtools-dispatch :record $ [] op-type op-data (.valueOf $ js/Date.)

defn get-root ()
  .querySelector js/document |#app

defn get-devtools-root ()
  .querySelector js/document |#devtools

declare rerender-app

defn get-deliver-event ()
  build-deliver-event global-element dispatch

defn get-devtools-deliver-event ()
  build-deliver-event global-devtools-element devtools-dispatch

defn mount-app ()
  let
    (element $ render-element) (app-root $ get-root)
      deliver-event $ get-deliver-event
      devtools-element $ render-devtools-element
      devtools-root $ get-devtools-root
      devtools-deliver-event $ get-devtools-deliver-event
    initialize-instance app-root deliver-event
    activate-instance (purify-element element)
      , app-root deliver-event
    reset! global-element element
    initialize-instance devtools-root devtools-deliver-event
    activate-instance (purify-element devtools-element)
      , devtools-root devtools-deliver-event
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

    patch-instance changes app-root deliver-event
    reset! global-element element
    patch-instance devtools-changes devtools-root devtools-deliver-event
    reset! global-devtools-element devtools-element

defn -main ()
  devtools/enable-feature! :sanity-hints :dirac
  devtools/install!
  .info js/console "|App started"
  mount-app
  add-watch global-states :rerender rerender-app
  add-watch devtools-store :rerender rerender-app
  add-watch devtools-states :renderer rerender-app

defn listen-context-menu (event)
  .log js/console event.target
  let
    (click-target $ .-target event)
      coord $ -> click-target .-dataset .-coord
    if (string? coord)
      do (.preventDefault event)
        swap! devtools-store assoc :focus (read-string coord)
          , :rect
          .getBoundingClientRect click-target

set! (.-onload js/window)
  , -main

set! (.-oncontextmenu js/window)
  , listen-context-menu

defn on-jsload ()
  .info js/console "|Reload app"
  rerender-app
