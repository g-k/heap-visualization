Heapq = require './heapq'

_ = require 'underscore'
Backbone = require 'backbone'
d3 = require 'd3'

# binaryHeapChildren = (heap, index) ->
#   [heap[2*index+1], heap[2*index+2]]

# binaryHeapParent = (heap, index) ->
#   heap[(index-1) >> 1]

log2 = (n) ->
  # http://graphics.stanford.edu/~seander/bithacks.html#IntegerLogObvious
  e = 0
  while true
    if not (n >>= 1)
      break
    e += 1
  e

Heapq.setter = (heap, index, value) ->
  heap.trigger 'set', index, value
  heap[index] = value

Heapq.getter = (heap, index) ->
  heap.trigger 'get', index
  heap[index]

heap = _.extend [], Backbone.Events,
  push: (item) ->
    @trigger 'push', item
    Array.prototype.push.call @, item

  pop: ->
    @trigger 'pop'
    Array.prototype.pop.call @

# TODO: Trigger d3 drawing on changes
heap.on 'all', -> console.log arguments


drawArray = (selection, array, options) ->

  options = _.defaults options,
    x: (datum, index) -> options.leftPadding + index*options.separation
    y: options.topPadding
    leftPadding: 40.5
    topPadding: 40.5
    separation: 50
    boxHeight: 20
    boxWidth: 20
    text: (datum) -> datum
    textX: (datum, index) -> options.leftPadding+index*options.separation
    textY: (datum, index) -> options.topPadding

  dataSelection = selection.selectAll(options.selector).data(array)

  dataSelection.enter()
    .append('rect')
      .attr("x", options.x)
      .attr("y", options.y)
      .attr("height", options.boxHeight)
      .attr("width", options.boxWidth)
      .style("fill", (datum) -> d3.rgb(datum, datum, datum).toString())
      .style("stroke-width", "0px")

  dataSelection.options = options

  dataSelection

data = [1, 3, 5, 7, 9, 2, 4, 6, 8, 0]

dataObjs = _.map data, (n, index) ->
  value: n
  index: index

console.log 'dataObjs', dataObjs
outerHeight = 200

margin =
  left: 40
  right: 440
  top: 40
  bottom: 0

step = 120
width = 960 - margin.right
height = outerHeight - margin.top - margin.bottom

tree = d3.layout.tree().children(
    (datum, depth) ->
      children = _.compact [dataObjs[2*datum.index+1], dataObjs[2*datum.index+2]]
      if _.isEmpty children
        children = null
      return children
  )
  .size([height, 1])
  .separation(-> 1)


root = dataObjs[0]
nodes = tree.nodes root
links = tree.links tree.nodes root

console.log 'nodes', nodes.length
console.log 'links', links.length

svg = d3.select('body').append('svg')
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom)
  .style("margin", "1em 0 1em " + -margin.left + "px")

g = svg.append('g')
  .attr("transform", "translate(#{margin.left},#{margin.top})")

g.selectAll('.link')
  .data(links)
  .enter().append('path')
    .attr('class', 'link')
    .attr('d', d3.svg.diagonal()
      .source( (datum) -> {
        x: datum.source.x
        y: datum.source.depth * step
      })
      .target( (datum) -> {
        x: datum.target.x
        y: datum.target.depth * step
      })
      .projection( (datum) -> [datum.y, datum.x])
    )

node = g.selectAll('.node')
  .data(nodes)
  .enter().append('g')
    .attr('class', 'node')
    .attr('transform', (datum) -> "translate(#{datum.depth*step},#{datum.x})")

node.append('text')
  .attr("x", 6)
  .attr("dy", ".32em")
  .text((datum) -> datum.value)
  .each((datum) -> datum.width = @getComputedTextLength() + 12)

node.insert("rect", "text")
  .attr("ry", 6)
  .attr("rx", 6)
  .attr("y", -10)
  .attr("height", 20)
  .attr("width", (d) -> Math.max(32, d.width))


# dataSelection = drawArray svg, data, selector: 'rect'
# dataSelection.attr('class', '.original')


draw = ->
  next = data.shift()
  console.log 'drawing', next, not _.isUndefined next

  if _.isUndefined next
    document.addEventListener 'keypress', draw, false
  else
    Heapq.heapPush heap, next
    console.log heap
    svg = d3.select('div svg')

    d$ = drawArray(svg, heap,
      topPadding: 100.5
      selector: 'rect'
     )
    d$.transition()
      .duration(1000)
      .attr('y', (datum, index) -> d$.options.topPadding + (log2 index+1)*d$.options.separation)
      .attr('rx', 10)
      .attr('ry', 10)
    # d$.remove().transition(1000).style('opacity', 0.0).remove()


document.addEventListener 'keypress', draw, false

# heapSel.on 'all', -> console.log arguments
# drawBinaryHeapTree svg, heap

# sort = []
# while heap.length
#   sort.push Heapq.heapPop heap

# console.log sort, data.sort()


window.d3 = d3
window.heap = heap
window.Heapq = Heapq