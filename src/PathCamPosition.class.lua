---@type PathCamPosition
--@extends #Path
PathCamPosition = Path:subclass("PathCamPosition")

function PathCamPosition:init(aAnimationStartTime, aAnimationDuration, aAnimationType, bSelected, bIsPathDragged)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("PathCamPosition.class:init") end
	---PERTTYFUNCTION---
	
	self.super:init(aAnimationStartTime, aAnimationDuration, aAnimationType, bSelected, bIsPathDragged)
end

function PathCamPosition:getSelectedColor()
  return GlobalConstants.CAM_PATH_COLOR_SELECTED
end

function PathCamPosition:getUnSelectedColor()
  return GlobalConstants.CAM_PATH_COLOR
end

function PathCamPosition:draw()
	self.PathRectangle:draw()
	dxDrawImageSection(self.PathRectangle.GuiPosition.x,
		self.PathRectangle.GuiPosition.y,
		30 * self.PathRectangle.Size.x / 30,30,
		0,0,self.PathRectangle.Size.x / 30 * 256,256,GlobalConstants.TEXTURE_FOOT)
end