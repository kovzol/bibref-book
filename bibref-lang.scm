(texmacs-module (bibref-lang)
  (:use (prog default-lang)))

(tm-define (parser-feature lan key)
  (:require (and (== lan "bibref") (== key "keyword")))
  `(,(string->symbol key)
    (keyword "diagram" "extend" "find" "getrefs" "help" "jaccard" "latintext"
       "length" "lookup" "maxresults" "minunique" "nearest" "raw"
       "search" "statement" "Statement" "text" "tokens")
    (keyword_control "connects" "with" "based" "on" "introduction" "form" "that"
       "moreover" "fragment" "matches" "differing" "by" "and" "unique" "verbatim"
       "providing" "an" "overall" "cover" "of")
    (constant_module
      "LXX" "StatResGNT" "SBLGNT")
    (variable_module
      "HunRUF" "Aleppo" "KJV")
    (constant_identifier "Genesis" "Exodus" "Leviticus" "Numbers" "Deuteronomy"
      "Joshua" "Judges" "Ruth" "I_Samuel" "II_Samuel" "I_Kings" "II_Kings"
      "I_Chronicles" "II_Chronicles" "I_Esdras" "Esra" "Nehemiah" "Esther"
      "Judith" "Tobit" "I_Maccabees" "II_Maccabees" "III_Maccabees" "IV_Maccabees"
      "Proverbs" "Ecclesiastes" "Song_of_Solomon" "Job" "Wisdom" "Sirach"
      "Psalms_of_Solomon" "Hosea" "Amos" "Micah" "Joel" "Obadiah" "Jonah"
      "Nahum" "Habakkuk" "Zephaniah" "Haggai" "Zechariah" "Malachi" "Isaiah"
      "Jeremiah" "Baruch" "Lamentations" "Epistle_of_Jeremiah" "Ezekiel"
      "Susanna" "Daniel" "Bel_and_the_Dragon" "Odes")
    (variable_identifier "Matthew" "Mark" "Luke" "John" "Romans" "Acts"
      "I_Corinthians" "II_Corinthians" "Galatians" "Ephesians" "Philippians" "Colossians"
      "I_Thessalonians" "II_Thessalonians" "I_Timothy" "II_Timothy" "Titus"
      "Philemon" "Hebrews" "Jude" "I_Peter" "II_Peter"
      "I_John" "II_John" "III_John" "Revelation_of_John")
))
;; TODO: vocabulary items containing _ (underscore) do not work yet


(define (notify-bibref-syntax var val)
  (syntax-read-preferences "bibref"))

(define-preferences
  ("syntax:bibref:none" "dark red" notify-bibref-syntax)
  ("syntax:bibref:error" "red" notify-bibref-syntax)
  ("syntax:bibref:keyword" "#510e01" notify-bibref-syntax)
  ("syntax:bibref:keyword_control" "#5f1000" notify-bibref-syntax)
  ("syntax:bibref:constant_module" "#000000" notify-bibref-syntax)
  ("syntax:bibref:variable_module" "#202020" notify-bibref-syntax)
  ("syntax:bibref:constant_identifier" "#3f2800" notify-bibref-syntax)
  ("syntax:bibref:variable_identifier" "#000542" notify-bibref-syntax)
)
