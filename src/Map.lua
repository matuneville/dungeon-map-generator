--[[
    ##### Map class #####
    
    ---------------------
    - Created by Neville
    - 2024
]]

Map = Class()

function Map:init(mapSize)
    self.n = mapSize
    self.N = mapSize*mapSize

    self.graph = SquareGraph(mapSize)
    self.graph:createAdjMatrixCustom()

    self.rooms = self:createRooms()

    self.graphDepth = self.graph:dfsTree(1)

    self.graphBreadth = self.graph:bfsTree(1)
end

function Map:render()
    love.graphics.setColor(0, 0.4, 0, 1)

    -- render paths from one room to another
    for i=1, self.N do
        for j=1, self.N do
            -- draw depth paths
            if self.graphDepth.adj[i][j] == 1 then
                if self.rooms[i].row == self.rooms[j].row then
                    love.graphics.rectangle(
                        'fill',
                        self.rooms[i].x + 10,
                        self.rooms[i].y + 7.5,
                        i < j and 40 or -40, 5
                    )
                else
                    love.graphics.rectangle(
                        'fill',
                        self.rooms[i].x + 7.5,
                        self.rooms[i].y + 10,
                        5, i < j and 40 or -40
                    )
                end
            end
        end
    end

    -- render rooms
    for i=1, self.N do
        love.graphics.setColor(0, self.rooms[i].type == 1 and 0.7 or 0.9, 0, 1)
        self.rooms[i]:render()
    end
    --debugPrint(self.graphDepth)
end


function Map:createRooms()
    local rooms = {}
    local x, y = 40, 40
    local j, k = 1, 1
    for i=1, self.N do
        rooms[i] = Room(x*j, y*k, math.random(2), k, j)
        j = j + 1
        if j == self.n+1 then
            j = 1
            k = k + 1
        end
    end
    return rooms
end
