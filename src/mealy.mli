(** Continuous automaton which emits observable values only upon state
    transition. Mealy machines cannot be distinguished until they are
    fed more input. *)

type (-'a, +'b, 's) spec =
  { state : 's
  ; step  : 'a -> 's -> 'b * 's
  }

type (-_, +_) t

val make : ('a, 'b, 's) spec -> ('a, 'b) t

include Sigs.Covariant1   with type ('a, 'b) t := ('a, 'b) t
include Sigs.Applicative1 with type ('a, 'b) t := ('a, 'b) t
include Sigs.Profunctor   with type ('a, 'b) t := ('a, 'b) t
include Sigs.Choice       with type ('a, 'b) t := ('a, 'b) t
include Sigs.Strong       with type ('a, 'b) t := ('a, 'b) t
include Sigs.Category     with type ('a, 'b) t := ('a, 'b) t
include Sigs.Supercat     with type ('a, 'b) t := ('a, 'b) t

(* include Exponential  with type ('a, 'b) t := ('a, 'b) t *)
(* Technically there is an Exponential instance, but it leaks
   space. *)
