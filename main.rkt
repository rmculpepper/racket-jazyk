#lang racket/base
(require (for-syntax racket/base syntax/parse)
         "language/base.rkt")
(provide (rename-out [module-begin #%module-begin])
         (except-out (all-from-out racket/base) #%module-begin)
         (all-from-out "language/base.rkt"))

(module reader syntax/module-reader jazyk)

;; ============================================================

(begin-for-syntax

  (define-splicing-syntax-class section
    #:attributes ([def 1] ast)
    (pattern (~seq #:definitions d:expr ...)
             #:with (def ...) #'(d ...)
             #:with ast #'(list))
    (pattern (~seq #:section name:string p:part ...)
             #:with (def ...) null
             #:with ast #'(list (section 'name (append p.ast ...)))))

  (define-splicing-syntax-class part
    #:attributes (ast)
    (pattern (~seq #:escape e:expr ...)
             #:with ast #'(list e ...))
    (pattern (~seq #:words k:id e:elem ...)
             #:with ast #'(list (k e.ast) ...))
    (pattern (~seq #:translate k:id e:entry ...)
             #:with ast #'(list (translation (k e.lhs.ast) e.rhs.ast) ...)))

  (define-splicing-syntax-class entry
    #:attributes (lhs.ast rhs.ast)
    (pattern (~seq lhs:elem rhs:elem)))

  (define-syntax-class elem #:opaque
    #:attributes (ast) #:literals (unquote)
    (pattern (unquote ~! e:expr)
             #:with ast #'e)
    (pattern t:expr  ;; any other non-keyword term
             #:with ast #'(convert (quote t))))

  )

(define-syntax module-begin
  (syntax-parser
    [(_ s:section ...)
     #'(#%plain-module-begin
        (provide jazyk)
        s.def ... ...
        (define jazyk (append s.ast ...))
        (module* main #f
          (#%plain-module-begin
           (require (submod jazyk/view/gui run))
           (run jazyk))))]))

(define (convert x)
  (cond [(pair? x) (cons (convert (car x)) (convert (cdr x)))]
        [(symbol? x) (symbol->string x)]
        [else x]))
