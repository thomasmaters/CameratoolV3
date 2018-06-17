PathCamTarget = Path:subclass("PathCamTarget")

function PathCamTarget:init(aAnimationStartTime, aAnimationDuration, aAnimationType, bIsPathSelected, bIsPathDragged)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("PathCamTarget.class:init") end
	---PERTTYFUNCTION---
	
	self.super:init(aAnimationStartTime, aAnimationDuration, aAnimationType, bIsPathSelected, bIsPathDragged)
	self.PathRectangle = Rectangle(Coordinate2D(0,0),Coordinate2D(100,30),nil,nil,GlobalConstants.CAM_TARGET_PATH_COLOR,nil,false) or nil
end

function PathCamTarget:updateSelectedColor()
	if(self.bPathSelected) then 
		self.PathRectangle.PrimaryColor = GlobalConstants.CAM_TARGET_PATH_COLOR_SELECTED
	else
		self.PathRectangle.PrimaryColor = GlobalConstants.CAM_TARGET_PATH_COLOR
	end
end

function PathCamTarget:draw()
	self.PathRectangle:draw()
end

