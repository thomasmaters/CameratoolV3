--- @type Gui
Gui = newclass("Gui")
Gui:virtual("destructor")
Gui:virtual("getValue")
Gui:virtual("setValue")

function Gui:init(aPosition, aParent, aPrimaryColor, aSecondaryColor)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Gui.class:init") end
	---PERTTYFUNCTION---

	---@field [parent=#Gui] #Coordinate2D GuiPosition Position of the gui element on screen.
	self.GuiPosition = aPosition or Coordinate2D()
	---@field [parent=#Gui] #Gui parent Relative parent of the gui element.
	self.parent = aParent or nil
	---@field [parent=#Gui] #string SecondaryColor Secondary gui color.
	self.SecondaryColor = aSecondaryColor or GlobalConstants.GUI_SECONDARY_COLOR
	---@field [parent=#Gui] #string PrimaryColor Primary gui color.
	self.PrimaryColor = aPrimaryColor or GlobalConstants.GUI_PRIMARY_COLOR
	---@field [parent=#Gui] #string ID GuiID
	self.ID = string.random(10)
	---@field [parent=#Gui] #list<#function> GuiUpdateHandlers Handlers to call when the guiElement is updated.
	self.GuiUpdateHandlers = {}
end

function Gui:callUpdateHandlers()
  for k,handler in ipairs(self.GuiUpdateHandlers) do
    handler(self)
  end
end

function Gui:getPosition()
	return self.GuiPosition
end

function Gui:destructor()
  self.parent:destructor()
end

function Gui:addUpdateHandler(aHandler)
  if(type(aHandler) == "function") then
    table.insert(self.GuiUpdateHandlers, aHandler)
  end
end

function Gui:removeUpdateHandler(aIndex)
  local index = aIndex or #self.GuiUpdateHandlers
end
