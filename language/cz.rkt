#lang racket/base
(require "base.rkt")
(provide (all-defined-out))

(struct noun-phrase translation () #:transparent)

(struct adj-base translation () #:transparent)
(struct adj/i adj-base () #:transparent)
(struct adj/y adj-base () #:transparent)

(define (adjective cz rhs)
  (cond [(regexp-match #rx"^.*ý$" cz)
         (adj/y cz rhs)]
        [(regexp-match #rx"^.*í$" cz)
         (adj/i cz rhs)]
        [else (error 'adjective "irregular adjective: ~e" cz)]))
