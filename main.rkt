#lang racket/base

(module+ test
  (require rackunit))

;; Notice
;; To install (from within the package directory):
;;   $ raco pkg install
;; To install (once uploaded to pkgs.racket-lang.org):
;;   $ raco pkg install <<name>>
;; To uninstall:
;;   $ raco pkg remove <<name>>
;; To view documentation:
;;   $ raco docs <<name>>
;;
;; For your convenience, we have included LICENSE-MIT and LICENSE-APACHE files.
;; If you would prefer to use a different license, replace those files with the
;; desired license.
;;
;; Some users like to add a `private/` directory, place auxiliary files there,
;; and require them in `main.rkt`.
;;
;; See the current version of the racket style guide here:
;; http://docs.racket-lang.org/style/index.html

;; Code here

(require "private/core.rkt"
         "private/sources/values.rkt"
         "private/sources/count.rkt"
         "private/throughs/filter.rkt"
         "private/throughs/filter-not.rkt")

(provide (all-from-out "private/core.rkt")
         (all-from-out "private/sources/values.rkt")
         (all-from-out "private/sources/count.rkt")
         (all-from-out "private/throughs/filter.rkt")
         (all-from-out "private/throughs/filter-not.rkt"))



(module+ test
  ;; Any code in this `test` submodule runs when this file is run using DrRacket
  ;; or with `raco test`. The code here does not run when this file is
  ;; required by another module.

  (check-equal? (+ 2 2) 4))

(module+ main
  ;; (Optional) main submodule. Put code here if you need it to be executed when
  ;; this file is run using DrRacket or the `racket` executable.  The code here
  ;; does not run when this file is required by another module. Documentation:
  ;; http://docs.racket-lang.org/guide/Module_Syntax.html#%28part._main-and-test%29

  #|
  Example of a random source that displays 5 random numbers between 0 and 50.
  |#

  (define n 5)

  (define/source random-source
    ;; iterator, called multiple times.
    (lambda () (begin
                 (set! n (- n 1))
                 (random 50)))
    ;; iterator-checker: called to see if iterator should be over.
    (lambda () (>= 0 n)))

  (define/through double-through
    (lambda (data) (* data 2)))

  (define/through logger-through
    (lambda (data) (begin
                     (displayln (format "data: ~a" data))
                     data)))


  (define/through original-number-logger
    (lambda (data) (begin
                     (println (format "original number: ~a" data))
                     data)))

  (define/sink logger-sink
    (lambda (data) (println data)))

  ;; now pull!
  (displayln "-- 5 random numbers between 0 and 50 --")
  (pull~> random-source logger-sink)

  (set! n 5) ;; spent more than one hour debugging why define/through was not working. The problem was that I forgot to reset n so the random-source was already exhausted :-/
  (displayln "-- 5 random numbers between 0 and 50, doubled --")
  (pull~> random-source double-through logger-sink)

  (displayln "-- numbers from array doubled (pull/values) --")
  (pull~> (pull/values '(1 2 3)) double-through logger-sink)

  (displayln "-- numbers from array doubled (pull/count) --")
  (pull~> (pull/count 4) original-number-logger double-through logger-sink)

  (displayln "-- just odd numbers (pull/filter) --")
  (define just-odds (pull/filter (lambda (data) (odd? data))))
  (pull~> (pull/count 5) just-odds logger-sink)

  (displayln "-- just even numbers (pull/filter-not) --")
  (define just-even (pull/filter-not (lambda (data) (odd? data))))
  (pull~> (pull/count 5) just-even logger-sink) 
  )


