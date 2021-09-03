#lang racket

(require "../core.rkt")

#|

Like [].filter(function (data) {return true || false}) only data where test(data) == true are let through to the next stream.

URL: https://pull-stream.github.io/#filter

|#

(define (pull/filter predicate)
  (lambda (read)
    (lambda (end cb)
      (let loop ()
        (define keep-looking #f)
        (read end (lambda (end1 [data #f])
                    (if end1
                        (cb end1 data)
                        (if (not (predicate data))
                            (set! keep-looking #t)
                            (cb end1 data)))))
                    
        (if keep-looking
          (loop)
          (cb #t #f))))))

(provide pull/filter)
                               
                               
                           
                       
         

                          
                	
