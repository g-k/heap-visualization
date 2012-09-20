heapq.coffee
============

A port of Python [heapq module](http://docs.python.org/library/heapq.html)
from its [source file](http://hg.python.org/cpython/file/2.7/Lib/heapq.py).

### Installing

As a node module:

`npm install `

### Development

Run tests:

`npm test`

Build docs:

`npm run-script docs`

### TODO:

* test in browsers
* implement rest of module: heapify, heappushpop, nlargest, etc.

* Handle deleted array entries in heapify?
* Handle NaN, or Infinities?
* Shift right with sign for `>>` unsigned typedArrays or node buffers?

* Analogy to a funnel for explaining it? Similar to quantized energy levels of harmonic potential?
* Applications: tournaments, sequencers?
* Tie into D3 for visualizing heaps?
* Leftist, Skew, Binomial heaps?
