---@type InWorldVisualization
InWorldVisualization = newclass("InWorldVisualization")

function InWorldVisualization:init(aGraph)
    self.ParentGraph = aGraph or error("No graph defined for InWorldVisualization.")
    self.PositionTimeLineElements = {}
    self.TargetTimeLineElements = {}
    self.PositionSplinePoints = {}
    self.TargetSplinePoints = {}

    self.bEnableInWorldView = true

    self.AnimatedObject = createObject ( 980, 0, 0, 0)

    self.PositionAnimator = Animator() --#Animator
    self.TargetAnimator = Animator() --#Animator

    addEvent("onTimeLineElementChange", true)
    addEvent("onTimeLineElementAdded", true)
    addEvent("onTimeLineElementRemoved", true)
    addEvent("onPathChanged", true)
    addEventHandler( "onClientKey", getRootElement(), bind(self.updateInWorldView,self))
    addEventHandler( "onClientRender" , getRootElement(), bind(self.draw,self))
    addEventHandler( "onTimeLineElementChange", getRootElement(), bind(self.onTimeLineElementChange, self))
    addEventHandler( "onTimeLineElementAdded", getRootElement(), bind(self.onTimeLineElementChange, self))
    addEventHandler( "onTimeLineElementRemoved", getRootElement(), bind(self.onTimeLineElementChange, self))
    addEventHandler( "onPathChanged", getRootElement(), bind(self.onTimeLineElementChange, self))
end

function InWorldVisualization:updateInWorldView(aButton, pressOrRelease)
    if not (aButton == 'l' and pressOrRelease == false) then return end

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
    for k,v in ipairs(self.PositionSplinePoints) do
        for i=1,#v - 1 do
            dxDrawLine3D(v[i].x, v[i].y, v[i].z, v[i + 1].x, v[i + 1 ].y, v[i + 1].z, tocolor( 0, 255, 0, 230 ), 10)
        end
    end
end

function InWorldVisualization:onTimeLineElementChange(aElement)
    outputChatBox("onTimeLineElementChange")
    self:updateInWorldView('l', false)
    self.PositionAnimator:updateAnimationPoints(self.ParentGraph:getGraphTimeLine(1))
    self.TargetAnimator:updateAnimationPoints(self.ParentGraph:getGraphTimeLine(2))
end

function InWorldVisualization:visualizeAnimation(time)
    self.PositionAnimator:interpolateOver(self.ParentGraph:getGraphTimeLine(1), time)
    self.TargetAnimator:interpolateOver(self.ParentGraph:getGraphTimeLine(2), time)

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
        tempTable[k] = {}
        anotherTempTable[k] = {}
        for subKey,v in ipairs(subTable) do
            table.insert(tempTable[k],v.StartPosition:pack())
            if subKey == #subTable then
                table.insert(tempTable[k],v.EndPosition:pack())
            end
        end
        anotherTempTable[k] = GlobalSpline:getCurvePoints(tempTable[k],6)
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






