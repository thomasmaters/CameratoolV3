---@type Spline
Spline = newclass("Spline")

function Spline:init(aTension)
    ---@field [parent=#Spline] #number Tension Tension in catmull rom spline matrix.
    self.Tension = aTension or 0.5
    ---@field [parent=#Spline] #table TensionMatrix Spline matrix.
    self.TensionMatrix = matrix{	{-self.Tension		,2 - self.Tension	,self.Tension - 2		,self.Tension	},
        {2 * self.Tension	,self.Tension - 3	,3 - 2 * self.Tension	,-self.Tension	},
        {-self.Tension		,0				,self.Tension			,0			},
        {0				,1				,0					,0			}}
end

--Catmull rom spline 3d implementation
---@function [parent=#Spline] getCurvePoints
--@param #table points A list with Coordinate3D's or tables ({{x,y,z},{x,y,z},{x,y,z},{x,y,z}}).
--@param #number numOfSeg Number of segments to cut the spline.
function Spline:getCurvePoints(path, numOfSeg)
    if #path < 2 then return nil end

    local numOfSeg = numOfSeg or 10
    local curveTable = {}

    table.insert(path,1,path[1]) 				--duplicate first value
    table.insert(path,path[#path]) 			--duplicate last value

    local function calcCurve(points,numOfSeg)				--Function for calculating the curve between 2 points
        local tempTable = {}
        local m2 = self:getMatrixFromPoints(points)
        for i=0,1,(1/numOfSeg) do
            local m3 = matrix{{i * i * i, i * i, i, 1}}
            local m4 = matrix.mul(m3,self.TensionMatrix)
            local m5 = matrix.mul(m4,m2)
            table.insert(tempTable,Coordinate3D(m5[1][1],m5[1][2],m5[1][3]))
        end
        return tempTable
    end

    --Split path in path segments.
    for i=2,#path - 2, 1 do
        local returnTable = calcCurve({path[i-1],path[i],path[i+1],path[i+2]},numOfSeg) --Cut table in pieces
        for j=1,#returnTable do
            table.insert(curveTable,table.remove(returnTable,1))								--Put calculated points in a new table
        end
        returnTable = {}
    end
    table.insert(curveTable,Coordinate3D(unpack(path[#path - 1])))							--Add the last controlpoint again

    return curveTable
end

function Spline:getMatrixFromPoints(points)
    assert(#points == 4, "Spline:getMatrixFromPoints, points size mismatch, expected size of 4 got " ..tostring(#points))

    --Table of Coordinate3D's.
    if Coordinate3D:made(points[1]) then
        return matrix{points[1]:pack(),points[2]:pack(),points[3]:pack(),points[4]:pack()}
            --It's already a matrix type.
    elseif( points.type ~= nil) then
        return points;
    --Table of tables.
    else
        return matrix{points[1],points[2],points[3],points[4]}
    end
end

---@function [parent=#Spline] getLengthOfSpline
--@param #table points Table of tables or table of Coordinate3D or points matrix.
--@param #number segments Value to devide the spline. Higher number > more precision but slower performance.
function Spline:getLengthOfSpline(points, segments)
    local m1 = self:getMatrixFromPoints(points)
    local splineLength = 0

    for i=0,1,(1/segments) do
        splineLength = splineLength + self:getLengthOfSplineSegment(m1, i, (1/segments))
    end
    return splineLength;
end

function Spline:getPointOnSpline(points, progress)
    if progress >= 1 then return points[3] end
    if progress <= 0 then return points[2] end

    local m1 = self:getMatrixFromPoints(points)
    local m2 = matrix.mul(self:getPointsBaseMatrix(progress), m1)
    return {m2[1][1],m2[1][2],m2[1][3]}
end

---@function [parent=#Spline] syncPoints
--@param #table points1 Table of table or table of Coordinates or points matrix of the first spline segment.
--@param #table points2 Table of table or table of Coordinates or points matrix of the second spline segment.
--@param #number targetSpeed How much distance much be traveled in 1 second (distance/second).
--@return #number Total duration of the second spline.
--This will make the average movement speed across the second spline equal to the average movement speed of the frist spline.
function Spline:syncPoints(points1, points2, targetSpeed)
    local length = self:getLengthOfSpline(points2,100)
    return length / targetSpeed
end

---@function [parent=#Spline] getLengthOfSplineSegment
--@param #table points Table of tables or table of Coordinate3D or points matrix.
--@param #number progress Progress of the spline.
--@param #number deltaProgress Difference of the progress.
function Spline:getLengthOfSplineSegment(points, progress, deltaProgress)
    if((progress + deltaProgress) > 1) then return end
    if((progress + deltaProgress) < 0 or progress < 0) then return end

    local p1 = self:getPointOnSpline(points, progress)
    local p2 = self:getPointOnSpline(points, progress + deltaProgress)

    --sqrt((x1-x2)^2+(y1-y2)^2+(z1-z2)^2)
    return math.sqrt(math.pow((p1[1] - p2[1]),2) + math.pow((p1[2] - p2[2]),2) + math.pow((p1[3] - p2[3]),2))
end

function Spline:getMovementSpeedAlongSpline(points, progress, deltaProgress)
    local distance = self:getLengthOfSplineSegment(points, progress, deltaProgress)
    return distance/deltaProgress
end

--Calculates a matrix from the current progress along the curve.
function Spline:getPointsBaseMatrix(progress)
    local m1 = matrix{{progress * progress * progress, progress * progress, progress, 1}}
    return matrix.mul(m1,self.TensionMatrix)
end
