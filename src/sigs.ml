open Types

module type Covariant1 = sig
  type ('a, +'b) t
  val map : ('b -> 'b_) -> ('a, 'b) t -> ('a, 'b_) t
end

module type Applicative1 = sig
  include Covariant1
  val pure : 'a -> ('e, 'a) t
  val ap : ('e, 'a -> 'b) t -> (('e, 'a) t -> ('e, 'b) t)
end

module type Monad1 = sig
  include Applicative1
  val bind : ('a -> ('e, 'b) t) -> (('e, 'a) t -> ('e, 'b) t)
end

module type Comonad1 = sig
  include Covariant1
  val extract : ('e, 'a) t -> 'a
  val extend : (('e, 'a) t -> 'b) -> (('e, 'a) t -> ('e, 'b) t)
end

module type BiCovariant = sig
  type (+'a, +'b) t
  val bimap : ('a -> 'a_) -> ('b -> 'b_) -> (('a, 'b) t -> ('a_, 'b_) t)
end

module type Profunctor = sig
  type (-'a, +'b) t
  val dimap : ('a_ -> 'a) -> ('b -> 'b_) -> ('a, 'b) t -> ('a_, 'b_) t
end

module type Strong = sig
  include Profunctor
  val first  : ('a, 'b) t -> ('a * 'x, 'b * 'x) t
  val second : ('a, 'b) t -> ('x * 'a, 'x * 'b) t
end

module type Choice = sig
  include Profunctor
  val left  : ('a, 'b) t -> (('a, 'x) Sum.t, ('b, 'x) Sum.t) t
  val right : ('a, 'b) t -> (('x, 'a) Sum.t, ('x, 'b) Sum.t) t
end

module type Category = sig
  type (-'a, +'b) t
  val id : ('a, 'a) t
  val ( @> ) : ('a, 'b) t -> ('b, 'c) t -> ('a, 'c) t
  val ( <@ ) : ('b, 'c) t -> ('a, 'b) t -> ('a, 'c) t
end

module type Supercat = sig
  type (-'a, +'b) t
  val arrow : ('a -> 'b) -> ('a, 'b) t
  include Category   with type ('a, 'b) t := ('a, 'b) t
  include Profunctor with type ('a, 'b) t := ('a, 'b) t
  (** [Category] and [arrow] are sufficient to prove Profunctor. *)
end

module type Exponential = sig
  include Category
  val apply : (('a, 'b) t * 'a, 'b) t
end
