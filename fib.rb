def fib n
  if n < 3
    1
  else
    fib(n-1) + fib(n-2)
  end
end

benchmark { fib(31) }

benchmark 'fib34' do
  fib(34)
end
