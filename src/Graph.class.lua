Graph = newclass("Graph")

function Graph:init(aPosition, aSize)
	if not aPosition or not aSize then return error("Couldn't init graph, missing parameters") end
	
	self.Position = aPosition
	self.Size = aSize
	self.GraphVisableDuration = 30000
	self.GraphCurrentTime = 0
	self.GraphTotalTime = 20000
	self.GraphRenderTarget = dxCreateRenderTarget( aSize.x, aSize.y, true )  
	self.GraphTimeLines = {}
	self.WorldVisualization = InWorldVisualization(self)
	
	timeLineSliderBox = Rectangle(Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH,GlobalConstants.SCREEN_HEIGHT - 50),Coordinate2D(GlobalConstants.SCREEN_WIDTH * 0.6,50))
	self.timeLineSlider = 	Slider(Coordinate2D(0,15), Coordinate2D(GlobalConstants.SCREEN_WIDTH * 0.6,20), Coordinate2D(20,20),0,self.GraphTotalTime,timeLineSliderBox)
	
	table.insert(self.GraphTimeLines, GraphTimeLine(self,
		Coordinate2D(0,0),
		Coordinate2D(aSize.x,aSize.y / GlobalConstants.AMOUNT_OF_TIMELINES), 
		{["PathCamPosition"] = true}
	)) 
	table.insert(self.GraphTimeLines, GraphTimeLine(self,
		Coordinate2D(0,aSize.y / GlobalConstants.AMOUNT_OF_TIMELINES),
		Coordinate2D(aSize.x,aSize.y / GlobalConstants.AMOUNT_OF_TIMELINES),
		{["PathCamTarget"] = true}
	)) 
	
	for i=2,GlobalConstants.AMOUNT_OF_TIMELINES - 1 do --Create graph time lines
		table.insert(
			self.GraphTimeLines,
			GraphTimeLine(
				self,
				Coordinate2D(0,i * aSize.y / GlobalConstants.AMOUNT_OF_TIMELINES),
				Coordinate2D(aSize.x,aSize.y / GlobalConstants.AMOUNT_OF_TIMELINES),
				{["DynamicEffect"] = true, ["StaticEffect"] = true}
			) --Create graphTimeLines
		)
	end
	
	addEvent ( "onSliderDrag", true )
	addEventHandler ( "onSliderDrag", getRootElement(), 
		function(aSliderID, aNewSliderValue)
			if(self.timeLineSlider.ID == aSliderID) then
				self.GraphCurrentTime = aNewSliderValue
				for k,v in ipairs(self.GraphTimeLines) do
					v:updateGraphTimeLineElements()
				end
			end
		end
	)
	
	addEventHandler ( "onClientRender", getRootElement(), 
		function()
			self:updateRenderTarget()	
		end
	)
end

function Graph:getGraphTimeLine(aIndex)
	if aIndex > 0  then
		return self.GraphTimeLines[aIndex]:getTimeLineElements()
	end
	return false
end

function Graph:increaseGraphTotalTime(aIncreaseValue)
	self.GraphTotalTime = self.GraphTotalTime + aIncreaseValue
	self.timeLineSlider:increaseSliderMaximalValue(aIncreaseValue)
	outputChatBox(self.GraphTotalTime)
end

function Graph:updateRenderTarget()
	if not GlobalInterface:isInterfaceVisable() then return end

	dxSetRenderTarget(self.GraphRenderTarget)
	for k,v in ipairs(self.GraphTimeLines) do
		v:draw()
	end
	--TODO: Maybe change the drawing to Line class?
	for i=math.floor(self.GraphCurrentTime / 5000) - 1,math.ceil((self.GraphCurrentTime + self.GraphVisableDuration)/5000) do
		local x = self:getPositionOnGraphFromTime(i * 5000)
		dxDrawLine(x,0,x,self.Size.y)
	end
	dxSetRenderTarget()
	dxDrawImage( self.Position.x,  self.Position.y,  self.Size.x, self.Size.y, self.GraphRenderTarget )  
end

function Graph:getAllTimeLineElements()
	local tempTable = {}
	for k,v in ipairs(self.GraphTimeLines) do
		local timeLinePaths = v:getTimeLineElements()
		for ke,va in ipairs(timeLinePaths) do
			table.insert(tempTable,va)
		end
	end
	
	return tempTable
end

function Graph:getGraphTimeSpan()
  return self.GraphCurrentTime, (self.GraphCurrentTime + self.GraphVisableDuration)
end

function Graph:getCurrentTimeFromMousePosition()
	local MouseOnGraph = GlobalMouse:getPosition() - self.Position
	if(MouseOnGraph > Coordinate2D(0,0) and MouseOnGraph < self.Size) then
		return math.floor(MouseOnGraph.x / self.Size.x * self.GraphVisableDuration + self.GraphCurrentTime)
	end
	return nil
end

function Graph:getPositionOnGraphFromTime(aElementTime)
	return self.Position.x + ((aElementTime - self.GraphCurrentTime) / ( self.GraphVisableDuration)* self.Size.x)
end

function Graph:isMouseAboveGraph()
	local MousePosition = GlobalMouse:getPosition()
	return (MousePosition > self.Position and MousePosition < self.Position + self.Size)
end

function Graph:getTimeLineElementWidthFromTime(aDuration)
	if not aDuration then return end
	return aDuration / self.GraphVisableDuration * self.Size.x
end

function Graph:getSize()
	return self.Size
end

function Graph:getPosition()
	return self.Position
end