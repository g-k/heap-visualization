_ = require 'underscore'
d3 = require 'd3'

Heapq = require './heapq'
heap = require './event-heap'


# Make an SVG element with margins to display the heap tree on
[$g, HEIGHT] = do ->
  margin =
    left: 10
    right: 440
    top: 10
    bottom: 0

  outerHeight = 510
  width = 960 - margin.right
  height = outerHeight - margin.top - margin.bottom

  svg = d3.select('body').append('svg')
    .attr('class', 'heap-svg')
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .style("margin", "1em 0 1em " + -margin.left + "px")

  g = svg.append('g')
    .attr("transform", "translate(#{margin.left},#{margin.top})")

  return [g, height]


BOX_SIZE = 20 # Length of node sides
STEP = 120  # Horizontal separation between levels of tree


tree = d3.layout.tree().children(
    (datum, depth) ->
      children = _.compact [heap[2*datum.index+1], heap[2*datum.index+2]]
      if _.isEmpty children
        children = null
      return children
  )
  .separation(-> 1)
  .size([HEIGHT, 1])


drawLink = ($link) ->
  $link.attr('d', d3.svg.diagonal()
      .source((datum) -> {
        x: datum.source.x
        y: datum.source.depth * STEP
      })
      .target((datum) -> {
        x: datum.target.x
        y: datum.target.depth * STEP
      })
      .projection((datum) -> [datum.y, datum.x])
    )


rectAttrs = ($rect, options) ->
  # Common node attributes
  $rect
    .attr('rx', 6)
    .attr('ry', 6)
    .attr("x", 0)
    .attr("y", -10)
    .attr("height", options.boxSize)
    .attr("width", options.boxSize)
    .style("fill", (datum) -> scaleRGB datum.value)


drawHeap = ->
  root = heap[0]
  nodes = tree.nodes root
  links = tree.links tree.nodes root


  ## Draw Links
  $links = $g.selectAll('.link')
    .data(links, (d) -> d.value)

  # Don't cover the box representing the node
  $links.enter().insert('path', '.node')
      .attr('class', 'link')
      .call(drawLink)

  # Update existing links
  $links.call(drawLink)

  # Remove old links
  $links.exit().remove()


  ## Draw Nodes
  $nodes = $g.selectAll('.node')
    .data(nodes, (d) -> d.value)

  indentTree = (datum) -> "translate(#{datum.depth*STEP},#{datum.x})"

  $nodes.enter().append('g')
    .attr('class', 'node')
    .attr('transform', indentTree)
    .append('rect')
      .call(rectAttrs, boxSize: BOX_SIZE)

  # Update node positions, and redraw them all over links
  $nodes.attr('transform', indentTree)

  # Remove old nodes
  $nodes.exit().remove()


# Make three colors to insert into heap
values = [1, 2, 3]

scaleRGB = d3.scale.ordinal()
  .domain(values)
  .range(colorbrewer.Blues[values.length])

data = _.map values, (value, index) ->
  index: index
  value: value
  valueOf: -> @value  # Compare on object values


addItem = (datum) ->
  ## Adds item `datum` to the heap

  # Add item to end of data array
  datum.index = heap.length

  Heapq.heapPush heap, _.extend {}, datum

  # TODO: Remove
  # console.log 'values', _.pluck heap, 'value'
  # console.log 'indices', _.pluck heap, 'index'

  # Forget old children
  _.each heap, (item) -> delete item.children

  drawHeap heap


do ->
  # Draw items to add
  svg = d3.select('body')
    .insert('svg', '.heap-svg')
      .attr("width", '150px')
      .attr("height", '3em')
      .style("margin", "0 0")

  leftPadding = 10
  separation = 50  # Distance between items

  svg.selectAll('.insert')
    .data(data, (d) -> d.value)
    .enter()
      .append('rect')
        .attr('class', 'data-add')
        .call(rectAttrs, boxSize: BOX_SIZE)
        .attr("x", (datum, index) -> leftPadding + index*separation)
        .attr("y", 5.5)
        .on('click', addItem)
