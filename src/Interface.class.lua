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
	leftWindowMain = 				Rectangle(Coordinate2D(0,GlobalConstants.SCREEN_HEIGHT - GlobalConstants.APP_HEIGHT),Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH,GlobalConstants.APP_HEIGHT), nil, 2)
	self.leftWindowButtonPlay = 	Button(Coordinate2D(0,GlobalConstants.APP_HEIGHT - 40) ,Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH,40), "Play", leftWindowMain)
	self.leftWindowButtonSync = 	Button(Coordinate2D(0,GlobalConstants.APP_HEIGHT - 76) ,Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH,40), "Sync cam positions", leftWindowMain)
	self.leftWindowButtonDelete = 	Button(Coordinate2D(0,GlobalConstants.APP_HEIGHT - 112),Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH,40), "Delete selected", leftWindowMain)
	
	leftWindowTextCamPos = 			Text(Coordinate2D(0,0), "Cam pos", 			leftWindowMain, Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH/2,40), "default", 1.4, "left")
	leftWindowTextCamLook = 		Text(Coordinate2D(0,40), "Cam look", 		leftWindowMain, Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH/2,40), "default", 1.4, "left")
	leftWindowTextEffStatic = 		Text(Coordinate2D(0,80), "Effect static", 	leftWindowMain, Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH/2,40), "default", 1.4, "left")
	leftWindowTextEffDynamic = 		Text(Coordinate2D(0,120), "Effect dynamic", leftWindowMain, Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH/2,40), "default", 1.4, "left")

	leftWindowButtonCamPos = 		Button(Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH/2,0), 	Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH/2,40), "Drag me1", leftWindowMain,0,GlobalConstants.CAM_PATH_COLOR,nil, bind(GlobalInterface.onDragAbleButtonClick,self))
	leftWindowButtonCamLook = 		Button(Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH/2,40), 	Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH/2,40), "Drag me2", leftWindowMain,0,GlobalConstants.CAM_TARGET_PATH_COLOR,nil, bind(GlobalInterface.onDragAbleButtonClick,self))
	leftWindowButtonEffStatic = 	Button(Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH/2,80), 	Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH/2,40), "Drag me3", leftWindowMain,0,GlobalConstants.STATIC_EFFECT_COLOR,nil, bind(GlobalInterface.onDragAbleButtonClick,self))
	leftWindowButtonEffDynamic = 	Button(Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH/2,120), 	Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH/2,40), "Drag me4", leftWindowMain,0,GlobalConstants.DYNAMIC_EFFECT_COLOR,nil, bind(GlobalInterface.onDragAbleButtonClick,self))
	
	timeLineWindowMain = 			Rectangle(Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH,GlobalConstants.SCREEN_HEIGHT - GlobalConstants.APP_HEIGHT ),Coordinate2D(GlobalConstants.SCREEN_WIDTH * 0.6,GlobalConstants.APP_HEIGHT - 50),nil,2)
	
	rightWindowMain = 				Rectangle(Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH + GlobalConstants.SCREEN_WIDTH * 0.6,GlobalConstants.SCREEN_HEIGHT - GlobalConstants.APP_HEIGHT ),Coordinate2D(GlobalConstants.RIGHT_WINDOW_WIDTH,GlobalConstants.APP_HEIGHT),nil,2)
	GlobalProperties:addInterfaceElement(rightWindowMain)
end

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

function Interface:addButtonClickBind(aGuiElement)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Interface.class:addButtonClickBind".. tostring(#self.InterfaceClickBindendElements)) end
	---PERTTYFUNCTION---
	table.insert(self.InterfaceClickBindendElements,aGuiElement)
end

function Interface:addGuiElementToRenderStack(aGuiElement)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Interface.class:addGuiElementToRenderStack") end
	---PERTTYFUNCTION---
	if not aGuiElement then return end
	table.insert(self.InterfaceRenderStack, aGuiElement)
end

function Interface:removeInterfaceElement(aGuiElement)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Interface.class:removeInterfaceElement") end
	---PERTTYFUNCTION---
	if not aGuiElement then return end
	for k, v in ipairs(self.InterfaceRenderStack) do
		if v == aGuiElement then
			outputChatBox("something removed render")
			table.remove(self.InterfaceRenderStack,k)
		end
	end		
	for k, v in ipairs(self.InterfaceClickBindendElements) do
		if v == aGuiElement then
		outputChatBox("something removed button")
			table.remove(self.InterfaceClickBindendElements,k)
		end
	end	
end

function Interface:drawInterface()
	--if not self:isInterfaceVisable() then return end
	for k, v in ipairs(self.InterfaceRenderStack) do
		if(type(v) == "table") then
			v:draw()
		end
	end
end

function Interface:isInterfaceVisable()
	return (self.bIsInterfaceVisable and not isEventHandlerAdded("onClientRender",getRootElement(), hideInterfaceRender))
end


