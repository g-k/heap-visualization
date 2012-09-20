log2 = (n) ->
  # http://graphics.stanford.edu/~seander/bithacks.html#IntegerLogObvious
  e = 0
  while true
    if not (n >>= 1)
      break
    e += 1
  e
