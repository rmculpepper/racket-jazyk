# racket-jazyk

## To Install

You need a relatively recent release of Racket.

```
git clone https://github.com/rmculpepper/racket-jazyk
raco pkg install --link --name jazyk ./racket-jazyk
```

## To Run

Start Racket (`racket`) in the `racket-jazyk` directory.

```
> (require "cz-example.rkt")
;; prints some warnings
> jazyk
;; prints a big list of "translations"
```
