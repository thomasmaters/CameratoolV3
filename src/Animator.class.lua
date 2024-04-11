--- @type Animator
Animator = newclass("Animator")

function Animator:init()
    --- @field [parent=#Animator] #Coordinate3D CurrentPosition
    self.CurrentPosition = {} 
    --- @field [parent=#Animator] #table TimeLinePaths
    self.TimeLinePaths = {}
    --- @field [parent=#Animator] #table AnimationPoints
    self.AnimationPoints = {}
    --- @field [parent=#Animator] #number CurrentAnimationIndex
    self.CurrentAnimationIndex = 0
end

function Animator:stopAnimating()
    self.CurrentAnimationIndex = 0
end

--- @function [parent=#Animator] getCurrentPosition
--@return #Coordinate3D
function Animator:getCurrentPosition()
    return self.CurrentPosition
end

--- @function [parent=#Animator] updateAnimationPoints
function Animator:updateAnimationPoints(timeLinePaths)
    if timeLinePaths == nil then return end
    if not (#timeLinePaths > 0) then return end
    self.TimeLinePaths = timeLinePaths
    self:createAnimationPoints()
end

--- @function [parent=#Animator] interpolateOver
function Animator:interpolateOver(timeLinePaths, time)
    if not (#timeLinePaths > 0) then return end
    if self.CurrentAnimationIndex > #self.TimeLinePaths then self:stopAnimating() end
    time = time or 0

    self.TimeLinePaths = timeLinePaths
    local bAnimationIndexFound = false

    -- Do we start at an user specified time, set current animation index.
    for k,v in ipairs(self.TimeLinePaths) do
        if time >= v.StartTime and time < v.StartTime + v.Duration then
            bAnimationIndexFound = true
            if k ~= self.CurrentAnimationIndex then
                self.CurrentAnimationIndex = k
                self:createAnimationPoints()
            end
        end
    end
    if self.CurrentAnimationIndex ~= 0 and bAnimationIndexFound then
        self:animate(time)
    end
end

function Animator:createAnimationPoints()
    if not (#self.TimeLinePaths > 0) then return end
    if self.CurrentAnimationIndex == nil or self.CurrentAnimationIndex == 0 or self.CurrentAnimationIndex > #self.TimeLinePaths then return end

    --Construct the points to interpolate over.
    self.AnimationPoints = {}
    
    --Sort the table so its an easier lookup.
    table.sort(self.TimeLinePaths,
        function(a, b)
            return a.StartTime < b.StartTime
        end
    )
    
    --Do we have a connected path in the previouse path?
    if (self.CurrentAnimationIndex ~= 1 and self.TimeLinePaths[self.CurrentAnimationIndex - 1]:isConnectedToPath()) then
        table.insert(self.AnimationPoints, self.TimeLinePaths[self.CurrentAnimationIndex - 1].StartPosition:pack())
    else
        table.insert(self.AnimationPoints, self.TimeLinePaths[self.CurrentAnimationIndex].StartPosition:pack())
    end

    table.insert(self.AnimationPoints, self.TimeLinePaths[self.CurrentAnimationIndex].StartPosition:pack())
    table.insert(self.AnimationPoints, self.TimeLinePaths[self.CurrentAnimationIndex].EndPosition:pack())

    --Do we have a connectedPath?
    if self.TimeLinePaths[self.CurrentAnimationIndex]:isConnectedToPath() then
        table.insert(self.AnimationPoints, self.TimeLinePaths[self.CurrentAnimationIndex + 1].EndPosition:pack())
    else
        table.insert(self.AnimationPoints, self.TimeLinePaths[self.CurrentAnimationIndex].EndPosition:pack())
    end
end

function Animator:animate(time)
    --Start interpolating
    local progress,_,_  = interpolateBetween(
        0, 0, 0,
        1, 0, 0, 
        (time - self.TimeLinePaths[self.CurrentAnimationIndex].StartTime) / self.TimeLinePaths[self.CurrentAnimationIndex].Duration, 
        self.TimeLinePaths[self.CurrentAnimationIndex].PathAnimationType)

    self.CurrentPosition = GlobalSpline:getPointOnSpline(self.AnimationPoints, progress)
end
