--- @type Path
-- @extends #TimeLineElement 
Path = TimeLineElement:subclass("Path")
Path:virtual("draw")
Path:virtual("setPosition")
Path:virtual("getPosition")
Path:virtual("setSize")
Path:virtual("getSize")
Path:virtual("getSelectedColor")
Path:virtual("getUnSelectedColor")

function Path:init(aStartTime, aDuration, aAnimationType, bIsSelected, bIsPathDragged)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Path.class:init") end
	---PERTTYFUNCTION---
	self.StartPosition = Coordinate3D(15 + math.random(0,50),15 + math.random(0,50),15 + math.random(0,15))
	self.EndPosition = Coordinate3D(15 + math.random(0,50) ,15 + math.random(0,50),15 + math.random(0,15))
	self.PathAnimationType = aAnimationType or GlobalEnums.EasingTypes.Linear
	self.ConnectedToPath = nil
	
	self.PathRectangle = Rectangle(Coordinate2D(0,0),Coordinate2D(100,30),nil,nil,GlobalConstants.CAM_PATH_COLOR,nil,false)
	
	self.super:init(nil, aStartTime, aDuration or 3000, bIsSelected)
end

function Path:setSelected(...)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Path.class:setSelected") end
	---PERTTYFUNCTION---
	self.bSelected = not self.bSelected
	self:updateSelectedColor()
end

function Path:updateSelectedColor()
  if(self.bSelected) then 
    self.PathRectangle.PrimaryColor = self:getSelectedColor()
  else
    self.PathRectangle.PrimaryColor = self:getUnSelectedColor()
  end
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