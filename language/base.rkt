#lang racket/base
(require racket/string)
(provide (all-defined-out))

;; ------------------------------------------------------------
;; A Section is a named list of Entries.

(struct section (name entries) #:transparent)

;; ------------------------------------------------------------

;; An Entry is one of:
;; - (translation Element Element)
;; - ...
(struct translation (lhs rhs) #:transparent)

;; A typical subtype of Entry is a Translation, which relates two
;; Elements of different languages.

;; For example: "pracovat" = "work", "Mám otazku." = "I have a question."

;; Some variants of Element imply additional relations beyond the one
;; explicitly expressed by the translation syntax.

;; For example: "pracovat" = "work"  -->  "pracoval jsem" = "I worked"

;; Other kinds of Entry might include grammatical or semantic
;; relations. An example of a grammatical rule is that the object of
;; the preposition "v" is in the locative case. An example of semantic
;; rules is that the verb "see" can have the subject "man" and direct
;; object "tree".

;; ------------------------------------------------------------

;; An Element is one of:
;; - String
;; - (word String) or subtype
;; - ....
(struct word (key) #:transparent)

;; Additionally, an Element can have a GrammarType property.
(define-values (prop:grammar prop:grammar? prop:grammar-ref)
  (make-struct-type-property 'grammar))

;; A GrammarType is one of
;; - '#f     -- a sentence or a phrase that doesn't combine ("as is")
;; - 'noun
;; - 'verb
;; - 'adj
;; - 'adv
;; - 'conj
;; - 'prep
(define (grammar-type elem) 
  (and (prop:grammar? elem) (prop:grammar-ref elem)))

(define (elem-complete? elem) (eq? (grammar-type elem) #f))
(define (elem-noun? elem) (eq? (grammar-type elem) 'noun))
(define (elem-verb? elem) (eq? (grammar-type elem) 'verb))
(define (elem-adj? elem)  (eq? (grammar-type elem) 'adj))
(define (elem-adv? elem)  (eq? (grammar-type elem) 'adv))
(define (elem-conj? elem) (eq? (grammar-type elem) 'conj))
(define (elem-prep? elem) (eq? (grammar-type elem) 'prep))

;; A Dictionary is Hash[String => (Listof Element)]
(define (make-dictionary elems [base (hash)])
  (for/fold ([d base]) ([elem (in-list elems)] #:when (word? elem))
    (define key (word-key elem))
    (hash-set d key (cons elem (hash-ref d key null)))))

;; dictionary-ref : Dictionary String Symbol -> (U Element #f)
(define (dictionary-ref d key gtype)
  (cond [(hash-ref d key #f)
         => (lambda (elems)
              (for/first ([elem (in-list elems)]
                          #:when (equal? (grammar-type elem) gtype))
                elem))]
        [else #f]))

(struct noun word () #:transparent #:property prop:grammar 'noun)
(struct pronoun word () #:transparent #:property prop:grammar 'noun)
(struct verb word () #:transparent #:property prop:grammar 'verb)
(struct adv  word () #:transparent #:property prop:grammar 'adv)
(struct adj  word () #:transparent #:property prop:grammar 'adj)
(struct conj word () #:transparent #:property prop:grammar 'conj)
(struct prep word () #:transparent #:property prop:grammar 'prep)

(struct phrase (words) #:transparent)
(struct noun-phrase phrase () #:transparent #:property prop:grammar 'noun)
(struct verb-phrase phrase () #:transparent #:property prop:grammar 'verb)
(struct prep-phrase phrase () #:transparent #:property prop:grammar 'adv) ;; FIXME?
(struct imperative-phrase phrase () #:transparent)

;; ============================================================

(define (join . xs) (string-join xs " "))
