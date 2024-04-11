Database = newclass("Database")

function Database:init()
    self.connection = nil
end

function Database:connect()
    self.connection = dbConnect( "sqlite", "cameratoolv3.db" )
    if (not self.connection) then
        outputDebugString("Error: Failed to establish connection to the SQlite database server")
    else
        outputDebugString("Success: Connected to the SQLite database server")
    end
end

function Database:query(...)
    local queryHandle = dbQuery(self.connection, ...)
    if (not queryHandle) then
        return nil
    end
    local rows = dbPoll(queryHandle, -1)
    return rows
end
 
function Database:execute(...)
    local queryHandle = dbQuery(self.connection, ...)
    local result, numRows = dbPoll(queryHandle, -1)
    return numRows
end

function Database:getDBConnection()
    return self.connection
end

function Database:disconnect()
    destroyElement(self.connection)
end

function Database:createTables()
    self.query("CREATE TABLE IF NOT EXISTS recording (name TEXT)")
    self.query("CREATE TABLE IF NOT EXISTS settings (name TEXT NOT NULL, value TEXT)")
    self.query("CREATE TABLE IF NOT EXISTS graph (name TEXT, value TEXT)")
    self.query("CREATE TABLE IF NOT EXISTS timeline (name TEXT, value BLOB)")
end