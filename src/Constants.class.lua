Constants = newclass("Constants")

function Constants:init(o)
	self.ENABLE_PRETTY_FUNCTION = true
	self.SCREEN_WIDTH, 
	self.SCREEN_HEIGHT = guiGetScreenSize() --Players screen size
	
	---------------------PATHCOLORS---------------------
	self.CAM_PATH_COLOR = "#FF7A7AFF"
	self.CAM_TARGET_PATH_COLOR = "#7A7AEBFF"
	self.STATIC_EFFECT_COLOR = "#7EF3BDFF"
	self.DYNAMIC_EFFECT_COLOR = "#FCE782FF"
	self.CAM_PATH_COLOR_SELECTED = "#FF7A7AAA"
	self.CAM_TARGET_PATH_COLOR_SELECTED = "#7A7AEBAA"
	self.STATIC_EFFECT_COLOR_SELECTED = "#7EF3BDAA"
	self.DYNAMIC_EFFECT_COLOR_SELECTED = "#FCE782AA"
	-----------------------GRAPH------------------------
	self.AMOUNT_OF_TIMELINES = 8
	self.MINIMUM_PATH_DURATION = 100
	self.BASE_SCROLL_TIME_INCREASE = 1000
	self.FAST_SCROLL_MULTIPLIER = 5
	self.SLOW_SCROLL_MULITPLIER = 0.1
	self.GRAPH_TOTAL_TIME_INCREASE_MULTIPLIER = 10 --BASE_SCROLL_TIME_INCREASE * GRAPH_TOTAL_TIME_INCREASE_MULTIPLIER = total time added

	------------------------GUI-------------------------
	self.RECTANGLE_BORDER_SIZE = 1 --Border that is used for drawing rectangles
	self.GUI_PRIMARY_COLOR = "#FFFFFF75"
	self.GUI_SECONDARY_COLOR = "#000000F0"

	------------------------INTERFACE-------------------------
	self.APP_HEIGHT = 280
	self.LEFT_WINDOW_WIDTH = 350
	self.RIGHT_WINDOW_WIDTH = self.SCREEN_WIDTH - 350 - self.SCREEN_WIDTH * 0.6
	------------------------DEFAULT SETTINGS------------------
	self.SPLINE_TENSION = 0.5
	------------------------TEXTURES--------------------
	self.TEXTURE_EYE = DxTexture("/Images/eye.png")
	self.TEXTURE_FOOT = DxTexture("/Images/foot.png")
	self.TEXTURE_LINK = DxTexture("/Images/link.png")
	---PERTTYFUNCTION---
	if self.ENABLE_PRETTY_FUNCTION then outputDebugString("Constants.class:init") end
	---PERTTYFUNCTION---
end