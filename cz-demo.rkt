#lang jazyk
;; run with: racket cz-demo.rkt --no-shuffle --no-to --verb-forms 1s

#:definitions
(require "language/cz.rkt")

;; ============================================================
#:section "Intro"

#:translate phrase
"Dobrý den."                    "Good day."
"Jak se máte?"                  "How are you?"

#:translate regular-verb
bydlet                          "reside"

#:translate prepositional-phrase
"v České republice"		"in the Czech Republic"

#:translate adverb
teď                             now
proto                           therefore

#:translate verb-phrase
"učit se česky"			"learn Czech"

#:escape
(regular-verb "učit")
