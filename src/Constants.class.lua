--- @type Constants

--- @return #Constants
Constants = newclass("Constants")

function Constants:init(o)
    --- @field [parent=#Constants] #boolean ENABLE_PRETTY_FUNCTION
    self.ENABLE_PRETTY_FUNCTION = false
    --- @field [parent=#Constants] #number SCREEN_WIDTH
    self.SCREEN_WIDTH,
    --- @field [parent=#Constants] #number SCREEN_HEIGHT
    self.SCREEN_HEIGHT = guiGetScreenSize() --Players screen size

    ---------------------PATHCOLORS---------------------
    
    --- @field [parent=#Constants] #string CAM_PATH_COLOR
    self.CAM_PATH_COLOR = "#e74c3c"
    --- @field [parent=#Constants] #string CAM_TARGET_PATH_COLOR
    self.CAM_TARGET_PATH_COLOR = "#2980b9"
    --- @field [parent=#Constants] #string STATIC_EFFECT_COLOR
    self.STATIC_EFFECT_COLOR = "#27ae60"
    --- @field [parent=#Constants] #string DYNAMIC_EFFECT_COLOR
    self.DYNAMIC_EFFECT_COLOR = "#f1c40f"
    --- @field [parent=#Constants] #string CAM_PATH_COLOR_SELECTED
    self.CAM_PATH_COLOR_SELECTED = "#FF7A7AAA"
    --- @field [parent=#Constants] #string CAM_TARGET_PATH_COLOR_SELECTED
    self.CAM_TARGET_PATH_COLOR_SELECTED = "#7A7AEBAA"
    --- @field [parent=#Constants] #string STATIC_EFFECT_COLOR_SELECTED
    self.STATIC_EFFECT_COLOR_SELECTED = "#7EF3BDAA"
    --- @field [parent=#Constants] #string DYNAMIC_EFFECT_COLOR_SELECTED
    self.DYNAMIC_EFFECT_COLOR_SELECTED = "#FCE782AA"
    
    -----------------------GRAPH------------------------
    
    --- @field [parent=#Constants] #number AMOUNT_OF_TIMELINES
    self.AMOUNT_OF_TIMELINES = 8
    --- @field [parent=#Constants] #number MINIMUM_PATH_DURATION
    self.MINIMUM_PATH_DURATION = 100
    --- @field [parent=#Constants] #number BASE_SCROLL_TIME_INCREASE
    self.BASE_SCROLL_TIME_INCREASE = 1000
    --- @field [parent=#Constants] #number FAST_SCROLL_MULTIPLIER
    self.FAST_SCROLL_MULTIPLIER = 5
    --- @field [parent=#Constants] #number SLOW_SCROLL_MULITPLIER
    self.SLOW_SCROLL_MULITPLIER = 0.1
    --- @field [parent=#Constants] #number GRAPH_TOTAL_TIME_INCREASE_MULTIPLIER
    self.GRAPH_TOTAL_TIME_INCREASE_MULTIPLIER = 10 --BASE_SCROLL_TIME_INCREASE * GRAPH_TOTAL_TIME_INCREASE_MULTIPLIER = total time added

    ------------------------GUI-------------------------
    
    --- @field [parent=#Constants] #number RECTANGLE_BORDER_SIZE
    self.RECTANGLE_BORDER_SIZE = 1 --Border that is used for drawing rectangles
    --- @field [parent=#Constants] #string GUI_PRIMARY_COLOR
    self.GUI_PRIMARY_COLOR = "#2c3e50"
    --- @field [parent=#Constants] #string GUI_SECONDARY_COLOR
    self.GUI_SECONDARY_COLOR = "#95a5a6f0"
    --- @field [parent=#Constants] #string GUI_TERTIARY_COLOR
    self.GUI_TERTIARY_COLOR = "#34495e"
    --- @field [parent=#Constants] #string GUI_TEXT_COLOR
    self.GUI_TEXT_COLOR = "#ecf0f1"
    --- @field [parent=#Constants] #DxFont FONT
    self.FONT = DxFont("/Fonts/font.otf", 10, false, "antialiased") or "default"

    ------------------------INTERFACE-------------------------
    
    --- @field [parent=#Constants] #number APP_HEIGHT
    self.APP_HEIGHT = 280
    --- @field [parent=#Constants] #number LEFT_WINDOW_WIDTH
    self.LEFT_WINDOW_WIDTH = 350
    --- @field [parent=#Constants] #number RIGHT_WINDOW_WIDTH
    self.RIGHT_WINDOW_WIDTH = self.SCREEN_WIDTH - 350 - self.SCREEN_WIDTH * 0.6
    
    ------------------------DEFAULT SETTINGS------------------
    
    --- @field [parent=#Constants] #number SPLINE_TENSION
    self.SPLINE_TENSION = 0.5
    
    ------------------------TEXTURES--------------------
    
    --- @field [parent=#Constants] #DxTexture TEXTURE_EYE
    self.TEXTURE_EYE = DxTexture("/Images/eye.png")
    --- @field [parent=#Constants] #DxTexture TEXTURE_FOOT
    self.TEXTURE_FOOT = DxTexture("/Images/foot.png")
    --- @field [parent=#Constants] #DxTexture TEXTURE_LINK
    self.TEXTURE_LINK = DxTexture("/Images/link.png")
    
    ---PERTTYFUNCTION---
    if self.ENABLE_PRETTY_FUNCTION then outputDebugString("Constants.class:init") end
    ---PERTTYFUNCTION---
end
