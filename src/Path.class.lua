Path = TimeLineElement:subclass("Path")
Path:virtual("setSelected")
Path:virtual("updateSelectedColor")
Path:virtual("draw")
Path:virtual("setPosition")
Path:virtual("getPosition")
Path:virtual("setSize")
Path:virtual("getSize")

function Path:init(aStartTime, aDuration, aAnimationType, bIsSelected, bIsPathDragged)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Path.class:init") end
	---PERTTYFUNCTION---
	self.StartPosition = Coordinate3D(15 + math.random(0,50),15 + math.random(0,50),15 + math.random(0,15))
	self.EndPosition = Coordinate3D(15 + math.random(0,50) ,15 + math.random(0,50),15 + math.random(0,15))
	self.PathAnimationType = aAnimationType or GlobalEnums.EasingTypes.Linear
	self.ConnectedToPath = nil
	
	self.super:init(nil, aStartTime, aDuration or 3000, bIsSelected)
	--GlobalInterface:addGuiElementToRenderStack(self)
end

function Path:setStartTime(aStartTime)
	outputChatBox("JOOOOOOOOOOOOOOO we willen de starttijd zetten" ..self.StartTime)
	if not type(aStartTime) == "number" then return end
	self.StartTime = aStartTime 
end

function Path:getStartTime()
	return self.StartTime
end

function Path:setSelected(aSelectState)
	if aSelectState == nil then 
		self.bSelected = true
		return
	end
	self.bSelected = aSelectState
	self:updateSelectedColor()
end

function Path:getTimeSpan()
	return self.StartTime,self.StartTime + self.Duration
end

function Path:setPosition(aNewPosition)
	if not aNewPosition then return end
	self.PathRectangle:setPosition(aNewPosition)
end

function Path:getPosition()
	return self.PathRectangle:getPosition()
end

function Path:setSize(aNewSize)
	if not aNewSize then return end
	self.PathRectangle.Size = aNewSize
end

function Path:getSize()
	return self.PathRectangle.Size
end