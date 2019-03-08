#lang racket/base
(require racket/match
         "base.rkt")
(provide (all-defined-out)
         pronoun)

(define (adverb cz) (adv cz))
(define (preposition cz) (prep cz))
(define (conjunction cz) (conj cz))
(define (prepositional-phrase cz) (prep-phrase cz))

;; ----------------------------------------
;; Adjectives

(struct adj/i adj () #:transparent)
(struct adj/y adj () #:transparent)

;; adjective : String -> Element
(define (adjective cz)
  (cond [(regexp-match #rx"^.*[áýé]$" cz)
         (adj/y cz)]
        [(regexp-match #rx"^.*í$" cz)
         (adj/i cz)]
        [else (error 'adjective "irregular adjective: ~e" cz)]))


;; ----------------------------------------
;; Verbs

(struct reg-verb verb (stem ppart) #:transparent)
(struct verb/a  reg-verb () #:transparent)
(struct verb/i  reg-verb () #:transparent)
(struct verb/uj reg-verb () #:transparent)
(struct verb/e  reg-verb () #:transparent)
(struct irr-verb verb (forms ppart) #:transparent)

;; regular-verb : String -> Element
(define (regular-verb cz)
  (cond [(regexp-match #rx"^(.*)ovat$" cz)
         => (match-lambda [(list _ stem) (verb/uj cz stem (string-append stem "oval"))])]
        [(regexp-match #rx"^(.*)at$" cz)
         => (match-lambda [(list _ stem) (verb/a cz stem (string-append stem "al"))])]
        [(regexp-match #rx"^(.*)([eěi])t$" cz)
         => (match-lambda [(list _ stem vowel) (verb/i cz stem (string-append stem vowel "l"))])]
        [else (error 'verb "unknown infinitive form: ~e" cz)]))

;; irregular-verg : S-Expr -> Element
(define (irregular-verb cz)
  (match cz
    [(list '#:a inf stem ppart)
     (verb/a inf stem ppart)]
    [(list '#:i inf stem ppart)
     (verb/i inf stem ppart)]
    [(list '#:e inf stem ppart)
     (verb/e inf stem ppart)]
    [(list '#:irr inf 1s 2s 3s 1p 2p 3p ppart)
     (irr-verb inf (vector 1s 2s 3s 1p 2p 3p) ppart)]
    [_ (error 'irregular-verb "unknown form: ~e" cz)]))

(define (conjugate v tense p)
  (case tense
    [(present) (conjugate/present v p)]))

(define (conjugate/present v p)
  (match v
    [(verb/a   _ stem _) (string-append stem (regular-verb-ending 'a p))]
    [(verb/i   _ stem _) (string-append stem (regular-verb-ending 'i p))]
    [(verb/uj  _ stem _) (string-append stem (regular-verb-ending 'uj p))]
    [(verb/e   _ stem _) (string-append stem (regular-verb-ending 'e p))]
    [(irr-verb _ forms _) (vector-ref forms (person->index p))]))

(define (regular-verb-ending verb-type person)
  (vector-ref (regular-verb-endings verb-type) (person->index person)))

(define (regular-verb-endings verb-type)
  (case verb-type
    [(a)  '#("ám"  "áš"   "á"   "áme"   "áte"   "ají")]
    [(i)  '#("ím"  "íś"   "í"   "íme"   "íte"   "í")]
    [(uj) '#("uju" "uješ" "uje" "ujeme" "ujete" "ujou")]
    [(e)  '#("u"   "eš"   "e"   "eme"   "ete"   "ou")]))

(define (person->index p)
  (case p [(1s) 0] [(2s) 1] [(3s) 2] [(1p) 3] [(2p) 4] [(3p) 5]))
