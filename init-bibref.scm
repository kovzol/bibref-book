(plugin-configure bibref
  (:require (url-exists-in-path? "bibref"))
  (:launch "bibref -t -a -c")
  (:tab-completion #t)
  (:session "bibref"))
