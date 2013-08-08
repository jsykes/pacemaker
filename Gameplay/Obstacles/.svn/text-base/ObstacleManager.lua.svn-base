--spawns/manages obstacle objects

--constants
local _W = display.contentWidth;
local _H = display.contentHeight;
local rand = math.random;
local seed = math.randomseed;
local randTime = os.time;

local obstacleTypes = {};
obstacleTypes[1] = 'cat';
obstacleTypes[2] = 'crate';
obstacleTypes[3] = 'man_hole_cover';

--10 ever at one time
local MAX_NUM_OBS = 10;

--spawn an object between lower and upper from object position furthest right
local LOWER_X_MOD = (_W * 0.5125);
local UPPER_X_MOD = (_H * 2.0);

local LOWER_Y_SPAWN = (_H * 0.8);
local UPPER_Y_SPAWN = (_H * 0.8);

--every n milliseconds, update all objects velocity
--local VEL_UPDATE_TIMER = 30;

--end constants

local listObstacles;

--added to rand spawn generator for new values
local randIndex;

local currentVel;

--handles for timers
local handleSpawnObjects;
local handleMoveObjects;

--end handles

--forward decl

local GetRightMostObject;

--end forward dec

GetRightMostObject = function()
    local rightMost;
    
    for i = 1, #listObstacles, 1 do
        local obsX = listObstacles[i].obstacle.x;
        
        if ((rightMost == nil) or (obsX > rightMost)) then
            rightMost = obsX;
        end
    end
    
    if (rightMost == nil) then --no object found, most likely at starting a new game.. spawn at default position offscreen
        rightMost = (_W * 1.5);
    end
    
    return rightMost;
end

local manager = {};

function manager:Initialize(group)
    listObstacles = {};
    
    randIndex = 0;
    
    self.group = display.newGroup();
    
    group:insert(self.group);
end

function manager:StartSpawning(vel)
    currentVel = vel;
    
    --handleMoveObjects = timer.performWithDelay(VEL_UPDATE_TIMER, function() self:MoveObstacles() end, 0);
    
    --spawn 10 obstacles altogether, destroy when get to their final position offscreen, create another upon its destruction
    local numToSpawn = (MAX_NUM_OBS - #listObstacles);
    
    for i = 1, numToSpawn, 1 do
        self:SpawnObstacle();
    end
end

function manager:SpawnObstacle()
    seed(randTime() + randIndex);
    randIndex = (randIndex + 1);
    
    --pick random obstacle
    local chosenObstacle = obstacleTypes[rand(1, #obstacleTypes)];
    
    --find rightmost object
    local rightMostObsX = GetRightMostObject();
    
    --spawn random position past rightmost object
    local newObsX = (rightMostObsX + rand(LOWER_X_MOD, UPPER_X_MOD));
    local newObsY = (rand(LOWER_Y_SPAWN, UPPER_Y_SPAWN));
    
    local obstacle = require('Gameplay.Obstacles.Obstacle');
    obstacle = obstacle:new();
    obstacle:Initialize(self.group, chosenObstacle, newObsX, newObsY);
    
    table.insert(listObstacles, obstacle);
end

--(uses timer.performwithdelay)
function manager:MoveObstacles()
    for i = 1, #listObstacles, 1 do
        listObstacles[i]:Move((currentVel));
--        print(currentVel);
        if (listObstacles[i]:IsDestroyed() == true) then
            table.remove(listObstacles, i);
            self:SpawnObstacle();
        end
    end
end

function manager:StopSpawning()
    
end

function manager:Destroy()
    currentVel = nil;
    
    if (handleMoveObjects) then
        timer.cancel(handleMoveObjects);
    end
    
    for i = 1, #listObstacles, 1 do
        listObstacles[i]:Destroy();
        listObstacles[i] = nil;
    end
    
    while (#listObstacles > 0) do
        table.remove(listObstacles, 1);
    end
    
end

--accessors

--TODO call to set player's velocity here
function manager:SetVelocity(_vel)
    currentVel = _vel;
end

--end accessors
return manager;