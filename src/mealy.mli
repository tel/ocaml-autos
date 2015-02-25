open Sigs

type (-'a, +'b, 's) spec =
  { state : 's
  ; step  : 'a -> 's -> 'b * 's
  }

type (-_, +_) t

val make : ('a, 'b, 's) spec -> ('a, 'b) t

include Covariant1   with type ('a, 'b) t := ('a, 'b) t
include Applicative1 with type ('a, 'b) t := ('a, 'b) t
include Profunctor   with type ('a, 'b) t := ('a, 'b) t
include Choice       with type ('a, 'b) t := ('a, 'b) t
include Strong       with type ('a, 'b) t := ('a, 'b) t
include Category     with type ('a, 'b) t := ('a, 'b) t
include Supercat     with type ('a, 'b) t := ('a, 'b) t

(* include Exponential  with type ('a, 'b) t := ('a, 'b) t *)
(* Technically there is an Exponential instance, but it leaks
   space. *)
