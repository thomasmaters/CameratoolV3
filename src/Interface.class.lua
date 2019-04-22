---@type Interface
Interface = newclass("Interface")

function Interface:init(o)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Interface.class:init") end
	---PERTTYFUNCTION---
	
	self.bIsInterfaceVisable = true
	self.InterfaceRenderStack = {}
	self.InterfaceClickBindendElements = {}
	
	bindKey ( "F2", "down", 
		function()
			triggerEvent("onRequestHideInterface",getRootElement(),not self.bIsInterfaceVisable)		
		end 
	)
	addEventHandler("onClientRender",getRootElement(),bind(self.drawInterface,self))
end

function Interface:createInterface()
	local leftWindowMain = 				Rectangle(Coordinate2D(0,GlobalConstants.SCREEN_HEIGHT - GlobalConstants.APP_HEIGHT),Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH,GlobalConstants.APP_HEIGHT), nil, 2)
	self.leftWindowButtonPlay = 	Button(Coordinate2D(0,GlobalConstants.APP_HEIGHT - 40) ,Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH,40), "Play", leftWindowMain)
	self.leftWindowButtonSync = 	Button(Coordinate2D(0,GlobalConstants.APP_HEIGHT - 76) ,Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH,40), "Sync cam positions", leftWindowMain)
	self.leftWindowButtonDelete = 	Button(Coordinate2D(0,GlobalConstants.APP_HEIGHT - 112),Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH,40), "Delete selected", leftWindowMain)
	
	local leftWindowTextCamPos = 			Text(Coordinate2D(0,0), "Cam pos", 			leftWindowMain, Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH/2,40), "default", 1.4, "left")
	local leftWindowTextCamLook = 		Text(Coordinate2D(0,40), "Cam look", 		leftWindowMain, Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH/2,40), "default", 1.4, "left")
	local leftWindowTextEffStatic = 		Text(Coordinate2D(0,80), "Effect static", 	leftWindowMain, Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH/2,40), "default", 1.4, "left")
	local leftWindowTextEffDynamic = 		Text(Coordinate2D(0,120), "Effect dynamic", leftWindowMain, Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH/2,40), "default", 1.4, "left")

	local leftWindowButtonCamPos = 		Button(Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH/2,0), 	Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH/2,40), "Drag me1", leftWindowMain,0,GlobalConstants.CAM_PATH_COLOR,nil, bind(GlobalInterface.onDragAbleButtonClick,self))
	local leftWindowButtonCamLook = 		Button(Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH/2,40), 	Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH/2,40), "Drag me2", leftWindowMain,0,GlobalConstants.CAM_TARGET_PATH_COLOR,nil, bind(GlobalInterface.onDragAbleButtonClick,self))
	local leftWindowButtonEffStatic = 	Button(Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH/2,80), 	Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH/2,40), "Drag me3", leftWindowMain,0,GlobalConstants.STATIC_EFFECT_COLOR,nil, bind(GlobalInterface.onDragAbleButtonClick,self))
	local leftWindowButtonEffDynamic = 	Button(Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH/2,120), 	Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH/2,40), "Drag me4", leftWindowMain,0,GlobalConstants.DYNAMIC_EFFECT_COLOR,nil, bind(GlobalInterface.onDragAbleButtonClick,self))
	
	local timeLineWindowMain = 			Rectangle(Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH,GlobalConstants.SCREEN_HEIGHT - GlobalConstants.APP_HEIGHT ),Coordinate2D(GlobalConstants.SCREEN_WIDTH * 0.6,GlobalConstants.APP_HEIGHT - 50),nil,2)
	
	--local rightWindowMain = 				Rectangle(Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH + GlobalConstants.SCREEN_WIDTH * 0.6,GlobalConstants.SCREEN_HEIGHT - GlobalConstants.APP_HEIGHT ),Coordinate2D(GlobalConstants.RIGHT_WINDOW_WIDTH,GlobalConstants.APP_HEIGHT),nil,2)
end

--- @function [parent=#Interface] showInterface
--@param #bool aShowing Show or hide the interface.
function Interface:showInterface(Showing)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Interface.class:showInterface") end
	---PERTTYFUNCTION---
	if Showing == nil then return end
	if isEventHandlerAdded("onClientRender",getRootElement(), hideInterfaceRender) then return end
	
	GlobalInterface.bIsInterfaceVisable = Showing	
	local InterpolateElement = Interpolate(0,GlobalConstants.APP_HEIGHT,300)
	local PreviousValue = 0
	
	function hideInterfaceRender()
		local Value = InterpolateElement:getCurrentProgressValue() * (Showing == true and -1 or 1)

		for k, v in pairs(GlobalInterface.InterfaceRenderStack) do
			local Position = v:getPosition()
			v:setPosition(Coordinate2D(Position.x,Position.y - PreviousValue + Value))
		end		
		if InterpolateElement:getCurrentProgressValue() == GlobalConstants.APP_HEIGHT then 
			removeEventHandler("onClientRender",getRootElement(),hideInterfaceRender)					
			return 
		end	
		PreviousValue = Value	
	end
	addEventHandler("onClientRender",getRootElement(),hideInterfaceRender)
	return
end

--- @function [parent=#Interface] addButtonClickBind
--@param #Gui aGuiElement Adds a button click bind on the element.
function Interface:addButtonClickBind(aGuiElement)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Interface.class:addButtonClickBind".. tostring(#self.InterfaceClickBindendElements)) end
	---PERTTYFUNCTION---
	table.insert(self.InterfaceClickBindendElements,aGuiElement)
end

--- @function [parent=#Interface] addGuiElementToRenderStack
--@param #Gui aGuiElement Adds a onClientRender call to this element.
function Interface:addGuiElementToRenderStack(aGuiElement)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Interface.class:addGuiElementToRenderStack") end
	---PERTTYFUNCTION---
	if not aGuiElement then return end
	table.insert(self.InterfaceRenderStack, aGuiElement)
end

--- @function [parent=#Interface] removeInterfaceElement
--@param #Gui aGuiElement Removes an element from the renderstack and its button click binds.
function Interface:removeInterfaceElement(aGuiElement)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Interface.class:removeInterfaceElement") end
	---PERTTYFUNCTION---
	if not aGuiElement then return end
	for k, v in ipairs(self.InterfaceRenderStack) do
		if v == aGuiElement then
			table.remove(self.InterfaceRenderStack,k)
		end
	end		
	for k, v in ipairs(self.InterfaceClickBindendElements) do
		if v == aGuiElement then
			table.remove(self.InterfaceClickBindendElements,k)
		end
	end	
end

--- @function [parent=#Interface] drawInterface
function Interface:drawInterface()
	--if not self:isInterfaceVisable() then return end
	for k, v in ipairs(self.InterfaceRenderStack) do
		if(type(v) == "table") then
			v:draw()
		end
	end
end

--- @function [parent=#Interface] isInterfaceVisable
--@return #bool Returns true if the interface is visible or when its animating to visible/invisible.
function Interface:isInterfaceVisable()
	return (self.bIsInterfaceVisable and not isEventHandlerAdded("onClientRender",getRootElement(), hideInterfaceRender))
end


