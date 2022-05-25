-- N-Polygon Rotator
-- A pretty script showcasing basic geometry and Lua's Love2d

-- 1. N-Point Generator
-- From a given center and radius, make points on a regular polygon
-- 2. Rotation Method
--- From a given table of points, rotate about the center
-- 3. love.update calls Rotation Method on the polygon

function generate_n_points(center, radius, n)
    local points = {}
    for i=0, n-1 do
        local angle = i*math.rad(360/n)
        local x = math.sin(angle) * radius
        local y = math.cos(angle) * radius
        -- x value
        table.insert(points, center - x)
        -- y value
        table.insert(points, center - y)
    end
    return points
end

function rotate_points(points, center, theta)
    -- [cos(theta) -sin(theta) ]    [x]     [x']
    -- [sin(theta)  cost(theta)]  * [y]   = [y']
    -- implies...
    -- [x'] = [x*math.cos(theta) - y*math.sin(theta)]
    -- [y'] = [x*math.sin(theta) + y*math.cos(theta)]
    local new_x = {}
    local new_y = {}
    local theta = math.rad(theta)
    -- Iterate X
    for i=1, size(points), 2 do
        local x = points[i] - center
        local y = points[i+1] - center
        table.insert(new_x, x*math.cos(theta) - y*math.sin(theta) + center)
    end
    -- Iterate Y
    for i=2, size(points), 2 do 
        local x = points[i-1] - center
        local y = points[i] - center
        table.insert(new_y, x*math.sin(theta) + y*math.cos(theta) + center)
    end
    return_table = {}
    for x,y in zip(new_x, new_y) do
        table.insert(return_table, x)
        table.insert(return_table, y)
    end
    return return_table
end



function love.load()
    cent = 400
    i_care = 0
    radius = 100
    points = generate_n_points(cent,radius, 4)
end

function love.update(dt)
    i_care  = (i_care + 1)%360
    points = rotate_points(points, cent, i_care)
end


function love.draw()
    love.graphics.polygon("fill",points)
end
-- -------- UTILS ------------------------------------

function zip(...)
    local arrays, ans = {...}, {}
    local index = 0
    return
      function()
        index = index + 1
        for i,t in ipairs(arrays) do
          if type(t) == 'function' then ans[i] = t() else ans[i] = t[index] end
          if ans[i] == nil then return end
        end
        return unpack(ans)
      end
  end


function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end

 function size(table)
    local cnt = 0
    for _ in pairs(table) do
        cnt = cnt + 1
    end
    return cnt
end








