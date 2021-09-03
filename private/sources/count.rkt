#lang racket

(require racket/list
         "../core.rkt"
         "values.rkt")

#|

COUNT

URL: https://pull-stream.github.io/#count

create a stream that outputs 0 ... max. by default, max = Infinity, see take
|#

(define (pull/count max)
    (pull/values (build-list max values)))
                 

(provide pull/count)
