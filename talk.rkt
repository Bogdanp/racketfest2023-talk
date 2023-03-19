#lang slideshow/widescreen

;; Prelude ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require pict
         slideshow/code
         slideshow/text)

(set-margin! 20)
(current-main-font "Helvetica")
(current-code-font "Dank Mono")
(current-titlet
 (lambda (s)
   (colorize (title s)
             (current-title-color))))

(define (hexcolor n)
  (list
   (bitwise-and (arithmetic-shift n -16) #xFF)
   (bitwise-and (arithmetic-shift n  -8) #xFF)
   (bitwise-and (arithmetic-shift n   0) #xFF)))

(define-syntax-rule (define-color id s)
  (define-syntax-rule (id e)
    (colorize e (hexcolor s))))

(define-color white #xFFFFFF)
(define-color red #xBF0006)

(current-slide-assembler
 (let ([old (current-slide-assembler)])
   (lambda (t sep p)
     (define bg
       (inset (white (filled-rectangle 1360 766))
              (- margin)))
     (refocus (ct-superimpose bg (old t sep p)) bg))))

(define (title s)
  (bold (big (t s))))

(define-syntax-rule (code/small e0 e ...)
  (parameterize ([get-current-code-font-size (λ () 20)])
    (code e0 e ...)))

(slide
 #:name "title"
 (red (title "Native Apps With Racket"))
 (small (t "Bogdan Popa")))

(slide
 #:name "native?"
 (title "Native Applications?")
 'next
 (item "Using the system frameworks for building applications")
 'next
 (item "Applications that look & feel like system applications")
 'next
 (item "Access to all available widgets"))

(slide
 #:name "racket?"
 (title "With Racket?")
 'next
 (item "Want core logic to be portable between systems")
 'next
 (item "Want to use Racket"))

(slide
 #:name "approaches"
 (title "Approaches")
 'next
 (item (code racket/gui))
 'next
 (item "Embedding Racket as a subprocess")
 'next
 (item "Embedding Racket directly"))

(slide
 #:name "racket/gui"
 (title "racket/gui{,-easy}")
 'next
 (item "Built into Racket")
 'next
 (item "Supports a combination of native and custom widgets on Linux, macOS and Windows")
 'next
 (item "Downside: limited set of native widgets")
 'next
 (item "Downside: considerable effort to extend with more widgets"))

(slide
 #:name "embedding-via-subprocess"
 (title "Embedding as a Subprocess")
 'next
 (item "Application process starts a Racket subprocess, communicates using pipes")
 'next
 (item "Shipped an app using this approach to the Mac App Store")
 'next
 (item "Downside: memory use")
 'next
 (item "Downside: Racket code can't directly call application code"))

(slide
 #:name "embedding-in-code"
 (title "Embedding Directly")
 'next
 (item "Application runs Racket runtime in background thread, communicates using pipes")
 'next
 (subitem "Racket runtime schedules Racket threads as normal")
 'next
 (subitem "Racket server listens on pipe for requests, replies asynchronously")
 'next
 (item "Racket code and application code share an address space")
 'next
 (subitem "Racket code can call Swift procedures")
 'next
 (item "Downside: memory use")
 'next
 (subitem "Better than embedding via subprocess")
 'next
 (subitem "Still high because Racket and Chez kernels are large"))

(slide
 #:name "demo"
 (red (title "Demo"))
 (hc-append
  (vc-append
   (scale (bitmap "Franz1.png") 0.2)
   (scale (bitmap "Franz3.png") 0.2))
  (scale (bitmap "Franz2.png") 0.2)))

(slide
 #:name "stats"
 (title "Code Stats")
 (scale (bitmap "cloc.png") 0.5))

(slide
 #:name "implementation-0"
 (title "How it Works")
 'next
 (item "Racket CS built as a static library")
 'next
 (subitem "Linked directly into application executable")
 'next
 (item "Racket application code compiled to .zo")
 'next
 (subitem (code raco ctool --mods app.zo app.rkt))
 'next
 (item ".zo code shipped alongside application"))

(slide
 #:name "implementation-1"
 (title "How it Works (cont'd)")
 'next
 (item "On Application boot")
 'next
 (subitem "Start Racket runtime in background thread")
 'next
 (subitem "Load .zo code from Application bundle")
 'next
 (subitem "Require main procedure from .zo code")
 'next
 (subitem "Call main procedure with pipe file descriptors")
 'next
 (subitem "In Racket, turn fds into ports and read/write from/to them"))

(slide
 #:name "noise"
 (title "Noise")
 (small (title "github.com/Bogdanp/Noise"))
 'next
 (item "Swift/Racket libraries to abstract over this")
 'next
 (subitem "In future also C# for Windows")
 'next
 (item "Lowest layer implements" (code libracketcs) "interaction")
 'next
 (item "Next layer up implements protocol for communicating via pipes")
 'next
 (item "Layer above that implements serialization and deserialization"))

(slide
 #:name "noise-racket"
 (title "NoiseRacket")
 'next
 (item "Swift package that handles embedding" (code libracketcs))
 'next
 (scale (bitmap "NoiseRacket.png") 0.50))

(slide
 #:name "noise-serde"
 (title "NoiseSerde")
 'next
 (item "Racket macros & codegen")
 'next
 (ht-append
  20
  (vl-append
   20
   (code/small
    (require noise/serde)
    code:blank
    (define-record Human
      [name : String]
      [age : UVarint]))
   (code/small
    (make-Human #:name "Bogdan" #:age 30)
    (code:comment "(Human \"Bogdan\" 30)")))
  (scale (bitmap "NoiseSerde.png") 0.3)))

(slide
 #:name "noise-backend"
 (title "NoiseBackend")
 'next
 (item "Racket server to read/write from pipe")
 'next
 (item "Racket macros & codegen")
 'next
 (vc-append
  20
  (code/small
   (require noise/backend)
   code:blank
   (define-rpc (find-human [named name : String] : (Optional Human))
     ...))
  (scale (bitmap "NoiseBackend.png") 0.4)))

(slide
 #:name "performance"
 (title "Performance")
 'next
 (item "Low overhead")
 'next
 (subitem "RPC cost negligible")
 'next
 (subitem "Serde cost on the order of 1-100μs, depending on payload")
 'next
 (item "Overhead dwarfed by business logic (i.e. communicating with kafka)")
 'next
 (item "Easy to write highly concurrent code in Racket"))

(slide
 #:name "closing"
 (title "Closing Thoughts")
 'next
 (item "Very happy with this approach, will continue to write apps this way")
 'next
 (item "This is in users' hands")
 'next
 (item "Need to work on Windows support")
 'next
 (item "Electron a safer bet, but if you're feeling adventurous, give this a try"))

(slide
 #:name "fin"
 (title "Thanks!")
 (red (t "defn.io")))
