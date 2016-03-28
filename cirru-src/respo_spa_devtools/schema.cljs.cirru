
ns respo-spa-devtools.schema $ :require $ [] clojure.string :as string

def store $ []

def task $ {} (:id nil)
  :text |
  :done? false

def recorder $ {} (:initial nil)
  :store nil
  :pointer 0
  :records $ []
  :visiting? false
  :changes nil
  :state $ {}
