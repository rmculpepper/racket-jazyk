# racket-jazyk

## To Install

You need a relatively recent release of Racket.

```
git clone https://github.com/rmculpepper/racket-jazyk
raco pkg install --link --name jazyk ./racket-jazyk
```

## To Run

To start the jazyk GUI, run `cz-example.rkt` as a Racket script with the argument `gui`:

```
$ racket cz-example.rkt gui
```

You can see customization options by passing the `-h` flag:

```
$ racket cz-example.rkt gui -h
```
