--- @type Animator

--- @return #Animator 
Animator = newclass("Animator")
		
function Animator:init()
  --- @field [parent=#Animator] #Interpolate InterpolateInstance
	self.InterpolateInstance = nil
	--- @field [parent=#Animator] #bool bAnimating 
	self.bAnimating = false
	--- @field [parent=#Animator] #int AnimationStartTime
	self.AnimationStartTime = 0
	--- @field [parent=#Animator] #Coordinate3D CurrentPosition
	self.CurrentPosition = {}
end 

---@function [parent=#Animator] isAnimating
--@return #bool 
function Animator:isAnimating()
	return self.bAnimating
end

---@function [parent=#Animator] getCurrentPosition
--@return #Coordinate3D 
function Animator:getCurrentPosition()
	return self.CurrentPosition
end

---@function [parent=#Animator] getAnimationTime
--@return #int Remaining animation time.
function Animator:getAnimationTime()
	return getTickCount() - self.AnimationStartTime
end

---@function [parent=#Animator] stopAnimating
--Sets bAnimating to false and internal logic will kill everything in the next onClientPreRender tick.
function Animator:stopAnimating()
	self.bAnimating = false
end

---@function [parent=#Animator] interpolateOver
--@field [parent=#Animator] #table timeLinePaths 
function Animator:interpolateOver(timeLinePaths)
	--local timeLinePaths = self.GraphTimeLines[1]:getTimeLineElements()
	--Sort the timeline elements so we know the first element is the first element to animate.
	if not (#timeLinePaths > 0) then return end
	if self.bAnimating then return end
	
	outputChatBox("Start animating")
	
	table.sort(timeLinePaths,
		function(a,b)
			return a.StartTime < b.StartTime
		end
	)
	
	self.bAnimating = true
	self.interpolateInstance = nil
	self.animateStartTime = getTickCount()
	
	animationPoints = {}
	index = 1
	
	--Sleep execution until a point in the graph is reached.
	function waitForNext(tickCountToWaitFor)
		outputChatBox("Sleeping")
		function sleep()
			coroutine.resume(waitRoutine)
		end
		
		addEventHandler ( "onClientPreRender", getRootElement(), sleep)
		waitRoutine = coroutine.create(
			function()
				while(tickCountToWaitFor > (getTickCount() - self.animateStartTime)) do
					--Do we need to kill ourselfs?
					if not self.bAnimating then
						outputChatBox("Stopping coroutine because animating is false")
						removeEventHandler ( "onClientPreRender", getRootElement(), sleep)
						return
					end
					coroutine.yield()
				end
				removeEventHandler ( "onClientPreRender", getRootElement(), sleep)
				prepareNext()
			end
		)
	end
	
	function prepareNext()
		outputChatBox("Prepare next")
		if index > #timeLinePaths then
			self.bAnimating = false
			return --End animation
		end
		
		if timeLinePaths[index].StartTime > (getTickCount() - self.animateStartTime) then
			waitForNext(timeLinePaths[index].StartTime)
		else
			--Construct the points to interpolate over.
			animationPoints = {}
			--Do we have a connected path in the previouse path?
			if (index ~= 1 and timeLinePaths[index - 1].ConnectedToPath ~= nil) then
				table.insert(animationPoints, timeLinePaths[index - 1].StartPosition:pack())
			else
				table.insert(animationPoints, timeLinePaths[index].StartPosition:pack())
			end
			
			table.insert(animationPoints, timeLinePaths[index].StartPosition:pack())
			table.insert(animationPoints, timeLinePaths[index].EndPosition:pack())
			
			--Do we have a connectedPath?
			if timeLinePaths[index].ConnectedToPath ~= nil then
				table.insert(animationPoints, timeLinePaths[index + 1].EndPosition:pack())
			else
				table.insert(animationPoints, timeLinePaths[index].EndPosition:pack())
			end
			print_r(animationPoints)
		
			--Start interpolating
			self.interpolateInstance = Interpolate(0,1,timeLinePaths[index].Duration, timeLinePaths[index].PathAnimationType)
			addEventHandler ( "onClientPreRender", getRootElement(), animate)
		end
	end
	
	function animate()
		local progress = self.interpolateInstance:getCurrentProgressValue()
		
		if self.bAnimating == false then
			removeEventHandler ( "onClientPreRender", getRootElement(), animate)
		end
		
		self.CurrentPosition = GlobalSpline:getPointOnSpline(animationPoints,progress)
		
		if progress >= 1 then
			removeEventHandler ( "onClientPreRender", getRootElement(), animate)
			index = index + 1
			prepareNext()
		end
	end
	
	prepareNext()
end