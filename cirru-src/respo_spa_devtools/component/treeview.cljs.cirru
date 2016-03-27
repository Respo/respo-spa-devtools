
ns respo-spa-devtools.component.treeview $ :require
  [] hsl.core :refer $ [] hsl
  [] respo-spa-devtools.component.element :refer $ [] element-component

def style-treeview $ {} $ :display |flex

def treeview-component $ {}
  :initial-state $ {} $ :pointer nil
  :render $ fn (props state)
    [] :div
      {} $ :style style-treeview
      [] element-component $ :element props
      [] :span $ {} $ :inner-text |Props
