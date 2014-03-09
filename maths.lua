-- Averages an arbitrary number of angles.
function math.averageAngles(...)
    local x,y = 0,0
    for i=1,select('#',...) do local a= select(i,...) x, y = x+math.cos(a), y+math.sin(a) end
    return math.atan2(y, x)
end


-- Returns the distance between two points.
function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end
-- Distance between two 3D points:
-- function math.dist(x1,y1,z1, x2,y2,z2) return ((x2-x1)^2+(y2-y1)^2+(z2-z1)^2)^0.5 end


-- Returns the angle between two points.
function math.getAngle(x1,y1, x2,y2) return math.atan2(x2-x1, y2-y1) end


-- Returns the closest multiple of 'size' (defaulting to 10).
function math.multiple(n, size) size = size or 10 return math.round(n/size)*size end


-- Clamps a number to within a certain range.
function math.clamp(low, n, high) return math.min(math.max(n, low), high) end


-- Normalizes two numbers.
function math.normalize(x,y) local l=(x*x+y*y)^.5 if l==0 then return 0,0,0 else return x/l,y/l,l end end
-- Normalizes a table of numbers.
function math.normalize(t) local n,m = #t,0 for i=1,n do m=m+t[i] end m=1/m for i=1,n do t[i]=t[i]*m end return t end


-- Returns 'n' rounded to the nearest 'deci'th.
function math.round(n, deci) deci = 10^(deci or 0) return math.floor(n*deci+.5)/deci end

function math.trunc(n, deci) deci = 10^(deci or 0) return math.floor(n*deci)/deci end

-- Randomly returns either -1 or 1.
function math.rsign() return math.random(2) == 2 and 1 or -1 end


-- Returns 1 if number is positive, -1 if it's negative, or 0 if it's 0.
function math.sign(n) return n>0 and 1 or n<0 and -1 or 0 end


-- Checks if two line segments intersect. Line segments are given in form of ({x,y},{x,y}, {x,y},{x,y}).
function math.checkIntersect(l1p1, l1p2, l2p1, l2p2)
    local function checkDir(pt1, pt2, pt3) return math.sign(((pt2[1]-pt1[1])*(pt3[2]-pt1[2])) - ((pt3[1]-pt1[1])*(pt2[2]-pt1[2]))) end
    return (checkDir(l1p1,l1p2,l2p1) ~= checkDir(l1p1,l1p2,l2p2)) and (checkDir(l2p1,l2p2,l1p1) ~= checkDir(l2p1,l2p2,l1p2))
end

-- Checks if two rectangles overlap. Rectangles are given in form of ({x,y},{x,y}, {x,y},{x,y}).
function math.CheckCollision(box1x, box1y, box1w, box1h, box2x, box2y, box2w, box2h)
    if box1x > box2x + box2w - 1 or -- Is box1 on the right side of box2?
       box1y > box2y + box2h - 1 or -- Is box1 under box2?
       box2x > box1x + box1w - 1 or -- Is box2 on the right side of box1?
       box2y > box1y + box1h - 1    -- Is b2 under b1?
    then
        return false                -- No collision. Yay!
    else
        return true                 -- Yes collision. Ouch!
    end
end

function math.loop(min,v,max) if v > max then return min elseif v < min then return max else return v end end

-- gets the intersection 
function math.getIntercept(l1p1, l1p2, l2p1, l2p2)
  local m1 = (l1p2[2]-l1p1[2])/(l1p2[1]-l1p1[1])
  local m2 = (l2p2[2]-l2p1[2])/(l2p2[1]-l2p1[1])
  local b1 = -m1*l1p1[1]+l1p1[2]
  local b2 = -m2*l2p1[1]+l2p1[2]
  local x = (b2-b1)/(m1-m2)
  local y = m1*x+b1
  return x,y
end

--takes three points, first two are line {} {} {}
function math.getPerpIntercept(lp1,lp2,p3)
  local h = math.dist(lp1[1],lp1[2],p3[1],p3[2])
  local phi = math.atan2(lp2[2]-lp1[2],lp2[1]-lp1[1])
  local the = math.atan2(p3[2]-lp1[2],p3[1]-lp1[1]) - phi
  local a = h*math.cos(the)
  local x = a/math.cos(phi)
  local y = a/math.sin(phi)
  return x,y
end

function math.getPerpDistance(lp1,lp2,p3)
  local h = math.dist(lp1[1],lp1[2],p3[1],p3[2])
  local phi = math.atan2(lp2[2]-lp1[2],lp2[1]-lp1[1])
  local the = math.atan2(p3[2]-lp1[2],p3[1]-lp1[1]) - phi
  return h*math.sin(the)
end