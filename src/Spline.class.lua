Spline = newclass("Spline")

function Spline:init(aTension)
	self.Tension = aTension or 0.5
	self.TensionMatrix = matrix{	{-self.Tension		,2 - self.Tension	,self.Tension - 2		,self.Tension	},
						{2 * self.Tension	,self.Tension - 3	,3 - 2 * self.Tension	,-self.Tension	},
						{-self.Tension		,0				,self.Tension			,0			},
						{0				,1				,0					,0			}}
end

--Catmull rom spline 3d implementation
--TODO: Make it possible to get a single point with a specific x, not only with line segments.
function Spline:getCurvePoints(points, numOfSeg)
	if #points < 2 then return nil end
	
	tension = self.Tension
	numOfSeg = numOfSeg or 10
	curveTable = {}
	
	local m1 = matrix{	{-tension		,2 - tension	,tension - 2		,tension	},
						{2 * tension	,tension - 3	,3 - 2 * tension	,-tension	},
						{-tension		,0				,tension			,0			},
						{0				,1				,0					,0			}}		--Curve Matrix
	
	table.insert(points,1,points[1]) 				--duplicate first value
	table.insert(points,points[#points]) 			--duplicate last value

	function calcCurve(points,numOfSeg)				--Function for calculating the curve between 2 points
		tempTable = {}
		m2 = {}
		if Coordinate3D:made(points[1]) then
			m2 = matrix{points[1]:pack(),points[2]:pack(),points[3]:pack(),points[4]:pack()}
		else
			m2 = matrix{points[1],points[2],points[3],points[4]}
		end
		
		for i=0,1,(1/numOfSeg) do							
			local m3 = matrix{{i * i * i, i * i, i, 1}}	
			local m4 = matrix.mul(m3,m1)
			local m5 = matrix.mul(m4,m2)
			table.insert(tempTable,Coordinate3D(m5[1][1],m5[1][2],m5[1][3]))
		end
		return tempTable
	end
	
	for i=2,#points - 2, 1 do
		local returnTable = calcCurve({points[i-1],points[i],points[i+1],points[i+2]},numOfSeg) --Cut table in pieces
		for j=1,#returnTable do
			table.insert(curveTable,table.remove(returnTable,1))								--Put calculated points in a new table
		end
		returnTable = {}
	end
	table.insert(curveTable,Coordinate3D(unpack(points[#points - 1])))							--Add the last controlpoint again
	
	return curveTable
end

function Spline:getPointOnSpline(points, progress)
	if progress >= 1 then return points[3] end
	if progress <= 0 then return points[2] end
	local m1 = matrix{points[1],points[2],points[3],points[4]}
	local m2 = matrix.mul(self:getPointsBaseMatrix(progress), m1)
	return {m2[1][1],m2[1][2],m2[1][3]}
end

--Calculates a matrix from the current progress on the curve.
function Spline:getPointsBaseMatrix(progress)
	local m1 = matrix{{progress * progress * progress, progress * progress, progress, 1}}	
	return matrix.mul(m1,self.TensionMatrix)
end