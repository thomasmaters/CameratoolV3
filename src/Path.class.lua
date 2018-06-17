Path = newclass("Path")
Path:virtual("setSelected")
Path:virtual("updateSelectedColor")
Path:virtual("draw")
Path:virtual("setPosition")
Path:virtual("getPosition")
Path:virtual("setSize")
Path:virtual("getSize")

function Path:init(aAnimationStartTime, aAnimationDuration, aAnimationType, bIsPathSelected, bIsPathDragged)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Path.class:init") end
	---PERTTYFUNCTION---
	self.StartPosition = Coordinate3D(15 + math.random(0,15),15 + math.random(0,15),15 + math.random(0,15))
	self.EndPosition = Coordinate3D(15 + math.random(0,15) ,15 + math.random(0,15),15 + math.random(0,15))
	self.StartTime = aAnimationStartTime or 0
	self.Duration = aAnimationDuration or 3000
	self.PathAnimationType = aAnimationType or GlobalEnums.EasingTypes.Linear
	self.bPathSelected = bIsPathSelected or false
	self.ConnectedToPath = nil
	self.ConnectedFromPath = nil
	
	--GlobalInterface:addGuiElementToRenderStack(self)
end

function Path:isSelected()
	return self.bPathSelected
end

function Path:setSelected(aSelectState)
	if aSelectState == nil then 
		self.bPathSelected = true
		return
	end
	self.bPathSelected = aSelectState
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