Autos—Infinite state automatons
===============================

Theory
------

Mealy and Moore machines can be seen as the fixed points of indexed
state and indexed costate (e.g. "store") types.

```ocaml
type (-'i, +'j, +'a) istate = 'i -> ('a, 'j)
type (-'i, +'j, +'a) istore = ('i -> 'a) * 'j

type (-'a, +'b) mealy = Mealy of ('a, 'b, ('a, 'b) mealy)) istate
type (-'a, +'b) moore = Moore of ('a, 'b, ('a, 'b) moore)) istore
```

However, we can achieve a more efficient representation by taking the
explicit greatest fixed point via an existential type instead of using
type recursion. In a pretend OCaml which has higher-kinded types and
type lambdas

```ocaml
type _ mu = Mu : 'x * ('x -> 'x 'f) -> 'f mu

type (-'a, +'b) mealy = ('a, 'b, _) istate mu
type (-'a, +'b) moore = ('a, 'b, _) istore mu
```

or, written out explicitly

```ocaml
type (-_, +_) mealy =
  Mealy : 's * ('a -> 's -> 'b * 's) -> ('a, 'b) mealy

type (-_, +_) moore =
  Moore : 's * ('s -> 'b) * ('a -> 's -> 's) -> ('a, 'b) moore
```
