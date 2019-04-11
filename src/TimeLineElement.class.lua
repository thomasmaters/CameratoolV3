---@type TimeLineElement
TimeLineElement = newclass("TimeLineElement")
TimeLineElement:virtual("setSelected")

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
  outputChatBox("TimeLineElement:setSelected()")
end

function TimeLineElement:isSelected()
	return self.bSelected
end


function TimeLineElement:setStartTime(aStartTime)
end