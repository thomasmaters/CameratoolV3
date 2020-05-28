---@type InWorldVisualization
InWorldVisualization = newclass("InWorldVisualization")

function InWorldVisualization:init(aGraph)
	self.ParentGraph = aGraph
	self.PositionTimeLineElements = {}
	self.TargetTimeLineElements = {}
	self.PositionSplinePoints = {}
	self.TargetSplinePoints = {}	
	
	self.bEnableInWorldView = true
	
	self.AnimatedObject = createObject ( 980, 0, 0, 0)
	
	self.PositionAnimator = Animator() --#Animator
	self.TargetAnimator = Animator() --#Animator

	addEventHandler( "onClientKey", getRootElement(), bind(self.updateInWorldView,self))
	addEventHandler( "onClientRender" , getRootElement(), bind(self.draw,self))
end

function InWorldVisualization:updateInWorldView(aButton, pressOrRelease)
	if aButton ~= 'l' or pressOrRelease then return end
	
	if self.PositionAnimator:isAnimating() then
		self.PositionAnimator:stopAnimating()
		self.TargetAnimator:stopAnimating()
	end
	
	local timeLineElements = self.ParentGraph:getAllTimeLineElements() --I sinserly hope this is a copy 
	local tempCamTargetPoints = {}
	local tempCamPositionPoints = {}

	for i=#timeLineElements,1,-1 do
		if PathCamPosition:made(timeLineElements[i]) then
			table.insert(tempCamPositionPoints, table.remove(timeLineElements, i))
		elseif PathCamTarget:made(timeLineElements[i]) then
			table.insert(tempCamTargetPoints, table.remove(timeLineElements, i))
		end
	end

	self.PositionTimeLineElements	= self:convertToInterpolatableTable(tempCamPositionPoints)
	self.TargetTimeLineElements 	= self:convertToInterpolatableTable(tempCamTargetPoints)
	
	self.PositionSplinePoints 		= self:getSplinePointsTable(self.PositionTimeLineElements)
	self.TargetSplinePoints 		= self:getSplinePointsTable(self.TargetTimeLineElements)
end

function InWorldVisualization:draw()
	if(#self.PositionSplinePoints < 1) then return end
	self:visualizeAnimation()
	for k,v in ipairs(self.PositionSplinePoints) do
		for i=1,#v - 1 do
			dxDrawLine3D(v[i].x, v[i].y, v[i].z, v[i + 1].x, v[i + 1 ].y, v[i + 1].z,tocolor ( 0, 255, 0, 230 ), 10)
		end
	end
end

function InWorldVisualization:visualizeAnimation()
	if not self.PositionAnimator:isAnimating() and not self.TargetAnimator:isAnimating() then
		self.AnimatedObject:setPosition(Vector3(0,0,0))
		self.PositionAnimator:interpolateOver(self.ParentGraph:getGraphTimeLine(1))
		self.TargetAnimator:interpolateOver(self.ParentGraph:getGraphTimeLine(2))
		return --TODO Do we need a return here?
	end
	
	local curPosition = self.PositionAnimator:getCurrentPosition()
	self.AnimatedObject:setPosition(Vector3(curPosition[1],curPosition[2],curPosition[3]))
end

-------------------------------
--Converts a table with Paths in a table with coordinates
-------------------------------
function InWorldVisualization:getSplinePointsTable(aTable)
	if not aTable or #aTable == 0 then return {} end
	local tempTable = {}
	local anotherTempTable = {}
	
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
		anotherTempTable[k] = GlobalSpline:getCurvePoints(tempTable[k],4)
		outputChatBox("Size of tempTable: " .. #tempTable[k] .. " Size of splinepoints: " .. #anotherTempTable[k])
	end

	return anotherTempTable
end

-------------------------------
--This function converts a table with timelineelements, to a table with a better structure.
-------------------------------
function InWorldVisualization:convertToInterpolatableTable(aTable)
	if aTable == nil or #aTable < 1 then return {} end
	local tempTable = {}
	local index = 1
	
	table.sort(aTable,
		function(a,b)
			return a.StartTime < b.StartTime
		end
	)
	
	--Sort the table so connected timelineelements are grouped together.
	while #aTable > 0 do
		if tempTable[index] == nil then
			tempTable[index] = {}
			tempTable[index][1] = table.remove(aTable,1)
		end
		if not tempTable[index][#tempTable[index]]:isConnectedToPath() then
			index = index + 1
		else
			tempTable[index][#tempTable[index] + 1] = table.remove(aTable,1)
		end
	end
	return tempTable
end



