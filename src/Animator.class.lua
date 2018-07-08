Animator = newclass("Animator")

function Animator:init()
	self.InterpolateInstance = nil
	self.bAnimating = false
	self.AnimationStartTime = 0
	self.CurrentPosition = {}
end

function Animator:isAnimating()
	return self.bAnimating
end

function Animator:getCurrentPosition()
	return self.CurrentPosition
end

--Sets bAnimating to false and internal logic will kill everything in the next onClientPreRender tick.
function Animator:stopAnimating()
	self.bAnimating = false
end

function Animator:interpolateOver(timeLinePaths)
	--local timeLinePaths = self.GraphTimeLines[1]:getTimeLineElements()
	--Sort the timeline elements so we know the first element is the first element to animate.
	if not #timeLinePaths > 0 then return end
	if self.bAnimating then return end
	
	table.sort(timeLinePaths,
		function(a,b)
			return a.StartTime < b.StartTime
		end
	)
	
	self.bAnimating = true
	self.interpolateInstance = nil
	self.animateStartTime = getTickCount()
	
	local animationPoints = {}
	local index = 1
	
	function waitForNext(tickCountToWaitFor)
		function sleep()
			coroutine.resume(waitRoutine)
		end
		
		addEventHandler ( "onClientPreRender", getRootElement(), sleep)
		waitRoutine = coroutine.create(
			function()
				while(tickCountToWaitFor > (getTickCount() - self.animateStartTime)) do
					--Do we need to kill ourselfs?
					if self.bAnimating == false then
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
				table.insert(animationPoints, timeLinePaths[index - 1].EndPosition:pack())
			else
				table.insert(animationPoints, timeLinePaths[index].StartPosition:pack())
			end
			
			table.insert(animationPoints, timeLinePaths[index].StartPosition:pack())
			table.insert(animationPoints, timeLinePaths[index].EndPosition:pack())
			
			--Do we have a connectedPath?
			if timeLinePaths[index].ConnectedToPath ~= nil then
				table.insert(animationPoints, timeLinePaths[index + 1].StartPosition:pack())
			else
				table.insert(animationPoints, timeLinePaths[index].EndPosition:pack())
			end
		
			--Start interpolating
			self.interpolateInstance = Interpolate(0,1,timeLinePaths[index].Duration, nil)
			addEventHandler ( "onClientPreRender", getRootElement(), animate)
		end
	end
	
	function animate()
		local progress = self.interpolateInstance:getCurrentProgressValue()
		
		if self.bAnimating == false then
			removeEventHandler ( "onClientPreRender", getRootElement(), animate)
		end
		
		if progress == 1 then
			removeEventHandler ( "onClientPreRender", getRootElement(), animate)
			index = index + 1
			prepareNext()
		end
		
		output = GlobalSpline:getPointOnSpline(animationPoints,progress)
		outputChatBox("x: " .. output[1] .. " y: " .. output[2].. " z: " .. output[3])
	end
	
	prepareNext()
end