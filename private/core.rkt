#lang racket

;; Docs on pull-stream canonical JS implementation: https://pull-stream.github.io/

(require threading)

#|
Source (readable stream that produces values)

A Source is a function read(end, cb), that may be called many times, and will (asynchronously) call cb(null, data) once for each call.

To signify an end state, the stream eventually returns cb(err) or cb(true). When signifying an end state, data must be ignored.

The read function must not be called until the previous call has called back. Unless, it is a call to abort the stream (read(Error || true, cb)).

## Macro to create sources.

Sources are made from two functions, one is the callback that is called in a loop, the other is a predicate function to check is the process is over.

I'm calling them "iterator" and "iterator-checker", not the best naming convention, I know.
|#

(define-syntax define/source
  (syntax-rules ()
    ((_ source-name fn-iterator fn-iterator-checker)
     (define (source-name end cb)
       (cond
         [end (cb end)]
         [(fn-iterator-checker) (cb #t)]
         [else (cb #f (fn-iterator))])))))

#|
Through

A through stream is both a reader (consumes values) and a readable (produces values). 
It's a function that takes a read function (a Sink), and returns another read function (a Source).

// double is a through stream that doubles values.
function double (read) {
  return function readable (end, cb) {
    read(end, function (end, data) {
      cb(end, data != null ? data * 2 : null)
    })
  }
}

pull(createRandomStream(5), double, logger)
|#

(define-syntax define/through
  (syntax-rules ()
    ((_ through-name fn) (define (through-name read)
                           (lambda (end cb)
                             (read end (lambda (end1 [data #f])
                                           (cb end1 (if (false? data) #f (fn data))))))))))

#|
Sink (reader or writable stream that consumes values)

A Sink is a function reader(read) that calls a Source (read(null, cb)), 
until it decides to stop (by calling read(true, cb)), or the readable ends (read calls cb(Error || true))

All Throughs and Sinks are reader streams.

## Macro to create sinks.

Sinks receive a single function in the form of (lambda (data)).
|#

(define-syntax define/sink
  (syntax-rules ()
    ((_ sink-name fn) (define (sink-name read)
                        (define (next end [data #f])
                          (cond
                            [end #t]
                            [else (begin
                                    (fn data)
                                    (read #f next))]))
                        (read #f next)))))

#|
a little "pull" macro just for the sake of completeness and ease of reading.
|#

(define-syntax pull~>
  (syntax-rules ()
    ((_ a ...) (~> a ...))))

(provide (all-defined-out))

