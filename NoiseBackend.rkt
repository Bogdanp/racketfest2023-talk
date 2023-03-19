#lang racket/base

(require noise/backend
         noise/serde)

(define-record Human
  [name : String]
  [age : UVarint])

(define-rpc (find-human [named name : String] : (Optional Human))
  (void))
