#lang racket

(require racket/list
         "../core.rkt")

#|

VALUES

URL: https://pull-stream.github.io/#values

create a SourceStream that reads the values from an array or object and then stops.
|#

(define (pull/values arr)
    (define a arr)
    (define/source pull-source
      ;; iterator, called multiple times.
      (lambda () (begin
                   (define f (car a))
                   (set! a (cdr a))
                   f))
      ;; iterator-checker: called to see if iterator should be over.
      (lambda () (null? a)))
  pull-source)
                 

(provide pull/values)
