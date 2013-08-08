module(..., package.seeall);

local movieclip = require("manager.movieclip");

local GFX_LOC = "gfx/anim/character";

-- Player animation files init on CreatePlayer
local playerAnim;

local RUN_FRAMES = {START = 1, END = 4};
local TRIP_FRAMES = {START = 5, END = 8};
local JUMP_FRAMES = {START = 9, END = 12};

local current_frame = 1;
local timerHandle;

-- Used during animation
local starting;
local ending;
local speed;
local last_run_speed = 300; --starting default
local current_anim;
local canJump;
local jumpCheck;

local function onCollision(event)
    if ((event.object1.name == "obstacle") or (event.object2.name == "obstacle")) then
        local targetObs;
        
        if (event.object1.name == "obstacle") then targetObs = event.object1; end
        if (event.object2.name == "obstacle") then targetObs = event.object2; end
        
        physics.removeBody(targetObs);
        
        Runtime:dispatchEvent({name = "SlowPlayer"});
        
        Play('Trip',200);
    elseif (jumpCheck == true) then
        --TODO JUMP 
        jumpCheck = false;
        
        timer.performWithDelay(700, function()
            canJump = true;
            print("JUMP END");
        end);
    end
    
    
    if ( event.phase == "began" ) then
        print("Collision Begin");
    elseif ( event.phase == "ended" ) then
        print("Collision Ended");
    end
end

local function playerJump(event)
    if (canJump == false) then return; end
    
    jumpCheck = true;
    canJump = false;
    print('jump');
    Play('Jump', 200,true);
    playerAnim:applyForce( 0, 14000, playerAnim.x, playerAnim.y );
end



function Init(group, w, h)
    canJump = true;
    jumpCheck = false;
    --physics.setDrawMode( "debug" );
    playerAnim = movieclip.newAnim{
           GFX_LOC..".png",GFX_LOC.."_walk1.png",GFX_LOC.."_walk2.png", GFX_LOC.."_walk3.png",
           GFX_LOC..".png",GFX_LOC.."_stumble1.png",GFX_LOC.."_stumble2.png",GFX_LOC.."_stumble3.png",
           GFX_LOC..".png",GFX_LOC.."_jump1.png",GFX_LOC.."_jump2.png",GFX_LOC.."_jump3.png"};
    playerAnim.x = w;
    playerAnim.y = h;
    -- Add a collision bounds with static
    local customBounds = {-40,120, -40,-120, 40,-120, 40,120};
    physics.addBody(playerAnim, "dynamic", {bounce=.05, density=6, shape=customBounds});
    playerAnim.isFixedRotation = true;
    Runtime:addEventListener("collision",onCollision);
    Runtime:addEventListener("Jump",playerJump);
    group:insert(playerAnim);
end

-- Cancel the timer if it exists
function CancelTimer()
    if(timerHandle ~= nil) then
        print('canceling timer');
        timer.cancel(timerHandle);
    end
end

local function Animate()
    if(current_frame < ending) then
        playerAnim:nextFrame();
        current_frame = current_frame + 1;
    else
        current_frame = starting;
        if(current_anim == 'Jump') then
            CancelTimer();
            Play('Run',last_run_speed);
            return;
        elseif(current_anim == 'Trip') then
            CancelTimer();
            Play('Run',last_run_speed);
            return;
        end
        playerAnim:play{startFrame=starting, endFrame=starting};
        
    end
    timerHandle = timer.performWithDelay(speed,Animate);
end

-- Plays the animation (string,int'miliseconds')
function Play(anim,_speed)
    CancelTimer();
    local FRAME = {START = 1, END = 2};
    if(anim == 'Run') then
        FRAME.START = RUN_FRAMES.START; FRAME.END = RUN_FRAMES.END;
        last_run_speed = _speed;
    elseif(anim == 'Trip') then
        FRAME.START = TRIP_FRAMES.START; FRAME.END = TRIP_FRAMES.END;
    elseif(anim == 'Jump') then
        FRAME.START = JUMP_FRAMES.START; FRAME.END = JUMP_FRAMES.END;
    else
        print("INVALID PLAYER ANIMATION!");
        return;
    end
    current_anim = anim;
    playerAnim:play{startFrame=FRAME.START, endFrame=FRAME.END};
    current_frame = FRAME.START;
    ending = FRAME.END;
    starting = FRAME.START;
    speed = _speed;
    Animate();
end

-- Stops the animation
function Stop()
    CancelTimer();
    playerAnim:stop();
    current_frame = 1;
end