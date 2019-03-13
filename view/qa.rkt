#lang racket/base
(require racket/class)
(provide (all-defined-out))

;; A QA represents a question/prompt and an answer/response.
(define QA<%>
  (interface ()
    ;; abstract type Rendering, eg Pict, XExpr, ...
    ;; abstract type Audio
    ;; render-{q,a} take hint level as Nat.
    render-q    ;; Nat -> Rendering
    render-a    ;; Nat -> Rendering
    get-q-audio ;; Nat -> Audio
    get-a-audio ;; Nat -> Audio
    ))

;; A QA-Generator is (-> QA)
(define generator<%>
  (interface ()
    generate ;; -> QA
    ))

(define (generate g n)
  (for/vector ([i n]) (send g generate)))
