
open Sigs

type (-'a, +'b, 's) spec =
  { state   : 's
  ; project : 's -> 'b
  ; step    : 'a -> 's -> 's
  } 

type (-'a, +'b) t

val make : ('a, 'b, 's) spec -> ('a, 'b) t

include Covariant1   with type ('a, 'b) t := ('a, 'b) t
include Applicative1 with type ('a, 'b) t := ('a, 'b) t
include Comonad1     with type ('a, 'b) t := ('a, 'b) t
include Profunctor   with type ('a, 'b) t := ('a, 'b) t
include Choice       with type ('a, 'b) t := ('a, 'b) t
