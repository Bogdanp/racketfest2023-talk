import Noise

let r = Racket()
r.bracket {
  r.load(zo: "/path/to/app.zo")
  let mod = Val.cons(Val.symbol("quote"), Val.cons(Val.symbol("fib"), Val.null))
  let fib = r.require(Val.symbol("fib"), from: mod).car()!
  let n = fib.apply(Val.cons(Val.fixnum(8), Val.null))!.car()!.fixnum()
  print("fib(8) = \(n)")
}
