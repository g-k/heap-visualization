Heapq = require './heapq'

_ = require 'underscore'
Backbone = require 'backbone'
d3 = require 'd3'


log2 = (n) ->
  # http://graphics.stanford.edu/~seander/bithacks.html#IntegerLogObvious
  e = 0
  while true
    if not (n >>= 1)
      break
    e += 1
  e

# Override Heapq getter and setter to trigger events
Heapq.setter = (heap, index, value) ->
  heap.trigger 'set', index, value
  heap[index] = value

Heapq.getter = (heap, index) ->
  heap.trigger 'get', index
  heap[index]


# Add Backbone events to heap
heap = _.extend [], Backbone.Events,

  push: (item) ->
    @trigger 'push', item
    Array.prototype.push.call @, item

  pop: ->
    @trigger 'pop'
    Array.prototype.pop.call @


data =
  initial: [1, 3, 5, 7, 9, 2, 4, 6, 8]
  heap: heap


# Make an SVG element with margins
$g = do ->
  margin =
    left: 40
    right: 440
    top: 40
    bottom: 0

  outerHeight = 200
  step = 120
  width = 960 - margin.right
  height = outerHeight - margin.top - margin.bottom

  svg = d3.select('body').append('svg')
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .style("margin", "1em 0 1em " + -margin.left + "px")

# Scale values to Grayscale
scaleRGB = d3.scale.ordinal()
  .domain([d3.max(data.initial), d3.min(data.initial)])
  .range(colorbrewer.Blues['9'])


options = arrayOptions =
    leftPadding: 40.5
    topPadding: 40.5
    separation: 50
    boxHeight: 20
    boxWidth: 20
    text: (datum) -> datum
    textX: (datum, index) -> options.leftPadding+index * options.separation
    textY: (datum, index) -> options.topPadding
    x: (datum, index) -> options.leftPadding + index*options.separation
    y: 40.5


# Draw initial data array
# TODO: Use keys for object constancy properly
$g.selectAll('.data').data(data.initial, (d) -> d.value)
  .enter()
    .append('rect')
      .attr('class', 'data')
      .attr("x", options.x)
      .attr("y", options.y)
      .attr("height", options.boxHeight)
      .attr("width", options.boxWidth)
      .style("fill", (datum) -> scaleRGB datum)
      .style("stroke-width", "0px")


console.log d3.entries data.initial


data.heap.on 'all', => console.log arguments


drawHeapArray = ->
  # TODO: Use arguments to show more transitions

  $g.selectAll('rect.heap').data(data.heap)
    .transition()
      .duration(600)
      .attr("x", options.x)
      .attr("y", options.y + 50)
      # TODO: Instead of changing color it should move to the right spot
      .style("fill", (datum) -> scaleRGB datum)
      .attr('val', (d) -> d.toString())


pop = ->
  Heapq.heapPush data.heap, data.initial.pop()

  console.log data.initial, data.heap

  $g.selectAll('.data').data(data.initial)
    .exit()
      .attr('class', 'heap')

  drawHeapArray()

  if not _.isEmpty data.initial
    setTimeout pop, 1000

callPop = do ->
  pop()
