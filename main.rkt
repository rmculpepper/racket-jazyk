#lang racket/base
(require (for-syntax racket/base syntax/parse)
         "language/base.rkt")
(provide (rename-out [module-begin #%module-begin])
         (except-out (all-from-out racket/base) #%module-begin)
         (all-from-out "language/base.rkt"))

(module reader syntax/module-reader jazyk)

;; ============================================================

(begin-for-syntax

  (define-syntax-class term #:opaque
    (pattern _:expr))

  ;; ----

  (define-splicing-syntax-class section
    #:attributes ([def 1] ast)
    (pattern (~seq #:definitions d:expr ...)
             #:with (def ...) #'(d ...)
             #:with ast #'(list))
    (pattern (~seq #:section name:string p:part ...)
             #:with (def ...) null
             #:with ast #'(list (section 'name (append p.ast ...)))))

  (define-splicing-syntax-class part
    (pattern (~seq #:escape e:expr ...)
             #:with ast #'(list e ...))
    (pattern (~seq #:kind k:kind e:entry ...)
             #:with ast #'(list (k.tx (elem 'e.lhs) (elem 'e.rhs)) ...)))

  (define-syntax-class kind
    (pattern tx:id))

  (define-splicing-syntax-class entry
    (pattern (~seq lhs:elem (~datum =) rhs:elem)))

  (define-syntax-class elem #:opaque
    (pattern (~and t:term (~not (~datum =)))))

  )

(define-syntax module-begin
  (syntax-parser
    [(_ s:section ...)
     #'(#%plain-module-begin
        (provide jazyk)
        s.def ... ...
        (define jazyk (append s.ast ...)))]))
