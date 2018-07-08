InWorldVisualization = newclass("InWorldVisualization")

function InWorldVisualization:init(aGraph)
	self.ParentGraph = aGraph
	self.PositionTimeLineElements = {}
	self.TargetTimeLineElements = {}
	self.PositionSplinePoints = {}
	self.TargetSplinePoints = {}	
	self.bEnableInWorldView = true

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

	self.PositionTimeLineElements	= self:convertToInterpolatableTable(tempCamPositionPoints)
	self.TargetTimeLineElements 	= self:convertToInterpolatableTable(tempCamTargetPoints)
	
	self.PositionSplinePoints 		= self:getSplinePointsTable(self.PositionTimeLineElements)
	self.TargetSplinePoints 		= self:getSplinePointsTable(self.TargetTimeLineElements)
end

function InWorldVisualization:draw()
	if(#self.PositionSplinePoints < 1) then return end
	
	for k,v in ipairs(self.PositionSplinePoints) do
		for i=1,#v - 1 do
			dxDrawLine3D(v[i].x, v[i].y, v[i].z, v[i + 1].x, v[i + 1 ].y, v[i + 1].z,tocolor ( 0, 255, 0, 230 ), 10)
		end
	end
end

function InWorldVisualization:animate()
	
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
			index = index + 1
		else
			tempTable[index][#tempTable[index] + 1] = table.remove(aTable,1)
		end
	end
	return tempTable
end



