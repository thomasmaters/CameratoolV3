---@type Graph
Graph = newclass("Graph")

function Graph:init(aPosition, aSize)
    if not aPosition or not aSize then return error("Couldn't init graph, missing parameters") end

    self.Position = aPosition
    self.Size = aSize
    
    --- @field [parent=#Graph] #number GraphVisableDuration
    self.GraphVisableDuration = 30000
    --- @field [parent=#Graph] #number GraphCurrentTime The current time that will be the left most value.
    self.GraphCurrentTime = 0
    --- @field [parent=#Graph] #number GraphTotalTime Total time that is displayed on the graph
    self.GraphTotalTime = 20000
    --- @field [parent=#Graph] #number GraphUsedTime The total time that is used by timeline elements.
    self.GraphUsedTime = 0
    
    self.GraphAnimationTime = 0
    
    self.GraphAnimator = Interpolate(0, 1, self.GraphUsedTime, GlobalEnums.EasingTypes.Linear, true)
    self.GraphRenderTarget = dxCreateRenderTarget( aSize.x, aSize.y, true )
    self.GraphTimeLines = {}
    self.WorldVisualization = InWorldVisualization(self)

    local timeLineSliderBox = Rectangle(Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH,GlobalConstants.SCREEN_HEIGHT - 50),Coordinate2D(GlobalConstants.SCREEN_WIDTH * 0.6,50))
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
    
    addEventHandler ( "onClientPreRender", getRootElement(),
        function()
            self.GraphAnimationTime = self.GraphAnimator:getCurrentProgressValue() * self.GraphUsedTime
            dxDrawText(self.GraphAnimationTime, 0, 50,0,0,tocolor(255,255,255),5)
            self.WorldVisualization:visualizeAnimation(self.GraphAnimationTime)
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
    -- Draw graph timelines
    for k,v in ipairs(self.GraphTimeLines) do
        v:draw()
    end
    -- Draw moving cursor
    local kaas = self:getPositionOnGraphFromTime(self.GraphAnimationTime)
    
    dxDrawLine(kaas,0,kaas,self.Size.y)
    
    --TODO: Maybe change the drawing to Line class?
    for i=math.floor(self.GraphCurrentTime / 5000) - 1,math.ceil((self.GraphCurrentTime + self.GraphVisableDuration)/5000) do
        local x = self:getPositionOnGraphFromTime(i * 5000)
        dxDrawLine(x,0,x,self.Size.y)
    end
    dxSetRenderTarget()
    dxDrawImage( self.Position.x,  self.Position.y,  self.Size.x, self.Size.y, self.GraphRenderTarget )
end

--- @function [parent=#Graph] getAllTimeLineElements
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

--- @function [parent=#Graph] getGraphTimeSpan
function Graph:getGraphTimeSpan()
    return self.GraphCurrentTime, (self.GraphCurrentTime + self.GraphVisableDuration)
end

function Graph:calculatedTotalUsedTime()
    self.GraphUsedTime = 0
    for k,v in ipairs(self.GraphTimeLines) do
        local timeLinePaths = v:getTimeLineElements()
        for ke,va in ipairs(timeLinePaths) do
            if self.GraphUsedTime < (va.StartTime + va.Duration) then
                self.GraphUsedTime = (va.StartTime + va.Duration)
            end
        end
    end
    self.GraphAnimator.Duration = self.GraphUsedTime
end

--- @function [parent=#Graph] getCurrentTimeFromMousePosition
function Graph:getCurrentTimeFromMousePosition()
    local MouseOnGraph = GlobalMouse:getPosition() - self.Position
    if(MouseOnGraph > Coordinate2D(0,0) and MouseOnGraph < self.Size) then
        return math.floor(MouseOnGraph.x / self.Size.x * self.GraphVisableDuration + self.GraphCurrentTime)
    end
    return nil
end

--- @function [parent=#Graph] getPositionOnGraphFromTime
function Graph:getPositionOnGraphFromTime(aTime)
    return ((aTime - self.GraphCurrentTime) / ( self.GraphVisableDuration)* self.Size.x)
end

--- @function [parent=#Graph] isMouseAboveGraph
function Graph:isMouseAboveGraph()
    local MousePosition = GlobalMouse:getPosition()
    return (MousePosition > self.Position and MousePosition < self.Position + self.Size)
end

--- @function [parent=#Graph] getTimeLineElementWidthFromTime
function Graph:getTimeLineElementWidthFromTime(aDuration)
    if not aDuration then return end
    return aDuration / self.GraphVisableDuration * self.Size.x
end

function Graph:getTotalTime()
end

--- @function [parent=#Graph] getSize
function Graph:getSize()
    return self.Size
end

--- @function [parent=#Graph] getPosition
function Graph:getPosition()
    return self.Position
end
