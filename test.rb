def fib n
  if n < 3
    1
  else
    fib(n-1) + fib(n-2)
  end
end

benchmark 'fib(34)' do
  fib(34)
end

benchmark do
  fib(31)
end

benchmark { fib(30) }

benchmark('29') { fib(29) }

benchmark('fib 28') {
  1.times { fib(28) }
}
