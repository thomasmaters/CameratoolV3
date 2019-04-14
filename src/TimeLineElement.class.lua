---@type TimeLineElement
TimeLineElement = newclass("TimeLineElement")

function TimeLineElement:init(aParentTimeLine, aStartTime, aDuration, bSelected)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("TimeLineElement.class:init") end
	---PERTTYFUNCTION---
	
	self.ParentTimeLine = aParentTimeLine or nil
	self.StartTime = aStartTime or 0
	self.Duration = aDuration or 0
	self.bSelected = bSelected or false
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