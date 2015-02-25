open Types

type (-'a, +'b, 's) spec =
  { state   : 's
  ; project : 's -> 'b
  ; step    : 'a -> 's -> 's
  } 

type (-_, +_) t = Ex : ('a, 'b, 's) spec -> ('a, 'b) t

let make spec = Ex spec

let dimap f g (Ex m) =
  let project s = g (m.project s) in
  let step a s  = m.step (f a) s in
  Ex { m with project; step }

let map g = dimap (fun x -> x) g
let cap f = dimap f (fun x -> x)

let pure a = 
  let state = () in
  let project _ = a in
  let step _ s = s in
  Ex { state; project; step }

let ap (Ex mf) (Ex mx) =
  let state = (mf.state, mx.state) in
  let project (sf, sx) = mf.project sf (mx.project sx) in
  let step a (sf, sx) = (mf.step a sf, mx.step a sx) in
  Ex { state; project; step }

let extract (Ex m) = m.project m.state

let extend f (Ex m) =
  let project s = f (Ex {m with state = s}) in
  Ex { m with project }

let left (Ex m) =
  let open Sum.Left in
  let state = pure m.state in
  let project es = map m.project es in
  let step ea es = ap (map m.step ea) es in
  Ex { state; project; step } 

let right (Ex m) =
  let open Sum.Right in
  let state = pure m.state in
  let project es = map m.project es in
  let step ea es = ap (map m.step ea) es in
  Ex { state; project; step }
