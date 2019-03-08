#lang racket/base
(require racket/match
         "base.rkt")
(provide (all-defined-out))

(struct phrase translation () #:transparent)
(struct noun-phrase translation () #:transparent)
(struct verb-phrase translation () #:transparent)
(struct imperative-phrase translation () #:transparent)
(struct prepositional-phrase translation () #:transparent)

(struct noun translation () #:transparent)
(struct pronoun translation () #:transparent)
(struct adverb translation () #:transparent)
(struct conjunction translation () #:transparent)
(struct preposition translation () #:transparent)

(struct adj-base translation () #:transparent)
(struct adj/i adj-base () #:transparent)
(struct adj/y adj-base () #:transparent)

(define (adjective cz rhs)
  (cond [(regexp-match #rx"^.*[áýé]$" cz)
         (adj/y cz rhs)]
        [(regexp-match #rx"^.*í$" cz)
         (adj/i cz rhs)]
        [else (error 'adjective "irregular adjective: ~e" cz)]))

(struct verb-base translation () #:transparent)
(struct verb/reg verb-base (stem ppart) #:transparent)
(struct verb/a verb/reg () #:transparent)
(struct verb/i verb/reg () #:transparent)
(struct verb/uj verb/reg () #:transparent)
(struct verb/e verb/reg () #:transparent)
(struct verb/irr verb-base (forms ppart) #:transparent)

(define (verb cz rhs)
  (cond [(regexp-match #rx"^(.*)ovat$" cz)
         => (match-lambda [(list _ stem) (verb/uj cz rhs stem (string-append stem "oval"))])]
        [(regexp-match #rx"^(.*)at$" cz)
         => (match-lambda [(list _ stem) (verb/a cz rhs stem (string-append stem "al"))])]
        [(regexp-match #rx"^(.*)([eěi])t$" cz)
         => (match-lambda [(list _ stem vowel) (verb/i cz rhs stem (string-append stem vowel "l"))])]
        [else (error 'verb "unknown infinitive form: ~e" cz)]))

(define (irregular-verb cz rhs)
  (match cz
    [(list '#:a inf stem ppart)
     (verb/a inf rhs stem ppart)]
    [(list '#:i inf stem ppart)
     (verb/i inf rhs stem ppart)]
    [(list '#:e inf stem ppart)
     (verb/e inf rhs stem ppart)]
    [(list '#:irr inf 1s 2s 3s 1p 2p 3p ppart)
     (verb/irr inf rhs (vector 1s 2s 3s 1p 2p 3p) ppart)]
    [_ (error 'irregular-verb "unknown form: ~e" cz)]))

(define (conjugate v tense p)
  (case tense
    [(present) (conjugate/present v p)]))

(define (conjugate/present v p)
  (match v
    [(verb/a   _ _ stem _) (string-append stem (regular-verb-ending 'a p))]
    [(verb/i   _ _ stem _) (string-append stem (regular-verb-ending 'i p))]
    [(verb/uj  _ _ stem _) (string-append stem (regular-verb-ending 'uj p))]
    [(verb/e   _ _ stem _) (string-append stem (regular-verb-ending 'e p))]
    [(verb/irr _ _ forms _) (vector-ref forms (person->index p))]))

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
