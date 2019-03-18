#lang racket/base
(require racket/match
         "base.rkt")
(provide (all-defined-out))

;; ----------------------------------------
;; Nouns

(struct en-noun noun (pl) #:transparent)

(define (regular-noun sg pl) (en-noun sg pl))

;; ----------------------------------------
;; Verbs

(struct reg-verb verb (3s past ppart) #:transparent)
(struct irr-verb verb (pres-forms past-forms ppart) #:transparent)

(define (regular-verb inf 3s past [ppart past])
  (reg-verb inf 3s past ppart))

(define verb:have (regular-verb "have" "has"   "had"))
(define verb:be (irr-verb "be" '#("am" "is" "are") '#("was" "was" "were") "been"))
(define verb:do (irr-verb "do" '#("do" "does" "do") '#("did" "did" "did") "done"))

(define verb:work (regular-verb "work" "works" "worked"))
(define verb:give (regular-verb "give" "gives" "gave" "given"))

(define (verb-inf v) (word-key v))

(define (verb-ing v) (string-append (verb-inf v) "ing")) ;; FIXME: give->giving, etc

(define (verb-ppart v)
  (cond [(reg-verb? v) (reg-verb-ppart v)]
        [(irr-verb? v) (irr-verb-ppart v)]))

(define (verb-form v vf)
  (case vf
    [(inf) (verb-inf v)]
    [(1s 2s 3s 1p 2p 3p) (conjugate v 'present vf)]
    [(ppart) (verb-ppart v)]))

(define (conjugate v tense p)
  (case tense
    [(present)
     (match v
       [(reg-verb inf 3s _ _)
        (case p [(3s) 3s] [else inf])]
       [(irr-verb inf pres _ _)
        (vector-ref pres (person->index p))])]
    [(past)
     (match v
       [(reg-verb _ _ past _) past]
       [(irr-verb _ _ past _) (vector-ref past (person->index p))])]
    [(future)
     (string-append "will " (word-key v))]
    [(present-perfect)
     (join (conjugate verb:have 'present p) (verb-ppart v))]
    [(past-perfect)
     (join (conjugate verb:have 'past p) (verb-ppart v))]
    [(future-perfect)
     (join (conjugate verb:have 'future p) (verb-ppart v))]
    ))

(define (person->index p)
  (case p [(1s) 0] [(2s) 2] [(3s) 1] [(1p) 2] [(2p) 2] [(3p) 2]))
