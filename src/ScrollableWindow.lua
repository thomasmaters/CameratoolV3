--- @type ScrollableWindow
-- @extends #Gui 
ScrollableWindow = Gui:subclass("ScrollableWindow")

function ScrollableWindow:init(aPosition, aSize)
  self.Position = aPosition or Coordinate2D()
  self.Size = aSize or Coordinate2D()
  self.ScrollWindowRenderTarget = dxCreateRenderTarget( aSize.x, aSize.y, true )
  
  GlobalInterface:addGuiElementToRenderStack(self)
end

function ScrollableWindow:draw()
  dxSetRenderTarget(self.ScrollWindowRenderTarget)
  dxSetRenderTarget()
  dxDrawImage( self.Position.x, self.Position.y, self.Size.x, self.Size.y, self.ScrollWindowRenderTarget )  
end