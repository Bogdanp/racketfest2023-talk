#lang racket/base

(require noise/serde)

(define-record Human
  [name : String]
  [age : UVarint])
