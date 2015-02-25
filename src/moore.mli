(** Continuous automaton which has observable values in each
    state. Unlike {!Mealy.t}, Moore machines have a notion of the
    current observable state witnessed by {!Comonad1.extract}. *)

type (-'a, +'b, 's) spec =
  { state   : 's
  ; project : 's -> 'b
  ; step    : 'a -> 's -> 's
  } 

type (-'a, +'b) t

val make : ('a, 'b, 's) spec -> ('a, 'b) t

include Sigs.Covariant1   with type ('a, 'b) t := ('a, 'b) t
include Sigs.Applicative1 with type ('a, 'b) t := ('a, 'b) t
include Sigs.Comonad1     with type ('a, 'b) t := ('a, 'b) t
include Sigs.Profunctor   with type ('a, 'b) t := ('a, 'b) t
include Sigs.Choice       with type ('a, 'b) t := ('a, 'b) t
