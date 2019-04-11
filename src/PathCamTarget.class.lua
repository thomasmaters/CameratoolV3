---@type PathCamTarget
--@extends #Path 
PathCamTarget = Path:subclass("PathCamTarget")

function PathCamTarget:init(aAnimationStartTime, aAnimationDuration, aAnimationType, bSelected, bIsPathDragged)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("PathCamTarget.class:init") end
	---PERTTYFUNCTION---
	
	self.super:init(aAnimationStartTime, aAnimationDuration, aAnimationType, bSelected, bIsPathDragged)
	self.PathRectangle = Rectangle(Coordinate2D(0,0),Coordinate2D(100,30),nil,nil,GlobalConstants.CAM_TARGET_PATH_COLOR,nil,false) or nil
end

function PathCamTarget:getSelectedColor()
  return GlobalConstants.CAM_TARGET_PATH_COLOR_SELECTED
end

function PathCamTarget:getUnSelectedColor()
  return GlobalConstants.CAM_TARGET_PATH_COLOR
end

function PathCamTarget:draw()
	self.PathRectangle:draw()
	dxDrawImageSection(self.PathRectangle.GuiPosition.x,
		self.PathRectangle.GuiPosition.y,
		30 * self.PathRectangle.Size.x / 30,30,
		0,0,self.PathRectangle.Size.x / 30 * 256,256,GlobalConstants.TEXTURE_EYE)
end

