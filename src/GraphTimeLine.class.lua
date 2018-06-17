GraphTimeLine = newclass("GraphTimeLine")

function GraphTimeLine:init(aGraph,aPosition,aSize,aAllowedTimeLineTypes,aGraphTimeLineElements)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("GraphTimeLine.class:init") end
	---PERTTYFUNCTION---
	
	if aGraph and aPosition and aSize then
		aPosition = aPosition + aGraph:getPosition()-- + Coordinate2D(2 * ( aGraph.RectangleBorderSize or GlobalConstants.RECTANGLE_BORDER_SIZE ),2 * ( aGraph.RectangleBorderSize or GlobalConstants.RECTANGLE_BORDER_SIZE ))		
		aSize = aSize -- Coordinate2D(4 * (aGraph.RectangleBorderSize or GlobalConstants.RECTANGLE_BORDER_SIZE ),4 * ( aGraph.RectangleBorderSize or GlobalConstants.RECTANGLE_BORDER_SIZE ))
	end
	
	self.ParentGraph = aGraph or error("No TimeLine parent given")
	self.Position = aPosition or error("No TimeLine position given!")
	self.Size = aSize or error("No TimeLine size given!")	
	self.TimeLineRectangle = Rectangle(aPosition - self.ParentGraph:getPosition(),aSize,nil,nil,nil,nil,false)
	self.AllowedTimeLineTypes = aAllowedTimeLineTypes or {} --Name(s) of class(es) to allow. Key value pair, if key exists, type is allowed.
	self.TimeLineElements = aGraphTimeLineElements or {}
	
	addEvent ( "timeLineElementHold", true )
	addEvent ( "timeLineElementRelease", true )
	addEvent ( "mouseIsDragging", true )
	addEvent ( "onCT3DeleteButtonClick", true)
	addEventHandler ( "timeLineElementHold", getRootElement(), bind(self.mouseHoldsTimeLineElement,self))
	addEventHandler ( "timeLineElementRelease", getRootElement(), bind(self.mouseReleasesTimeLineElement,self))
	addEventHandler ( "mouseIsDragging", getRootElement(), bind(self.dragging,self))
	addEventHandler( "onClientKey", getRootElement(), bind(self.onMouseScrollOnTimeLineElement,self))
	addEventHandler( "onCT3DeleteButtonClick", getRootElement(), bind(self.deleteSelectedTimeLineElements,self))
	GlobalInterface:addButtonClickBind(self)
end

-------------------------------
--Draws the time line and all the connected objects.
-------------------------------
function GraphTimeLine:draw()
	self.TimeLineRectangle:draw()
	for k,v in ipairs(self.TimeLineElements) do
		if self:isTimeLineElementOnGraph(v) then
			v:draw()
		end
	end
end

-------------------------------
--Handles when there is a scroll input above the graphtimeline. If scrolled above a timelinelement, it will increase/decrease its size.
-------------------------------
function GraphTimeLine:onMouseScrollOnTimeLineElement(aButton)
	if not (aButton == "mouse_wheel_up" or aButton == "mouse_wheel_down") then return end
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("GraphTimeLine.class:onMouseScrollOnTimeLineElement") end
	---PERTTYFUNCTION---
	if not self.ParentGraph:isMouseAboveGraph() then return end
	if not self:isMouseAboveTimeLine() then return end
	
	local HoveringOverTime = self.ParentGraph:getCurrentTimeFromMousePosition()
	local v = self.TimeLineElements[self:getTimeLineElementFromTime(HoveringOverTime)]
	if v == nil or StaticEffect:made(v) then return end --Are we hovering above a timelineelement, or is it a static effect?
	if Path:trycast(v) then --Are we scrolling above a Path timelineelement? If so, remove its connected path.
		v.ConnectedToPath = nil
	end
	
	local timeIncreaseRate = GlobalConstants.BASE_SCROLL_TIME_INCREASE * (aButton == "mouse_wheel_down" and 1 or -1) --Base time added and direction
	
	if getKeyState("lshift") then --Increase/decrease time if we hold shift or alt 
		timeIncreaseRate = timeIncreaseRate * GlobalConstants.FAST_SCROLL_MULTIPLIER
	elseif getKeyState("lalt") then
		timeIncreaseRate = timeIncreaseRate * GlobalConstants.SLOW_SCROLL_MULITPLIER
	end
	if v.Duration - timeIncreaseRate < GlobalConstants.MINIMUM_PATH_DURATION then --Are we going lower then the minimum?
		v.Duration = GlobalConstants.MINIMUM_PATH_DURATION
	else --Are we hitting a other timelinelement?
		for k,b in ipairs(self.TimeLineElements) do
			if (self:isTimeLineElementOnGraph(b)) then --Get all visable objects on graph
				if(b.StartTime > v.StartTime + v.Duration and b.StartTime < v.StartTime + v.Duration - timeIncreaseRate) then
					timeIncreaseRate = -1 * (b.StartTime - v.StartTime - v.Duration - 1)
					
					if Path:trycast(v) then
						outputChatBox("Connected 2 paths toghter")
						b.StartPosition = v.EndPosition
						v.ConnectedToPath = b
					end
					break
				end
			end
		end
		
		if (v.StartTime + v.Duration - timeIncreaseRate > self.ParentGraph.GraphTotalTime + self.ParentGraph.GraphVisableDuration) then --does or new size extent the maximum value of the graph?
			self.ParentGraph:increaseGraphTotalTime(GlobalConstants.BASE_SCROLL_TIME_INCREASE * GlobalConstants.GRAPH_TOTAL_TIME_INCREASE_MULTIPLIER) --Increase it by 10(default) seconds 
		end
		
		v.Duration = v.Duration - timeIncreaseRate	--Increase timelineelements duration				
	end
	
	v:setSize(
		Coordinate2D(
			self.ParentGraph:getTimeLineElementWidthFromTime(v.Duration),
			self.Size.y
		)
	)--Resize according to the timeline scale and his duration
		
	return
