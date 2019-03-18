#lang racket/base
(require racket/list
         racket/string)
(provide (all-defined-out))

;; ------------------------------------------------------------
;; A Section is a named list of Entries.

(struct section (name entries) #:transparent)

;; ------------------------------------------------------------

;; An Entry is one of:
;; - (translation Element String)
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

;; Element variants have additional properties.

;; prop:grammar : Element property containing GrammarType
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

;; prop:pretty-type : Element property containing String
;; Defaults to object-name (ie, name of struct type).
(define-values (prop:pretty-type prop:pretty-type? prop:pretty-type-ref)
  (make-struct-type-property 'pretty-type))

(define (pretty-type elem)
  (cond [(prop:pretty-type? elem) (prop:pretty-type-ref elem)]
        [else (object-name elem)]))

(struct word (key) #:transparent)
(struct noun word () #:transparent
  #:property prop:grammar 'noun #:property prop:pretty-type "noun")
(struct pronoun word () #:transparent
  #:property prop:grammar 'noun #:property prop:pretty-type "pronoun")
(struct verb word () #:transparent
  #:property prop:grammar 'verb #:property prop:pretty-type "verb")
(struct adv  word () #:transparent
  #:property prop:grammar 'adv #:property prop:pretty-type "adverb")
(struct adj  word () #:transparent
  #:property prop:grammar 'adj #:property prop:pretty-type "adjective")
(struct conj word () #:transparent
  #:property prop:grammar 'conj #:property prop:pretty-type "conjunction")
(struct prep word () #:transparent
  #:property prop:grammar 'prep #:property prop:pretty-type "preposition")

(struct phrase (words) #:transparent
  #:property prop:pretty-type "phrase or sentence")
(struct noun-phrase phrase () #:transparent
  #:property prop:grammar 'noun #:property prop:pretty-type "noun phrase")
(struct verb-phrase phrase () #:transparent
  #:property prop:grammar 'verb #:property prop:pretty-type "verb phrase")
(struct prep-phrase phrase () #:transparent
  #:property prop:grammar 'adv ;; FIXME?
  #:property prop:pretty-type "prepositional phrase")
(struct imperative-phrase phrase () #:transparent
  #:property prop:pretty-type "imperative phrase")

;; ============================================================

;; A Grammar stores information about a single language, such as a
;; mapping from (lemma,GrammarType) to Element.

;; A Grammar is (grammar Hash[String => (Listof Element)])
(struct grammar (h) #:transparent)

;; make-grammar : (Listof Element) -> Dictionary
(define (make-grammar elems)
  (define (hash-push h k v) (hash-set h k (cons v (hash-ref h k null))))
  (grammar
   (for/fold ([h (hash)]) ([elem (in-list elems)])
     (cond [(word? elem) (hash-push h (word-key elem) elem)]
           [(phrase? elem) (hash-push h (phrase-words elem) elem)]
           [else h]))))

;; grammar-ref : Grammar String Symbol -> (U Element #f)
(define (grammar-ref d key gtype)
  (cond [(hash-ref d key #f)
         => (lambda (elems)
              (for/first ([elem (in-list elems)]
                          #:when (equal? (grammar-type elem) gtype))
                elem))]
        [else #f]))

;; jazyk->grammar : (Listof Section) -> Grammar
(define (jazyk->grammar sections)
  (make-grammar
   (flatten
    (for*/list ([s (in-list sections)]
                [e (in-list (section-entries s))])
      (cond [(translation? e) (translation-lhs e)]
            [(or (word? e) (phrase? e)) e]
            [else '()])))))

;; ============================================================

(define (join . xs) (string-join xs " "))

;; A VerbPerson is one of '1s, '2s, '3s, '1p, '2p, '3p.
;; A VerbForm is 'inf, 'ppart, or a VerbPerson (means present tense).

(define (describe-verb-form vf)
  (case vf
    [(inf) "infinitive"]
    [(1s) "1st-person singular"]
    [(2s) "2nd-person singular"]
    [(3s) "3rd-person singular"]
    [(1p) "1st-person plural"]
    [(2p) "2nd-person plural"]
    [(3p) "3rd-person plural"]
    [(ppart) "past participle"]
    [else 'describe-verb-form "bad verb form: ~s" vf]))

