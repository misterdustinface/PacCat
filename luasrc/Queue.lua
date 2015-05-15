local public = {}

local size = function(thisQueue)
  return #(thisQueue.elements)
end

local enqueue = function(thisQueue, element)
  table.insert(thisQueue.elements, element)
end

local dequeue = function(thisQueue)
  return table.remove(thisQueue.elements, 1)
end

local peek = function(thisQueue)
  return thisQueue.elements[1]
end

local isEmpty = function(thisQueue)
  return thisQueue:size() == 0
end

local toString = function(thisQueue)
  return table.concat(thisQueue.elements, "\n")
end

local get = function(thisQueue, index)
  return thisQueue.elements[index]
end

local clear = function(thisQueue)
  thisQueue.elements = {}
end

function public.new(this) 
    return setmetatable({}, {
        __index = {
            elements = {},
            size = size,
            enqueue = enqueue,
            dequeue = dequeue, 
            peek = peek,
            isEmpty = isEmpty,
            toString = toString,
            get = get,
            clear = clear
        }
    })
end

return public