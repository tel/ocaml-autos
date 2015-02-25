open Types

type (-'a, +'b, 's) spec =
  { state : 's
  ; step  : 'a -> 's -> 'b * 's
  }

type (-_, +_) t = Ex : ('a, 'b, 's) spec -> ('a, 'b) t

let make spec = Ex spec

let dimap f g (Ex m) =
  let step a s = Product.lmap g (m.step (f a) s) in
  Ex { m with step }

let lmap f = dimap f (fun x -> x)
let rmap f = dimap (fun x -> x) f
let map f = rmap f

let pure b =
  let step _ s = (b, s) in
  let state = () in
  Ex { step; state }

let ap (Ex mf) (Ex mx) =
  let state = (mf.state, mx.state) in
  let step a (sf, sx) = begin
    let (f, sf) = mf.step a sf in
    let (x, sx) = mx.step a sx in
    (f x, (sf, sx))
  end in
  Ex { step; state }

let left (Ex m) =
  let step ea s = match ea with
    | Sum.Inl a -> 
      Product.lmap (fun x -> Sum.Left.pure x) (m.step a s)
    | Sum.Inr x -> (Sum.Inr x, s)
  in Ex { m with step }

let right (Ex m) =
  let step ea s = match ea with
    | Sum.Inl x -> (Sum.Inl x, s)
    | Sum.Inr a ->
      Product.lmap (fun x -> Sum.Right.pure x) (m.step a s)
  in Ex { m with step }

let first (Ex m) =
  let step (a, x) s = begin
    let (b, s) = m.step a s in
    ((b, x), s)
  end in
  Ex { m with step }

let second (Ex m) =
  let step (x, a) s = begin
    let (b, s) = m.step a s in
    ((x, b), s)
  end in
  Ex { m with step }

let arrow f = let step a s = (f a, s) in Ex { step; state = () }

let id = let step a s = (a, s) in Ex { step; state = () }

let ( @> ) (Ex m1) (Ex m2) =
  let state = (m1.state, m2.state) in
  let step a (s1, s2) = begin
    let (x, s1) = m1.step a s1 in
    let (b, s2) = m2.step x s2 in
    (b, (s1, s2))
  end in
  Ex { step; state }

let ( <@ ) (Ex m2) (Ex m1) =
  let state = (m1.state, m2.state) in
  let step a (s1, s2) = begin
    let (x, s1) = m1.step a s1 in
    let (b, s2) = m2.step x s2 in
    (b, (s1, s2))
  end in
  Ex { step; state }
