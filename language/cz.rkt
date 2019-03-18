#lang racket/base
(require racket/match
         racket/list
         racket/string
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
  ;; consonant w/  hook: [čňřšžťď]
  (cond [(regexp-match #rx"tel$" cz) 2]
        [(regexp-match #rx"[čňřšžťďeěcj]$" cz) 2]
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
;; Pronoun

(define nom-pronouns
  ;; 1s   2s    3s-m  3s-f  3s-n  1p   2p   3p
  '#("já" "ty"  "on"  "ona" "to"  "my" "vy" "oni"))


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

(define (decline-adjective a g)
  (match a
    [(adj/i cz) cz]
    [(adj/y cz)
     (define stem (substring cz 0 (sub1 (string-length cz))))
     (string-append stem (case g [(m) "ý"] [(f) "á"] [(n) "é"]))]))

;; ----------------------------------------
;; Verbs

(struct reg-verb verb (stem ppart) #:transparent)
(struct verb/a  reg-verb () #:transparent)
(struct verb/i  reg-verb () #:transparent)
(struct verb/uj reg-verb () #:transparent)
(struct verb/e  reg-verb () #:transparent)
(struct irr-verb verb (forms ppart) #:transparent)

(define (verb-inf v)
  (word-key v))
(define (verb-ppart v)
  (match v
    [(reg-verb _ _ ppart) ppart]
    [(irr-verb _ _ ppart) ppart]))

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

(define (verb-form v vf)
  (case vf
    [(inf) (verb-inf v)]
    [(1s 2s 3s 1p 2p 3p) (conjugate/present v vf)]
    [(ppart) (verb-ppart v)]
    [else #f]))

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
    [(i)  '#("ím"  "íš"   "í"   "íme"   "íte"   "í")]
    [(uj) '#("uju" "uješ" "uje" "ujeme" "ujete" "ujou")]
    [(e)  '#("u"   "eš"   "e"   "eme"   "ete"   "ou")]))

(define (person->index p)
  (case p [(1s) 0] [(2s) 1] [(3s) 2] [(1p) 3] [(2p) 4] [(3p) 5]))

;; ------------------------------------------------------------
;; Numbers

(define cz-numbers
  '([0            "nula"]
    [1           "jedna"]
    [2             "dva"]
    [3             "tři"]
    [4           "čtyři"]
    [5             "pět"]
    [6            "šest"]
    [7            "sedm"]
    [8             "osm"]
    [9           "devět"]
    [10          "deset"]
    [11       "jedenáct"]
    [12        "dvanáct"]
    [13        "třináct"]
    [14        "čtrnáct"]
    [15        "patnáct"]
    [16       "šestnáct"]
    [17       "sedmnáct"]
    [18        "osmnáct"]
    [19     "devatenáct"]
    [20         "dvacet"]
    [30         "třicet"]
    [40       "čtyřicet"]
    [50        "padesát"]
    [60        "šedesát"]
    [70      "sedmdesát"]
    [80       "osmdesát"]
    [90      "devadesát"]))

(define (nat->cz n)
  (define (ifnz f n) (if (zero? n) '() (f n)))
  (define (base n)
    (cond [(assoc n cz-numbers) => cadr]
          [else
           (define d (remainder n 10))
           (list (base (- n d)) (ifnz base d))]))
  (define (hundreds n)
    (case n
      [(1) "sto"]
      [(2) (list "dvě" "stě")]
      [(3 4) (list (base n) "sta")]
      [else (list (base n) "set")]))
  (define (thousands n)
    (case n
      [(1) "tisíc"]
      [(2 3 4) (list (base n) "tisíce")]
      [else (list (base n) "tisíc")]))
  (unless (and (<= 0 n) (< n #e1e6))
    (error 'nat->cz "out of range: ~s:" n))
  (string-join
   (let ([t (quotient n 1000)]
         [h (quotient (remainder n 1000) 100)]
         [b (remainder n 100)])
     (flatten (list (ifnz thousands t)
                    (ifnz hundreds h)
                    (ifnz base b))))))
