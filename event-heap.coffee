_ = require 'underscore'
Backbone = require 'backbone'

Heapq = require './heapq'


# Override Heapq getter and setter to trigger events
Heapq.setter = (heap, index, value) ->
  heap.trigger 'set', index, value
  value.index = index
  heap[index] = value

Heapq.getter = (heap, index) ->
  heap.trigger 'get', index
  heap[index]


# Add Backbone events to heap
heap = _.extend [], Backbone.Events,

  push: (item) ->
    @trigger 'push', item
    item.index = @length
    @[@length] = item

  pop: ->
    @trigger 'pop'
    item = @[@length]
    item.index = null
    return item

module.exports = heap