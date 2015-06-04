heap-visualization
==================

A d3.js visualization for Binary Heaps.

Uses a partial port of the Python
[heapq module](http://docs.python.org/library/heapq.html) extended to
fire events.

<img src="screenshot.png?raw=true" alt="" width=600>

### Development

Build `heap-vis.js`:

`npm run-script build-browser`

And run a simple file server with:

`python -m SimpleHTTPServer` or `python3 -m http.server`

Build docs:

`npm run-script docs`

### TODO:

* test evented Heap
* test visualization in browsers

* When a viewer clicks a value at the top of the page
 * it should fade value into heap tree as node then animate any heap sifting

* show how heap is stored as an array
* Extract min/max
* Delete node from center of heap
* min and max heaps (change sort order or modified comparator, getter, setter)

* Add text
 * Analogy to a funnel for explaining it? Similar to quantized energy
   levels of harmonic potential?
 * Application examples: tournaments, sequencers?
 * Add Leftist, Skew, and Binomial heaps?

* Heapq
 * implement rest of heapq module: heapify, heappushpop, nlargest, etc.

 * Handle deleted array entries in heapify?
 * Handle NaN, or Infinities?
 * Shift right with sign for `>>` unsigned typedArrays or node buffers?
