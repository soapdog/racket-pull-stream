#lang racket

(require racket/list
         "../core.rkt"
         "values.rkt")

#|

ONCE

URL: https://pull-stream.github.io/#once

stream with a single value.
|#

(define (pull/once n)
    (pull/values (list n)))
                 

(provide pull/once)
