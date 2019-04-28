--- @type ScrollableWindow
-- @extends #Gui 
ScrollableWindow = Gui:subclass("ScrollableWindow")

function ScrollableWindow:init(aPosition, aSize, aParent, aTotalSize)
  assert(aSize.x == aTotalSize.x, "Error when creating a ScrollableWindow, sidewards scroll is not supported.")
  if(aParent) then
    --aPosition = aPosition + aParent.GuiPosition
  end
  self.super:init(aPosition, aParent, nil, nil)

  ---@field [parent=#ScrollableWindow] #Coordinate2D Position 
  self.Position = aPosition or Coordinate2D()
  ---@field [parent=#ScrollableWindow] #Coordinate2D Size 
  self.Size = aSize or Coordinate2D()
  ---@field [parent=#ScrollableWindow] #Coordinate2D TotalSize 
  self.TotalSize = aTotalSize or Coordinate2D()
  
  ---@field [parent=#ScrollableWindow] #number CurrentScrollPosition 
  self.CurrentScrollPosition = 0
  
  self.ScrollWindowRenderTarget = dxCreateRenderTarget( aTotalSize.x, aTotalSize.y, true )
  self.ScrollRectangle = Rectangle(Coordinate2D(), self.Size, aParent, nil, nil, nil, false)
  self.Test = Text(Coordinate2D(), "asfdasfd", aParent, self.Size, nil, nil, nil, nil, nil, nil, nil, false)
  
  self.UIElements = {}
  
  GlobalInterface:addGuiElementToRenderStack(self)
  
  addEventHandler( "onClientKey", getRootElement(), bind(self.onScroll,self))
end

function ScrollableWindow:addUIElement(aElement)
  table.insert(self.UIElements, aElement)
end

function ScrollableWindow:clear()
  for k,v in ipairs(self.UIElements) do
    v:destructor()
    v = nil
    self.UIElements[k] = nil
  end
end

function ScrollableWindow:onScroll(button,press)
  if not(GlobalMouse:getPosition() > self.Position and GlobalMouse:getPosition() < self.Position + self.Size) then
    return
  end
  if button == "mouse_wheel_up" and self.CurrentScrollPosition < (self.TotalSize.y - self.Size.y) then
    self.CurrentScrollPosition = self.CurrentScrollPosition + GlobalConstants.FAST_SCROLL_MULTIPLIER
  end
  if button == "mouse_wheel_down" and self.CurrentScrollPosition > 0 then
    self.CurrentScrollPosition = self.CurrentScrollPosition - GlobalConstants.FAST_SCROLL_MULTIPLIER
  end
end

function ScrollableWindow:draw()
  dxSetRenderTarget(self.ScrollWindowRenderTarget)
  self.ScrollRectangle:draw()
  for k,v in ipairs(self.UIElements) do
    v:draw()
  end
  self.Test:draw()
  dxSetRenderTarget()
  dxDrawImageSection( self.Position.x, self.Position.y, self.Size.x, self.Size.y, 0, self.CurrentScrollPosition, self.Size.x, self.Size.y, self.ScrollWindowRenderTarget )  
end