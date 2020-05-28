---@type TimeLineElement
--@extends #UpdateHandler
TimeLineElement = UpdateHandler:subclass("TimeLineElement")

function TimeLineElement:init(aStartTime, aDuration, bSelected)
    ---PERTTYFUNCTION---
    if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("TimeLineElement.class:init") end
    ---PERTTYFUNCTION---
    self.super:init()

    ---@field [parent=#TimeLineElement] #number StartTime Start time of the TimeLineElement
    self.StartTime = aStartTime or 0
    ---@field [parent=#TimeLineElement] #number Duration Duration of the TimeLineElement. Can't be smaller then 1.
    self.Duration = aDuration or 0
    ---@field [parent=#TimeLineElement] #boolean bSelected Boolean indicating if the TimeLineElement is selected.
    self.bSelected = bSelected or false
end

function TimeLineElement:setDuration(aDuration)
    if(aDuration >= 1) then
        self.Duration = aDuration
        self:callUpdateHandlers()
    end
end

function TimeLineElement:setSelected()
    self.bSelected = not self.bSelected
    if self.bSelected then
        GlobalProperties:onTimeLineElementSelect(self)
        --triggerEvent("onTimeLineElementSelect", getResourceRootElement(), self)
    else
        GlobalProperties:onTimeLineElementDeselect(self)
        --triggerEvent("onTimeLineElementDeselect", getResourceRootElement(), self)
    end
end

function TimeLineElement:isSelected()
    return self.bSelected
end


function TimeLineElement:setStartTime(aStartTime)
end
