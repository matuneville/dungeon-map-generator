--[[
    ##### Square Graph class #####
    
    ---------------------
    - Created by Neville
    - 2024
]]

SquareGraph = Class()

function SquareGraph:init(n)
    self.N = n*n
    self.adj = {}
end

-- Creates a graph in which each node is neighbour to each adjacent cell in a n*n matrix
--
function SquareGraph:createAdjMatrix()
    for i=1, self.N do
        local row = {}
        for j=1, self.N do
            row[j] = 0
        end
        self.adj[i] = row
    end
end

-- Creates a graph in which each node is neighbour to each adjacent cell in a n*n matrix
--
function SquareGraph:createAdjMatrixCustom()
    local n = math.sqrt(self.N)

    for i=1, self.N do
        local row = {}
        for j=1, self.N do
            row[j] = 0

            local k = i
            local l = 1
            while k > n do
                l = l + 1
                k = k - n
            end

            if i+1 <= l*n then
                row[i+1] = 1
            end
            if i-1 > (l-1)*n then
                row[i-1] = 1
            end
            if i-n > 0 then
                row[i-n] = 1
            end
            if i+n <= self.N then
                row[i+n] = 1
            end
        end
        self.adj[i] = row
    end
end


function SquareGraph:addEdge(x, y)
    self.adj[x][y] = 1
    self.adj[y][x] = 1
end


function SquareGraph:dfsTree(startNode)
    local visited = {}  -- To keep track of visited nodes
    local dfsTree = SquareGraph(math.sqrt(self.N))  -- Create a new graph for the DFS tree
    dfsTree:createAdjMatrix()

    local function dfs(node)
        --print(node)
        visited[node] = true

        -- define a new order to traverse the neighbors
        local order = {}
        for i=1, self.N do
            order[i] = i
        end
        shuffle(order)

        for i=1, self.N do
            local neighbor = order[i]
            if self.adj[node][neighbor] == 1 and not visited[neighbor] then
                -- Add edge to dfsTree
                dfsTree:addEdge(node, neighbor)
                dfs(neighbor)  -- Recurse on the neighbor
            end
        end
    end

    dfs(startNode)  -- Start DFS from the specified node (e.g., root)

    return dfsTree
end


function SquareGraph:bfsTree(startNode)
    local visited = {}  -- To keep track of visited nodes
    local bfsTree = SquareGraph(math.sqrt(self.N))  -- Create a new graph for the BFS tree
    bfsTree:createAdjMatrix()

    local queue = {}  -- Initialize a queue for BFS traversal
    table.insert(queue, startNode)  -- Enqueue the start node

    while #queue > 0 do
        local node = table.remove(queue, 1)  -- Dequeue the front node
        visited[node] = true

        for neighbor = 1, self.N do
            if self.adj[node][neighbor] == 1 and not visited[neighbor] then
                -- Add edge to bfsTree
                bfsTree:addEdge(node, neighbor)
                table.insert(queue, neighbor)  -- Enqueue the neighbor
                visited[neighbor] = true  -- Mark the neighbor as visited
            end
        end
    end

    return bfsTree
end


function shuffle(array)
    local n = #array
    for i = n, 2, -1 do
        local j = math.random(i) -- Random index from 1 to i
        array[i], array[j] = array[j], array[i] -- Swap elements
    end
end