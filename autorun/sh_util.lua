function math.randomchoice(t)
    local keys = {}
    for key, value in pairs(t) do
        keys[#keys+1] = key
    end
    index = keys[math.random(1, #keys)]
    return t[index]
end

function table.contains(t, element)
  for _, value in pairs(t) do
    if value == element then
      return true
    end
  end
  return false
end

function table.find(t, element)
    for index, value in pairs(t) do
        if value == element then
            return index
        end
    end
end
