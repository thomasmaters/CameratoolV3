--- @type UpdateHandler
UpdateHandler = newclass("UpdateHandler")

function UpdateHandler:init()
    ---@field [parent=#UpdateHandler] #list<#function> StoredUpdateHandlers Handlers to call when the guiElement is updated.
    self.StoredUpdateHandlers = {}
end

function UpdateHandler:callUpdateHandlers()
    for k,handler in ipairs(self.StoredUpdateHandlers) do
        handler(self)
    end
end

function UpdateHandler:addUpdateHandler(aHandler)
    if(type(aHandler) == "function") then
        table.insert(self.StoredUpdateHandlers, aHandler)
    end
end

function UpdateHandler:removeUpdateHandler(aIndex)
    local index = aIndex or #self.StoredUpdateHandlers
    table.remove(self.StoredUpdateHandlers, index)
end

function UpdateHandler:clearUpdateHandlers()
    for k,v in ipairs (self.StoredUpdateHandlers) do
        self.StoredUpdateHandlers[k] = nil
    end
end