end

-------------------------------
--Checks if there is a timelineelemnt under a specific time.
-------------------------------
function GraphTimeLine:getTimeLineElementFromTime(aTime)
	for k,v in ipairs(self.TimeLineElements) do
		if (self:isTimeLineElementOnGraph(v)) then --Get all visable objects on graph
			if(v.StartTime < aTime and aTime < v.StartTime + v.Duration) then
				return k
			end
		end
	end
	return nil
end

-------------------------------
--Checks if a timelineelement under the mouse cursor can snap to this timeline and snaps it if so.
-------------------------------
function GraphTimeLine:mouseHoldsTimeLineElement()
	if not self:isMouseAboveTimeLine() then return end --Is the mouse above our timeline?
	
	local GraphStartTime,GraphEndTime = self.ParentGraph:getGraphTimeSpan()
	
	if (self:canObjectSnapToTimeLine(GlobalMouse:getObjectBeingHold()))then
		self:snapObjectToTimeLine()
	end
end

-------------------------------
--Removes all references to the timelineelement being hold.
-------------------------------
function GraphTimeLine:removeHoldingElement() --Deletes the object currently selected by the mouse.
	GlobalInterface:removeInterfaceElement(GlobalMouse.ObjectBeingHold)
	GlobalMouse:releaseObject()
	self:removeSelection()
end

-------------------------------
--User wants to place the timelineelement under his mouse.
-------------------------------
function GraphTimeLine:mouseReleasesTimeLineElement()
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("GraphTimeLine.class:mouseReleasesTimeLineElement") end
	---PERTTYFUNCTION---
	if not self.ParentGraph:isMouseAboveGraph() then --Is mouse not above our graph?
		self:removeHoldingElement()
		cancelEvent() --Stop call to other timelines(hopefully?).
		return
	end
	if not self:isMouseAboveTimeLine() then return end --Is the mouse above this timeline?
	if not self:canObjectSnapToTimeLine(GlobalMouse.ObjectBeingHold) then	--Is it not above our Graph and can we snap to a timeline?
		self:removeHoldingElement()
		return
	end
	
	local HoveringOverTime = self.ParentGraph:getCurrentTimeFromMousePosition()
	if not HoveringOverTime then return end --Make sure we got a time?

	local objectBeingHold = GlobalMouse:getObjectBeingHold()
	if not objectBeingHold then return end
	
	local ParentGraphPosition = self.ParentGraph:getPosition()
	objectBeingHold.StartTime = HoveringOverTime
	objectBeingHold:setPosition(Coordinate2D(objectBeingHold:getPosition().x - ParentGraphPosition.x,self.Position.y - ParentGraphPosition.y))
	objectBeingHold:setSize(
		Coordinate2D(
			self.ParentGraph:getTimeLineElementWidthFromTime(objectBeingHold.Duration),
			self.Size.y
		)
	)--Resize according to the timeline scale
	
	self:addGraphTimeLineElement(GlobalMouse:getObjectBeingHold())
	
	GlobalMouse:releaseObject()
end

-------------------------------
--Handles clicks on the timeline. Selects timelineelements if clicked on.
-------------------------------
function GraphTimeLine:clicked()
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("GraphTimeLine.class:clicked") end
	---PERTTYFUNCTION---
	if #self.TimeLineElements == 0 then return end --Do we even have timeline elements?
	if not self:isMouseAboveTimeLine() then return end --Is the mouse above this timeline?
	--self:removeSelection()
	
	local HoveringOverTime = self.ParentGraph:getCurrentTimeFromMousePosition()
	for k,v in ipairs(self.TimeLineElements) do
		if (self:isTimeLineElementOnGraph(v)) then --Get all visable objects on graph
			if(v.StartTime < HoveringOverTime and HoveringOverTime < v.StartTime + v.Duration) then
				v:setSelected(not v:isSelected())
			end
		end
	end	
