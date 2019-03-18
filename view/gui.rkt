#lang racket/base
(require racket/class
         racket/gui
         racket/list
         racket/match
         slideshow/base
         pict
         "../language/base.rkt"
         (prefix-in cz: "../language/cz.rkt")
         (prefix-in en: "../language/en.rkt")
         (prefix-in en: "../en.rkt")
         "qa.rkt")
(provide (all-defined-out))

;; ============================================================
;; A flashcard interaction

;; - initial presentation (show text, play audio)
;;   * navigation: prev / next / ...?
;;   * repeat (audio)
;;   * hints or show text or whatever (multiple times? add hint level?)
;;   * reveal answer
;;   * record right/wrong, add note?

;; State: Question
;;  "r" = repeat (audio)
;;  "h" = hint
;;  space = reveal answer

;; State: Answer
;;  left = go back to Question state and repeat audio
;;  "r" = repeat answer (audio)
;;  space or right or "y" = yes I got it
;;  "x" or "n" = no I missed it

;; Layout conventions
;; (1) split vertical, Question 2/3, Answer 1/3
;; (2) split horiz, Question 1/2, Answer 1/2

;; Record:
;; Question, Answer, time? to advance, hint level, right/wrong

;; ============================================================

(define WIDTH 600)
(define HEIGHT 600)

