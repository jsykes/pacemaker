--constants
local _W = display.contentWidth;
local _H = display.contentHeight;
local rand = math.random;
local seed = math.randomseed;
local randTime = os.time;

--n units a second for obstacles
local STARTING_VELOCITY = -4;

--every certain amount of seconds, increase velocity of all obstacles
local MOD_VELOCITY = -0.5;

--each time player taps, increase speed by this amount
local PLAYER_VEL_MOD = -5;

--decrease player velocity by this amount each update
local PLAYER_DECEL = 0.2;

--max units a player can speed up other objects
local PLAYER_MAX_VEL = -30;

--if player velocity falls at or 'below' (it's negative so technically 'above') the cloud starts to come
--note - cloud always kept at a certain distance away from player offscreen
local PLAYER_VEL_CLOUD = -5;

--every n milliseconds, update obstacle velocity
local OBS_UPDATE_SPEED = 5000;

--update()'s timer
local VEL_UPDATE_TIMER = 30;

--end constants

local obsMgr = require("Gameplay.Obstacles.ObstacleManager");
local runButton = require("objects.runButton");
local jumpButton = require("objects.jumpButton");
local player = require("player");
local physics = require("physics");

local deathCloud = require("Gameplay.DeathCloud");

local level = {};

local currentObsVel;
local playerVel;
local score;
local scoreText;

--handles
local speedUpObstacles;
local scoreTimerHandle;
local handleUpdate;
--end handles

--forward decl

local AddListeners;
local RemoveListeners;
--end forward dec

function level:onDeath(e)
    --player died, stop things
    self:Destroy();
end

--listeners

function level:SlowPlayer(e)
    playerVel = (playerVel * 0.05);
end

AddListeners = function(self)
    Runtime:addEventListener("Heartbeat", self);
    Runtime:addEventListener("onDeath", self);
    Runtime:addEventListener("SlowPlayer", self);
end

RemoveListeners = function(self)
    Runtime:removeEventListener("Heartbeat", self);
    Runtime:removeEventListener("onDeath", self);
    Runtime:removeEventListener("SlowPlayer", self);
end

function level:Heartbeat(e)
    playerVel = (playerVel + PLAYER_VEL_MOD);
    
    if (playerVel < PLAYER_MAX_VEL) then 
        playerVel = PLAYER_MAX_VEL;
    end
end

-- Adds 1 to score
local function addToScore()
    scoreText:toFront();
    currentObsVel = currentObsVel or 0;
    playerVel = playerVel or 0;
    score = score + math.floor(math.abs((currentObsVel + playerVel)*.5));
    scoreText.text = score;
end


--end listeners

function level:Initialize(bgGroup, obsGroup, cloudGroup)
    physics.start();
    physics.setScale(150);
    
    local bg = display.newRect(0,0,_W,_H);
    bg:setFillColor(255,255,255);
    
    local ground = display.newRect(0,0,_W,_H * 0.015);
    ground:setFillColor(0,0,0);
    ground.x = (_W * 0.5);
    ground.y = (_H * 0.88);
    
    bgGroup:insert(bg);
    bgGroup:insert(ground);
    
    --Init score text
    score = 0;
    scoreText = display.newText(score, 0, 0, native.systemFont, 53);
    scoreText.x = _W*.85; scoreText.y = _H * .10;
    scoreText:setTextColor(255, 0, 0);
    scoreText:setReferencePoint(display.CenterLeftReferencePoint);
    scoreTimerHandle = timer.performWithDelay(200,addToScore,0);
    
    physics.addBody(ground, "static", {bounce=0});
    
    obsMgr:Initialize(obsGroup);
    deathCloud:Initialize(cloudGroup);
    
    currentObsVel = STARTING_VELOCITY;
    playerVel = 0;
    
    AddListeners(self);
    
    runButton = runButton:new();
    jumpButton = jumpButton:new();
    
    bgGroup:insert(runButton.group);
    bgGroup:insert(jumpButton.group);
    
    player.Init(obsGroup,_W*.33,_H * .5);
    -- player's gonna play.
    player.Play('Run',100);
end

function level:Start()
    obsMgr:StartSpawning(currentObsVel + (playerVel or 0));
    
    handleUpdate = timer.performWithDelay(VEL_UPDATE_TIMER, function() 
                self:Update();
        end, 0);
    
    speedUpObstacles = timer.performWithDelay(OBS_UPDATE_SPEED, function() 
            currentObsVel = (currentObsVel + MOD_VELOCITY);
            
            obsMgr:SetVelocity((currentObsVel + playerVel));
            
        end, 0);
end

function level:Update()
    
    obsMgr:MoveObstacles();
    obsMgr:SetVelocity((currentObsVel + playerVel)); 
    
    local cloudVel = 4;
    
    if (playerVel < PLAYER_VEL_CLOUD) then cloudVel = -cloudVel; end
    
    if (deathCloud:Update(cloudVel) == true) then
        --cloud reached player, stop rest of function
        return;
    end
    
            
    playerVel = (playerVel + PLAYER_DECEL);
    
    if (playerVel > 0) then playerVel = 0; end
end

function level:Destroy()
    currentObsVel = nil;
    playerVel = nil;
    
    RemoveListeners(self);
    
    timer.cancel(scoreTimerHandle);
    
    if (speedUpObstacles) then
        timer.cancel(speedUpObstacles);
    end
    
    if (handleUpdate) then
        timer.cancel(handleUpdate);
    end
    print("killing run and jump buttons")
    runButton:kill();
    jumpButton:kill();
   
    
    obsMgr:Destroy();
    deathCloud:Destroy();
    physics.stop();
end

function level:DestroyScore()
    display.remove(scoreText);
    scoreText = nil;
end

return level;