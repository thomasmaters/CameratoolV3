InWorldVisualization = newclass("InWorldVisualization")

function InWorldVisualization:init(aGraph)
	self.ParentGraph = aGraph
	self.PositionPoints = {}
	self.TargetPoints = {}
	self.PositionSplinePoints = {}
	self.TargetSplinePoints = {}	
	self.SplineInstance = Spline(0.5)
	self.bEnableInWorldView = true
	self.AnimationPreviewTimer = nil
	self.Object = createObject(1337,0,0,0)
	
	addEventHandler( "onClientKey", getRootElement(), bind(self.updateInWorldView,self))
	addEventHandler( "onClientRender" , getRootElement(), bind(self.draw,self))
end

function InWorldVisualization:updateInWorldView(aButton)
	if aButton ~= 'l' then return end
	local timeLineElements = self.ParentGraph:getAllTimeLineElements() --I sinserly hope this is a copy 
	tempCamTargetPoints = {}
	tempCamPositionPoints = {}

	for i=#timeLineElements,1,-1 do
		if PathCamPosition:made(timeLineElements[i]) then
			table.insert(tempCamPositionPoints, table.remove(timeLineElements, i))
		elseif PathCamTarget:made(timeLineElements[i]) then
			table.insert(tempCamTargetPoints, table.remove(timeLineElements, i))
		end
	end

	self.PositionPoints 		= self:convertToInterpolatableTable(tempCamPositionPoints)
	self.TargetPoints   		= self:convertToInterpolatableTable(tempCamTargetPoints)
	
	self.PositionSplinePoints 	= self:getSplinePointsTable(self.PositionPoints)
	self.TargetSplinePoints 	= {}--self:getSplinePointsTable(self.TargetPoints)
end

function InWorldVisualization:draw()
	if(#self.PositionSplinePoints < 1) then return end
	
	for k,v in ipairs(self.PositionSplinePoints) do
		for i=1,#v - 1 do
			dxDrawLine3D(v[i].x, v[i].y, v[i].z, v[i + 1].x, v[i + 1 ].y, v[i + 1].z,tocolor ( 0, 255, 0, 230 ), 10)
		end
	end
	
	if(#self.PositionPoints > 0) then
		local splineMatrix = self:getAnimationPosition(self.PositionPoints)
		--setElementPosition(self.Object,splineMatrix[1][1],splineMatrix[1][2],splineMatrix[1][3])
	end
end

function InWorldVisualization:getAnimationPosition(aTable)
	local animationTimer = nil
	local animationPosition = 1
	local animationIndex = 1
	local animationMatrix = nil
	local animationDuration = 0
	
	if isTimer(animationTimer) then
		local timeLeft, _, _ = getTimerDetails(animationTimer)
		local progress = 1 - timeLeft / animationDuration
		local splineMatrix = self.SplineInstance:getPointsBaseMatrix(progress)
		return matrix.mul(splineMatrix,animationMatrix)
	else		
		local matrixValue1 = 0
		local matrixValue2 = 0
		local matrixValue3 = 0
		local matrixValue4 = 0
		
		--Construct interpolate matrix
		if(animationPosition == 1) then
			matrixValue1 = aTable[animationIndex][1].StartPosition:pack()
			matrixValue2 = aTable[animationIndex][1].StartPosition:pack()
		else
			matrixValue1 = aTable[animationIndex][animationPosition - 1].StartPosition:pack()
			matrixValue2 = aTable[animationIndex][animationPosition].StartPosition:pack()			
		end
		
		if(animationPosition == #aTable[animationIndex]) then
			matrixValue3 = aTable[animationIndex][animationPosition].EndPosition:pack()
			matrixValue4 = aTable[animationIndex][animationPosition].EndPosition:pack()
		else
			matrixValue3 = aTable[animationIndex][animationPosition + 1].EndPosition:pack()
			matrixValue4 = aTable[animationIndex][animationPosition + 1].EndPosition:pack() --I changed this to a +1, is this correct?
		end
		
		animationMatrix = matrix{matrixValue1.matrixValue2,matrixValue3,matrixValue4}
		animationTimer = setTimer(function() end,aTable[animationIndex][animationPosition].Duration, 1)
		animationDuration = aTable[animationIndex][animationPosition].Duration
		--Go to next interpolateble table
		if(animationPosition + 1 > #aTable[animationIndex]) then
			animationPosition = 1
			if(animationIndex + 1 > #aTable) then
				animationIndex = 1
			else
				animationIndex = animationIndex + 1
			end
		else
			animationPosition = animationPosition + 1		
		end
		
		--return self:getAnimationPosition(aTable)
	end	
end

-------------------------------
--Converts a table with Paths in a table with coordinates
-------------------------------
function InWorldVisualization:getSplinePointsTable(aTable)
	if not aTable or #aTable == 0 then return {} end
	local tempTable = {}
	anotherTempTable = {}
	
	for k,subTable in ipairs(aTable) do
	outputChatBox("sub table size: " .. #subTable)
		tempTable[k] = {}
		anotherTempTable[k] = {}
		for subKey,v in ipairs(subTable) do
			table.insert(tempTable[k],v.StartPosition:pack())
			if subKey == #subTable then
				table.insert(tempTable[k],v.EndPosition:pack())
			end
		end
		anotherTempTable[k] = self.SplineInstance:getCurvePoints(tempTable[k],4)
		outputChatBox("Size of tempTable: " .. #tempTable[k] .. " Size of splinepoints: " .. #anotherTempTable[k])
	end
	
	print_r(anotherTempTable)
	return anotherTempTable
end

-------------------------------
--This function converts a table with timelineelements, to a table with a better structure.
-------------------------------
function InWorldVisualization:convertToInterpolatableTable(aTable)
	if aTable == nil or #aTable < 1 then return {} end
	tempTable = {}
	local index = 1
	
	table.sort(aTable,
		function(a,b)
			return a.StartTime < b.StartTime
		end
	)
	
	--Sort the table so connected timelineelements are grouped toghter.
	while #aTable > 0 do
		if tempTable[index] == nil then
			tempTable[index] = {}
			tempTable[index][1] = table.remove(aTable,1)
		end
		if tempTable[index][#tempTable[index]].ConnectedToPath == nil then
			outputChatBox("Increasing index")
			index = index + 1
		else
			outputChatBox("Path has a connection")
			tempTable[index][#tempTable[index] + 1] = table.remove(aTable,1)
		end
	end
	return tempTable
end



