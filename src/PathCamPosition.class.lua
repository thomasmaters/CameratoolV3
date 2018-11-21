PathCamPosition = Path:subclass("PathCamPosition")

function PathCamPosition:init(aAnimationStartTime, aAnimationDuration, aAnimationType, bSelected, bIsPathDragged)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("PathCamPosition.class:init") end
	---PERTTYFUNCTION---
	
	self.super:init(aAnimationStartTime, aAnimationDuration, aAnimationType, bSelected, bIsPathDragged)
	self.PathRectangle = Rectangle(Coordinate2D(0,0),Coordinate2D(100,30),nil,nil,GlobalConstants.CAM_PATH_COLOR,nil,false)
end

function PathCamPosition:updateSelectedColor()
	if(self.bSelected) then 
		self.PathRectangle.PrimaryColor = GlobalConstants.CAM_PATH_COLOR_SELECTED
		GlobalProperties:addObjectToProperties(self)
	else
		self.PathRectangle.PrimaryColor = GlobalConstants.CAM_PATH_COLOR
	end
end

function PathCamPosition:draw()
	self.PathRectangle:draw()
	dxDrawImageSection(self.PathRectangle.GuiPosition.x,
		self.PathRectangle.GuiPosition.y,
		30 * self.PathRectangle.Size.x / 30,30,
		0,0,self.PathRectangle.Size.x / 30 * 256,256,GlobalConstants.TEXTURE_FOOT)
end