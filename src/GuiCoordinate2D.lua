---@type GuiCoordinate2D
---@extends #Gui
GuiCoordinate2D = Gui:subclass("GuiCoordinate2D")

function GuiCoordinate2D:init()
  ---@field [parent=#GuiCoordinate2D] #InputBox InputX InputBox for x coordinate.
  self.InputX = InputBox()
  ---@field [parent=#GuiCoordinate2D] #InputBox InputY InputBox for y coordinate.
  self.InputY = InputBox()
  
  self.InputX:addUpdateHandler(self:callUpdateHandler())
  self.InputY:addUpdateHandler(self:callUpdateHandler())
end

function GuiCoordinate2D:getValue()
  return Coordinate2D(self.InputX:getValue(), self.InputY:getValue());
end

function GuiCoordinate2D:setValue(aValueX, aValueY)
  if(Coordinate2D:made(aValueX)) then
    self.InputX:setValue(aValueX.x)
    self.InputY:setValue(aValueX.y)
  elseif(type(aValueX) == "table") then
    self.InputX:setValue(aValueX[1])
    self.InputY:setValue(aValueX[2])
  else
    self.InputX:setValue(aValueX)
    self.InputY:setValue(aValueY)
  end
end

function GuiCoordinate2D:destructor()
  self.InputX:destructor()
  self.InputY:destructor()
end