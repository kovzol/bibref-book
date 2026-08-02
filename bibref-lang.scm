(texmacs-module (bibref-lang)
  (:use (prog default-lang)))

(tm-define (parser-feature lan key)
  (:require (and (== lan "bibref") (== key "keyword")))
  `(,(string->symbol key)
    (keyword "diagram" "extend" "find" "getrefs" "help" "jaccard" "latintext"
       "length" "lookup" "maxresults" "minunique" "nearest" "raw"
       "search" "statement" "text" "tokens")
    (declare_module
      "LXX" "StatResGNT" "SBLGNT")
    (constant_module "Genesis" "Exodus" "Leviticus" "Numbers" "Deuteronomy"
      "Joshua" "Judges" "Ruth" "I_Samuel" "II_Samuel" "I_Kings" "II_Kings"
      "I_Chronicles" "II_Chronicles" "I_Esdras" "Esra" "Nehemiah" "Esther"
      "Judith" "Tobit" "I_Maccabees" "II_Maccabees" "III_Maccabees" "IV_Maccabees"
      "Proverbs" "Ecclesiastes" "Song_of_Solomon" "Job" "Wisdom" "Sirach"
      "Psalms_of_Solomon" "Hosea" "Amos" "Micah" "Joel" "Obadiah" "Jonah"
      "Nahum" "Habakkuk" "Zephaniah" "Haggai" "Zechariah" "Malachi" "Isaiah"
      "Jeremiah" "Baruch" "Lamentations" "Epistle_of_Jeremiah" "Ezekiel"
      "Susanna" "Daniel" "Bel_and_the_Dragon" "Odes")
    (variable_module "Matthew" "Mark" "Luke" "John" "Romans" "Acts"
      "I_Corinthians" "II_Corinthians" "Galatians" "Ephesians" "Philippians" "Colossians"
      "I_Thessalonians" "II_Thessalonians" "I_Timothy" "II_Timothy" "Titus"
      "Philemon" "Hebrews" "Jude" "I_Peter" "II_Peter"
      "I_John" "II_John" "III_John" "Revelation_of_John")
))
;; TODO: vocabulary items containing _ (underscore) do not work yet


(define (notify-bibref-syntax var val)
  (syntax-read-preferences "bibref"))

(define-preferences
  ("syntax:bibref:none" "red" notify-bibref-syntax)
  ("syntax:bibref:error" "dark red" notify-bibref-syntax)
  ("syntax:bibref:keyword" "#000a74" notify-bibref-syntax)
  ("syntax:bibref:declare_module" "#00010d" notify-bibref-syntax)
  ("syntax:bibref:constant_module" "#3f2800" notify-bibref-syntax)
  ("syntax:bibref:variable_module" "#000542" notify-bibref-syntax)
)
