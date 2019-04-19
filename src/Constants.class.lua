--- @type Constants

--- @return #Constants 
Constants = newclass("Constants")

function Constants:init(o)
  --- @field [parent=#Constants] #boolean ENABLE_PRETTY_FUNCTION
	self.ENABLE_PRETTY_FUNCTION = true
	--- @field [parent=#Constants] #number SCREEN_WIDTH
	self.SCREEN_WIDTH, 
	--- @field [parent=#Constants] #number SCREEN_HEIGHT
	self.SCREEN_HEIGHT = guiGetScreenSize() --Players screen size
	
	---------------------PATHCOLORS---------------------
	--- @field [parent=#Constants] #string CAM_PATH_COLOR
	self.CAM_PATH_COLOR = "#FF7A7AFF"
	--- @field [parent=#Constants] #string CAM_TARGET_PATH_COLOR
	self.CAM_TARGET_PATH_COLOR = "#7A7AEBFF"
	--- @field [parent=#Constants] #string STATIC_EFFECT_COLOR
	self.STATIC_EFFECT_COLOR = "#7EF3BDFF"
	--- @field [parent=#Constants] #string DYNAMIC_EFFECT_COLOR
	self.DYNAMIC_EFFECT_COLOR = "#FCE782FF"
	--- @field [parent=#Constants] #string CAM_PATH_COLOR_SELECTED
	self.CAM_PATH_COLOR_SELECTED = "#FF7A7AAA"
	--- @field [parent=#Constants] #string CAM_TARGET_PATH_COLOR_SELECTED
	self.CAM_TARGET_PATH_COLOR_SELECTED = "#7A7AEBAA"
	--- @field [parent=#Constants] #string STATIC_EFFECT_COLOR_SELECTED
	self.STATIC_EFFECT_COLOR_SELECTED = "#7EF3BDAA"
	--- @field [parent=#Constants] #string DYNAMIC_EFFECT_COLOR_SELECTED
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