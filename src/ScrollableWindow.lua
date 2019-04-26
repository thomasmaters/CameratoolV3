--- @type ScrollableWindow
-- @extends #Gui 
ScrollableWindow = Gui:subclass("ScrollableWindow")

function ScrollableWindow:init(aPosition, aSize, aParent, aTotalSize)
  assert(aSize.x != aTotalSize.x, "Error when creating a ScrollableWindow, sidewards scroll is not supported.")
  if(aParent) then
    aPosition = aPosition + aParent.GuiPosition
  end

  ---@field [parent=#ScrollableWindow] #Coordinate2D Position 
  self.Position = aPosition or Coordinate2D()
  ---@field [parent=#ScrollableWindow] #Coordinate2D Size 
  self.Size = aSize or Coordinate2D()
  ---@field [parent=#ScrollableWindow] #Coordinate2D TotalSize 
  self.TotalSize = aTotalSize or Coordinate2D()
  
  ---@field [parent=#ScrollableWindow] #number CurrentScrollPosition 
  self.CurrentScrollPosition = 0
  
  self.ScrollWindowRenderTarget = dxCreateRenderTarget( aTotalSize.x, aTotalSize.y, true )
  self.ScrollRectangle = Rectangle(Coordinate2D(), aSize, nil, nil, nil, nil, false)
  
  self.super:init(aPosition, aParent, nil, nil)
  GlobalInterface:addGuiElementToRenderStack(self)
  
  addEventHandler( "onClientKey", getRootElement(), self.onScroll)
end

function ScrollableWindow:onScroll(button,press) 
  if button == "mouse_wheel_up" and self.CurrentScrollPosition < (self.TotalSize.y - self.Size.y) then
    self.CurrentScrollPosition = self.CurrentScrollPosition + 1
  end
  if button == "mouse_wheel_down" and self.CurrentScrollPosition > 0 then
    self.CurrentScrollPosition = self.CurrentScrollPosition - 1
  end
end

function ScrollableWindow:draw()
  dxSetRenderTarget(self.ScrollWindowRenderTarget)
  self.ScrollRectangle:draw()
  dxSetRenderTarget()
  dxDrawImageSection( self.Position.x, self.Position.y, self.TotalSize.x, self.TotalSize.y, 0, self.CurrentScrollPosition, self.Size.x, self.Size.y, self.ScrollWindowRenderTarget )  
end