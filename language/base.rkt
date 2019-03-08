#lang racket/base
(require racket/string)
(provide (all-defined-out))

;; ------------------------------------------------------------
;; A Section is a named list of Entries.

(struct section (name parts) #:prefab)

;; ------------------------------------------------------------

;; An Entry is an abstract type. A typical subtype of Entry is a
;; Translation, which relates two Elements of different languages.

;; For example: "pracovat" = "work", "Mám otazku." = "I have a question."

(struct translation (lhs rhs) #:transparent)

;; Some variants of Entry imply additional relations beyond the one
;; explicitly expressed by the Entry syntax.

;; For example: "pracovat" = "work"  -->  "pracoval jsem" = "I worked"

;; Other kinds of Entry might include grammatical or semantic
;; relations. An example of a grammatical rule is that the object of
;; the preposition "v" is in the locative case. An example of semantic
;; rules is that the verb "see" can have the subject "man" and direct
;; object "tree".

;; ------------------------------------------------------------
;; An Element is a String.

;; An Element consists of one or more Words. Depending on context, it
;; may be treated atomically or it may be subject to destructuring.

;; For example: "pracovat", "ucím se", "ještě jednou", "Mám otazku."

;; elem : (U String Symbol) -> Elem --- FIXME
(define (elem s)
  (cond [(symbol? s) (symbol->string s)]
        [(string? s) s]
        [(list? s) (map elem s)]
        [(keyword? s) s]
        [else (error 'word "bad argument: ~e" s)]))

;; explode-elem : Elem -> (Listof Word)
(define (explode-elem e)
  (string-split e))

;; ok-elem? : Elem -> Boolean
(define (ok-elem? s) (not (wildcard? s)))

;; ------------------------------------------------------------
;; A Word is a String.

;; Depending on context, a Word may be treated atomically or it may be
;; subject to destructuring.

;; For example: "pracovat" (context: uj-verb) -> "pracuju"

;; The wildcard Word ("_") indicates unknown translation. It might be
;; used, for example, to establish the part of speech and
;; conjugation/declension of a word that otherwise appears in phrases.

;; wildcard? : Word -> Boolean
(define (wildcard? s) (equal? s "_"))

;; placeholder? : Word -> Boolean
(define (placeholder? s) (regexp-match? #rx"^<.*>$" s))
