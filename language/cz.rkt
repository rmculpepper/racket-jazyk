#lang racket/base
(require racket/match
         "base.rkt")
(provide (all-defined-out)
         pronoun)

;; Grammar links:
;; https://mluvtecesky.net/en/grammar/nouns
;; http://www.locallingo.com/czech/grammar/nouns_declension_masc.html

(define (adverb cz) (adv cz))
(define (preposition cz) (prep cz))
(define (conjunction cz) (conj cz))
(define (prepositional-phrase cz) (prep-phrase cz))

;; ----------------------------------------
;; Noun

(struct cznoun noun (gender decl) #:transparent)

(define (noun-guess-gender cz animate?) ;; p18
  (cond [(regexp-match? #rx"[a]$" cz)  'f] ;; 92%
        [(regexp-match? #rx"[oí]$" cz) 'n] ;; 99% for -o, 99% for -í
        [(regexp-match? #rx"iště$" cz) 'n] ;; always
        [(regexp-match? #rx"[eě]$" cz) 'f] ;; 89% (including -iště)
        [(regexp-match? #rx"[aáeéěiíouůyý]$" cz) ;; other vowels
         (begin (eprintf "noun: cannot guess gender: ~e\n" cz) #f)]
        [else (if animate? 'ma 'mi)]))

(define (noun-guess-decl cz g) ;; p28
  ;; consonant w/o hook: [bcdfghjklmnpqrstvwxz]
  ;; consonant w/  hook: [čřšžťď]
  (cond [(regexp-match #rx"tel$" cz) 2]
        [(regexp-match #rx"[čřšžťďeěcj]$" cz) 2]
        [(and (memq g '(ma mi)) (regexp-match? #rx"[bcdfghjklmnpqrstvwxz]$" cz)) 1]
        [(and (memq g '(ma))    (regexp-match? #rx"[a]$" cz)) 3]
        [(and (memq g '(f))     (regexp-match? #rx"[a]$" cz)) 1]
        [(and (memq g '(f))     (regexp-match? #rx"st$"  cz)) 3]
        [(and (memq g '(n))     (regexp-match? #rx"[o]$" cz)) 1]
        [(and (memq g '(n))     (regexp-match? #rx"[í]$" cz)) 3]
        [else (begin (eprintf "noun: cannot guess declension: ~e\n" cz) #f)]))

(define (noun* cz animate?) ;; p18
  (define (kw->decl g)
    (case g
      [(#:f #:n #:ma #:mi) (string->symbol (keyword->string g))]
      [(#:m) (if animate? 'ma 'mi)]
      [else (error 'noun "bad noun form: ~e" cz)]))
  (define (mknoun cz g dec)
    (cond [(and g dec) (cznoun cz g dec)]
          [else (noun cz)]))
  (match cz
    [(? string?)
     (define g (noun-guess-gender cz animate?))
     (define dec (noun-guess-decl cz g))
     (cznoun cz g dec)]
    [(list (? keyword? g) cz*)
     (define g* (kw->decl g))
     (define dec (noun-guess-decl cz* g*))
     (cznoun cz* g* dec)]
    [(list (and dec (or 1 2 3)) (? keyword? g) cz*)
     (define g*
       (case g
         [(#:f #:n #:ma #:mi) (string->symbol (keyword->string g))]
         [(#:m) (if animate? 'ma 'mi)]
         [else (error 'noun "bad noun form: ~e" cz)]))
     (cznoun cz* g* dec)]))

(define (animate-noun cz) (noun* cz #t))
(define (inanimate-noun cz) (noun* cz #f))


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
