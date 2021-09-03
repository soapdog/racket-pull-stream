#lang racket

(require "../core.rkt")

#|


filterNot = require('pull-stream/throughs/filter-not')
filterNot(test)

Like filter, but remove items where the filter returns true.

URL: https://pull-stream.github.io/#filter-not

|#

(define (pull/filter-not predicate)
  (lambda (read)
    (lambda (end cb)
      (let loop ()
        (define keep-looking #f)
        (read end (lambda (end1 [data #f])
                    (if end1
                        (cb end1 data)
                        (if (not (not (predicate data)))
                            (set! keep-looking #t)
                            (cb end1 data)))))
                    
        (if keep-looking
          (loop)
          (cb #t #f))))))

(provide pull/filter-not)
                               
                               
                           
                       
         

                          
                	