end

-------------------------------
--Handles if the user stards dragging a timelineelement.
-------------------------------
function GraphTimeLine:dragging()
	if not self:isMouseAboveTimeLine() then return end --Is the mouse above this timeline?
		
	local HoveringOverTime = self.ParentGraph:getCurrentTimeFromMousePosition()
	local TimeLineElementKey = self:getTimeLineElementFromTime(HoveringOverTime)
	
	self:removeSelection()
	GlobalMouse:holdObject(self.TimeLineElements[TimeLineElementKey])
	self:removeTimeLineElement(self.TimeLineElements[TimeLineElementKey])
end

-------------------------------
--Removes selection from a timelineelement.
-------------------------------
function GraphTimeLine:removeSelection()
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("GraphTimeLine.class:removeSelection") end
	---PERTTYFUNCTION---
	for k,v in ipairs(self.TimeLineElements) do
		if(v:isSelected())then
			v:setSelected(false)
		end
	end
end

-------------------------------
--Function to check if a timelineelement under mouse can snap to the timeline.
-------------------------------
function GraphTimeLine:canObjectSnapToTimeLine(aTimeLineElement)
	local HoveringOverTime = self.ParentGraph:getCurrentTimeFromMousePosition()
	local GraphStartTime,GraphEndTime = self.ParentGraph:getGraphTimeSpan()
	
	if self.AllowedTimeLineTypes[aTimeLineElement:class():name()] == nil then return false end
	if not HoveringOverTime then return false end --Did we get a time?
	if HoveringOverTime + aTimeLineElement.Duration > GraphEndTime then return false end --Don't go outside the graph
	
	for k,v in ipairs(self.TimeLineElements) do
		if (self:isTimeLineElementOnGraph(v)) then --Get all visable objects on graph
			if	(v.StartTime >= HoveringOverTime and v.StartTime < HoveringOverTime + aTimeLineElement.Duration) or
				(v.StartTime + v.Duration > HoveringOverTime and v.StartTime + v.Duration < HoveringOverTime + aTimeLineElement.Duration) or
				(v.StartTime < HoveringOverTime and HoveringOverTime + aTimeLineElement.Duration < v.StartTime + v.Duration)then --Can it not snap here?
				return false		
			end
		end
	end	
	return true
end

function GraphTimeLine:isTimeLineElementOnGraph(aTimeLineElement)
	local GraphStartTime,GraphEndTime = self.ParentGraph:getGraphTimeSpan()
	return 	(aTimeLineElement.StartTime > GraphStartTime and aTimeLineElement.StartTime <= GraphEndTime) or 
			(aTimeLineElement.StartTime + aTimeLineElement.Duration > GraphStartTime and aTimeLineElement.StartTime + aTimeLineElement.Duration <= GraphEndTime) or
			(aTimeLineElement.StartTime < GraphStartTime and aTimeLineElement.StartTime + aTimeLineElement.Duration > GraphEndTime)
end
function GraphTimeLine:isMouseAboveTimeLine()
	local MousePosition = GlobalMouse:getPosition()
	return (MousePosition > self.Position and MousePosition < self.Position + self.Size)
end

function GraphTimeLine:snapObjectToTimeLine()
	local MousePosition = GlobalMouse:getPosition()
	local TimeLinePosition = self.Position
	GlobalMouse.ObjectBeingHold:setPosition(Coordinate2D(MousePosition.x,TimeLinePosition.y))
end

function GraphTimeLine:getPosition()
	return self.Position
end

function GraphTimeLine:removeTimeLineElement(aTimeLineElement)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("GraphTimeLine.class:removeTimeLineElement") end
	---PERTTYFUNCTION---
	for k,v in ipairs(self.TimeLineElements) do
		if v == aTimeLineElement then
			table.remove(self.TimeLineElements,k)
			outputChatBox("Something removed, elements left: "..#self.TimeLineElements.. " on key ".. k)
			break
		end
	end
end

function GraphTimeLine:addGraphTimeLineElement(aTimeLineElement)
	table.insert(self.TimeLineElements,aTimeLineElement)
	outputChatBox("new element added, new element count "..#self.TimeLineElements.. " at : "..aTimeLineElement.StartTime)
end

function GraphTimeLine:updateGraphTimeLineElements()
	for k,v in ipairs(self.TimeLineElements) do
		v:setPosition(Coordinate2D(self.ParentGraph:getPositionOnGraphFromTime(v.StartTime) - self.ParentGraph.Position.x,v:getPosition().y))
	end	
end

function GraphTimeLine:deleteSelectedTimeLineElements()
	for k,v in ipairs(self.TimeLineElements) do
		if v:isSelected() then
			self:removeTimeLineElement(v)
		end
	end
end

function GraphTimeLine:getTimeLineElements()
	return self.TimeLineElements
end