;; QA.Rendering is a Pict
;; QA.Audio is one of 
;; - (en String)
;; - (cz String)
;; - Real        -- pause
(struct en-audio (text) #:prefab)
(struct cz-audio (text) #:prefab)

(define flashcard-canvas%
  (class canvas%
    (init-field rounds) ;; vector of QA
    (init-field [audio (new null-audio%)])
    (inherit get-dc refresh)
    (super-new)

    ;; State within rounds
    (define index 0)

    ;; State within round
    (define hint-level 0)
    (define show-answer? #f)
    (define audio-said? #f)

    (define/public (get-current)
      (and (< index (vector-length rounds))
           (vector-ref rounds index)))

    (define/public (next-round)
      (when (< index (vector-length rounds))
        (set! index (add1 index))
        (reset-round-state)))

    (define/public (prev-round)
      (when (> index 0)
        (set! index (sub1 index))
        (reset-round-state)))

    (define/public (reset-round-state)
      (set! hint-level 0)
      (set! show-answer? #f)
      (set! audio-said? #f))

    ;; ----------------------------------------

    (define/override (on-char ke)
      (define key (send ke get-key-code))
      (cond [(or (send ke get-alt-down) (send ke get-control-down))
             (super on-char ke)]
            [(or (char? key) (memq key '(left right up down home end escape)))
             (handle-key key)]
            [else (super on-char ke)]))

    (define/public (handle-key key)
      (case key
        ;; Local changes
        [(#\h) (set! hint-level (add1 hint-level))]
        [(#\r) (set! audio-said? #f)]
        ;; Navigation
        [(left #\backspace)
         (cond [show-answer?
                (set! audio-said? #f)
                (set! show-answer? #f)]
               [else
                (prev-round)])]
        [(right #\space)
         (cond [show-answer?
                (next-round)]
               [else
                (set! audio-said? #f)
                (set! show-answer? #t)])]
        ;; FIXME/TODO: record right/wrong
        [else (void)])
      (on-state-change))

    (define/public (on-state-change)
      (refresh))

    (define/override (on-paint)
      (super on-paint)
      (define s (get-current))
      (when s
        (define dc (get-dc))
        (define qpict (empict (send s render-q hint-level)))
        (define apict
          (cond [show-answer? (empict (send s render-a hint-level))]
                [else (empict
                       (filled-rounded-rectangle
                        (- WIDTH 10) (- HEIGHT 10) -1/60
                        #:draw-border? #f #:color "lightgray"))]))
        (draw-pict qpict dc 0 0)
        (draw-pict apict dc WIDTH 0)
        (unless audio-said?
          (send audio say (if show-answer? (send s get-a-audio) (send s get-q-audio)))
          (set! audio-said? #t))))

    (define/private (empict p)
      (let ([bg (blank WIDTH HEIGHT)])
        (clip (refocus (cc-superimpose bg p) bg))))

    ))

(define mac-audio%
  (class object%
    (super-new)

    (define mutex (make-semaphore 1))
    (define cust (make-custodian))

    (define/public (say us)
      (call-with-semaphore mutex (lambda () (say* us))))
    (define/private (say* us)
      (custodian-shutdown-all cust)
      (set! cust (make-custodian))
      (parameterize ((current-custodian cust)
                     (current-subprocess-custodian-mode 'interrupt))
        (thread (lambda () (for ([u (in-list us)]) (say** u))))))

    (define/private (say** u)
      (match u
        [(? real?) (sleep u)]
        [(en-audio text) (system* "/usr/bin/say" "-v" "Susan" text)]
        [(cz-audio text) (system* "/usr/bin/say" "-v" "Zuzana" text)]))

    (define/public (say-en text)
      (thread (lambda () (system* "/usr/bin/say" "-v" "Susan" text))))
    (define/public (say-cz text)
      (thread (lambda () (system* "/usr/bin/say" "-v" "Zuzana" text))))

    (define/public (stop)
      (custodian-shutdown-all cust))

    ))

(define null-audio%
  (class object%
    (super-new)
    (define/public (say us) (void))
    (define/public (say-en t) (void))
    (define/public (say-cz t) (void))
    ))

(define (run-gui rounds #:audio? [audio? #t])
  (define f (new frame% (label "Flashcard")))
  (define c (new flashcard-canvas% (parent f)
                 (audio (case (and audio? (system-type 'os))
                          [(macosx) (new mac-audio%)]
                          [else (new null-audio%)]))
                 (min-width (* 2 WIDTH))
                 (min-height HEIGHT)
                 (rounds rounds)))
  (send f show #t))

;; ============================================================
;; Slideshow config and helpers

(current-font-size 28)
(current-para-width (- WIDTH 50))

;; Serif:
;; -- BAD: Book Antiqua, Bookman Old Style, Garamond, Goudy Old Style, Lucida Bright
;; (current-main-font "Cambria") ;; ok
;; (current-main-font "Century") ;; ok
;; (current-main-font "Constantia") ;; ok
;; (current-main-font "Palatino")  ;; good
;; (current-main-font "Palatino Linotype")  ;; good

;; Sans serif:
;; -- BAD: Century Gothic, Gill Sans, Optima
;; (current-main-font "Candara") ;; ok
;; (current-main-font "Corbel") ;; ok, sans
;; (current-main-font "Futura") ;; ok, sans
;; (current-main-font "Geneva") ;; good
;; (current-main-font "Helvetica") ;; ok
;; (current-main-font "Lucida Sans Unicode") ;; good
;; (current-main-font "Tahoma") ;; good!
(current-main-font "Verdana") ;; good!!

;; Monospaced:
;; (current-main-font "Consolas") ;; ok -- fixed width


(define (panel . args)
  (apply vc-append 10 (filter values (flatten args))))

(define (ifp ? p) (if ? p (blank)))

(define (tl p) (colorize p "lightblue"))
(define (tlt s) (tl (if s (it s) (blank))))

(define (c:cz p) (colorize p "darkblue"))
(define (c:en p) (colorize p "darkred"))

;; ============================================================

(define QA-base%
  (class* object% (QA<%>)
    (super-new)
    (define/public (render-q hint-level)
      (get-q-pict (lambda (level p) (if (>= hint-level level) p (ghost p)))))
    (define/public (render-a hint-level)
      (get-a-pict (lambda (level p) (if (>= hint-level level) p (ghost p)))))
    (abstract get-q-pict)
    (abstract get-a-pict)
    (define/public (get-q-audio) null)
    (define/public (get-a-audio) null)
    ))

(define QA%
  (class QA-base%
    (init-field q-pict q-audio a-pict a-audio)
    (super-new)
    (define/override (render-q hint-level) q-pict)
    (define/override (render-a hint-level) a-pict)
    (define/override (get-q-audio) q-audio)
    (define/override (get-a-audio) a-audio)
    ))

;; ----------------------------------------

(define img=>cz%
  (class QA-base%
    (init-field img word [word-tl #f])
    (super-new)
    (define/override (get-q-pict hint)
      (panel (para "Co je to?" (hint 1 (tlt " What is this?")))
             (blank 20) img))
    (define/override (get-a-pict hint)
      (panel (para word)
             (hint 1 (para (tlt word-tl)))))
    (define/override (get-q-audio) (list (cz-audio "Co je to?")))
    (define/override (get-a-audio) (list (cz-audio word)))
    ))

(define en=>cz%
  (class QA-base%
    (init-field en-phrase cz-phrase [pretty-type #f])
    (super-new)
    (define/override (get-q-pict hint)
      (panel (para "Jak se řekne ...?"
                   (hint 1 (tlt " How do you say ...?")))
             (c:en (para en-phrase))
             (blank)
             (and pretty-type (para (it (format "(~a)" pretty-type))))))
    (define/override (get-a-pict hint)
      (panel (c:cz (para cz-phrase))))
    (define/override (get-q-audio)
      (list (cz-audio "Jak se řekne?") (en-audio en-phrase)))
    (define/override (get-a-audio)
      (list (cz-audio cz-phrase)))))

(define cz=>en%
  (class QA-base%
    (init-field cz-phrase en-phrase [pretty-type #f])
    (super-new)
    (define/override (get-q-pict hint)
      (panel (para "Co znamená ...?" (hint 1 (tlt " What does ... mean?")))
             (c:cz (para cz-phrase))
             (blank)
             (and pretty-type (para (it (format "(~a)" pretty-type))))))
    (define/override (get-a-pict hint)
      (panel (c:en (para en-phrase))))
    (define/override (get-q-audio)
      (list (cz-audio "Co znamená?") (cz-audio cz-phrase)))
    (define/override (get-a-audio)
      (list (en-audio en-phrase)))))

(define conj%
  (class QA-base%
    (init-field infinitive subject verb [inf-tl #f])
    (super-new)
    (define/override (get-q-pict hint)
      (panel (para "Konjugujte" (c:cz (it infinitive))
                   (blank 5)
                   (hint 1 (tlt (and inf-tl (format "Conjugate 'to ~a'" inf-tl)))))
             (para (c:cz (t subject)) " ...")))
    (define/override (get-a-pict hint)
      (c:cz (para (format "~a ~a" subject verb))))
    (define/override (get-q-audio)
      (list (cz-audio (format "Konjugujte ... ~a" infinitive))
            1/3 (cz-audio subject)))
    (define/override (get-a-audio)
      (list (cz-audio (format "~a ~a" subject verb))))))

;; ----------------------------------------

(define (toCZ en-phrase cz-phrase pretty-type)
  (new en=>cz% (en-phrase en-phrase) (cz-phrase cz-phrase) (pretty-type pretty-type)))

(define (toEN cz-phrase en-phrase pretty-type)
  (new cz=>en% (cz-phrase cz-phrase) (en-phrase en-phrase) (pretty-type pretty-type)))

(define (ENCZ en-phrase cz-phrase pretty-type)
  (list (toCZ en-phrase cz-phrase pretty-type)
        (toEN cz-phrase en-phrase pretty-type)))

(define (Conj inf subj verb #:vtl [inf-tl #f])
  (new conj% (infinitive inf) (subject subj) (verb verb) (inf-tl inf-tl)))

(define (jazyk->qas sections
                    #:adj-forms adj-forms
                    #:verb-forms verb-forms)
  (define cz:grammar (new cz:cz-grammar% (jazyk sections)))
  (flatten
   (for*/list ([s (in-list sections)]
               [e (in-list (section-entries s))] #:when (translation? e))
     (match-define (translation lhs en) e)
     (match lhs
       [(? adj?)
        (for/list ([af (in-list adj-forms)])
          (define cz* (send cz:grammar decline-adj lhs 'nom af 's))
          (define en* (send en:grammar decline-adj (adj en) 'nom af 's))
          ;; FIXME: describe-adj-form?
          (cond [(and cz* en*)
                 (list (toCZ en* cz* (format "adjective, ~s" af))
                       (toEN cz* en* (pretty-type lhs)))]
                [else null]))]
       [(? verb?)
        (define en-v (send en:grammar lookup en 'verb))
        (for/list ([vf (in-list verb-forms)])
          (define cz* (send cz:grammar conjugate-verb lhs vf))
          (define en* (and en-v (send en:grammar conjugate-verb en-v vf)))
          (cond [(and cz* en*)
                 (list (toCZ en* cz* (describe-verb-form vf))
                       (toEN cz* en* "verb"))]
                [else null]))]
       [(verb-phrase cz-str)
        (for/list ([vf (in-list verb-forms)])
          (define cz* (send cz:grammar conjugate-verb-phrase lhs vf))
          (define en* (send en:grammar conjugate-verb-phrase (verb-phrase en) vf))
          (cond [(and cz* en*)
                 (list (toCZ en* cz* (describe-verb-form vf))
                       (toEN cz* en* "verb phrase"))]
                [(eq? vf 'inf) (ENCZ en cz-str (pretty-type lhs))]
                [else null]))]
       [(word cz) (ENCZ en cz (pretty-type lhs))]
       [(phrase cz) (ENCZ en cz (pretty-type lhs))]
       [_ null]))))

;; ============================================================

;; TODO:
;; - add disambiguation hints (eg: "doctor" needs m vs f to disambiguate)
;; - show all correct answers (eg: "doctor (m)" -> "doktor" and "lekař")
;; - split aux info into *disambiguating* (part of Q) vs not (part of A)

;; TODO: Command-line options
;; - mode: verb conjugation practice
;; - add f,n forms of adjectives

;; This indirection is necessary because the slideshow library reads
;; the command-line arguments to initialize its parameters. (!!!!)
(module run racket/base
  (require racket/lazy-require)
  (lazy-require [(submod ".." run*) [run/argv]])
  (provide run)
  (define (run jazyk)
    (let ([argv (current-command-line-arguments)])
      (parameterize ((current-command-line-arguments (vector)))
        (run/argv jazyk argv)))))

(module+ run*
  (require racket/cmdline)
  (provide run/argv)

  (define (fatal fmt . args)
    (apply raise-user-error 'jazyk fmt args))

  (define (run/argv jazyk argv)
    ;; Options, mutated below
    (define audio? #t)
    (define shuffle? #t)
    (define ncards 50)
    (define verb-forms '(inf 1s 2s 3s 1p 2p 3p ppart))
    (define adj-forms '(m f n))

    (command-line
     #:argv argv
     #:once-each
     [("--no-audio")
      "No audio, even when available."
      (set! audio? #f)]
     [("--no-shuffle")
      "Don't shuffle the cards."
      (set! shuffle? #f)]
     [("-n" "--number")
      number-of-cards
      "Set maximum number of cards to generate."
      (let ([n (string->number number-of-cards)])
        (unless (exact-nonnegative-integer? n)
          (fatal "expected nonnegative integer for number of cards, given: ~e" number-of-cards))
        (set! ncards n))]
     [("--adj-forms")
      adj-form-list
      "Include the given adjective forms."
      (let ([afs (map string->symbol (string-split adj-form-list ","))])
        (for ([af (in-list afs)]) (unless (gender? af) (fatal "expected gender, given: ~s" af)))
        (set! adj-forms afs))]
     [("--verb-forms")
      verb-form-list
      "Include the given verb forms."
      (let ([vfs (map string->symbol (string-split verb-form-list ","))])
        (for ([vf (in-list vfs)]) (unless (verb-form? vf) (fatal "expected verb form, given: ~s" vf)))
        (set! verb-forms vfs))]
     #:args ()
     (parameterize ((current-command-line-arguments (vector)))
       (let* ([qas (jazyk->qas jazyk #:verb-forms verb-forms #:adj-forms adj-forms)]
              [qas (if shuffle? (shuffle qas) qas)])
         (run-gui (list->vector (take qas (min ncards (length qas))))
                  #:audio? audio?))))))
