--- @type Animator

--- @return #Animator
Animator = newclass("Animator")

function Animator:init()
    --- @field [parent=#Animator] #Interpolate InterpolateInstance
    self.InterpolateInstance = nil
    --- @field [parent=#Animator] #boolean bAnimating
    self.bAnimating = false
    --- @field [parent=#Animator] #number AnimationStartTime
    self.AnimationStartTime = 0
    --- @field [parent=#Animator] #Coordinate3D CurrentPosition
    self.CurrentPosition = {}
    
    self.WaitRoutine = nil
end

--- @function [parent=#Animator] isAnimating
--@return #boolean
function Animator:isAnimating()
    return self.bAnimating
end

--- @function [parent=#Animator] getCurrentPosition
--@return #Coordinate3D
function Animator:getCurrentPosition()
    return self.CurrentPosition
end

--- @function [parent=#Animator] getAnimationTime
--@return #int Remaining animation time.
function Animator:getAnimationTime()
    return getTickCount() - self.AnimationStartTime
end

--- @function [parent=#Animator] stopAnimating
--Sets bAnimating to false and internal logic will kill everything in the next onClientPreRender tick.
function Animator:stopAnimating()
    self.bAnimating = false
    if animate ~= nil then
        removeEventHandler ( "onClientPreRender", getRootElement(), animate)
    end
end

--- @function [parent=#Animator] interpolateOver
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
    self.InterpolateInstance = nil
    self.AnimationStartTime = getTickCount()

    local animationPoints = {}
    local index = 1

    function prepareNext()
        outputChatBox("Prepare next")
        if index > #timeLinePaths then
            self.bAnimating = false
            return --End animation
        end

        if timeLinePaths[index].StartTime > (getTickCount() - self.AnimationStartTime) then
            waitForNext(timeLinePaths[index].StartTime)
        else
            --Construct the points to interpolate over.
            animationPoints = {}
            --Do we have a connected path in the previouse path?
            if (index ~= 1 and timeLinePaths[index - 1]:isConnectedToPath()) then
                table.insert(animationPoints, timeLinePaths[index - 1].StartPosition:pack())
            else
                table.insert(animationPoints, timeLinePaths[index].StartPosition:pack())
            end

            table.insert(animationPoints, timeLinePaths[index].StartPosition:pack())
            table.insert(animationPoints, timeLinePaths[index].EndPosition:pack())

            --Do we have a connectedPath?
            if timeLinePaths[index]:isConnectedToPath() then
                table.insert(animationPoints, timeLinePaths[index + 1].EndPosition:pack())
            else
                table.insert(animationPoints, timeLinePaths[index].EndPosition:pack())
            end
--            print_r(animationPoints)

            --Start interpolating
            self.InterpolateInstance = Interpolate(0,1,timeLinePaths[index].Duration, timeLinePaths[index].PathAnimationType)
            addEventHandler ( "onClientPreRender", getRootElement(), animate)
        end
    end
    
    --Sleep execution until a point in the graph is reached.
    function waitForNext(tickCountToWaitFor)
        outputChatBox("Sleeping")
        local function sleep()
            if coroutine.status(self.WaitRoutine) ~= 'dead' then
                coroutine.resume(self.WaitRoutine)
            end
        end

        addEventHandler ( "onClientPreRender", getRootElement(), sleep)
        self.WaitRoutine = coroutine.create(
            function()
                while(tickCountToWaitFor > (getTickCount() - self.AnimationStartTime)) do
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
    
    function animate()
        if self.bAnimating == false then
            outputChatBox("Stopping animating")
            removeEventHandler ( "onClientPreRender", getRootElement(), animate)
        else
            local progress = self.InterpolateInstance:getCurrentProgressValue()
    
            self.CurrentPosition = GlobalSpline:getPointOnSpline(animationPoints, progress)
    
            if progress >= 1 then
                removeEventHandler ( "onClientPreRender", getRootElement(), animate)
                index = index + 1
                prepareNext()
            end
        end
    end

    prepareNext()
end
