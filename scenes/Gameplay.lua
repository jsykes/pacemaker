--constants

local _W = display.contentWidth;
local _H = display.contentHeight;

--end constants

local storyboard = require( "storyboard" );
local level = require("Gameplay.Level");

local scene = storyboard.newScene();

require("HeartMonitor.HeartMonitor");

local obsMgr = require("Gameplay.Obstacles.ObstacleManager");
--local RunButton = require("objects.runButton");

local children;

local bgGroup;
local obstacleGroup;
local cloudGroup;

local heartMonitor;
local runButton;
--forward decl
local LayerGroups;
--end forward dec


LayerGroups = function()
    bgGroup = display.newGroup();
    obstacleGroup = display.newGroup();
    cloudGroup = display.newGroup();

    children:insert(bgGroup);
    children:insert(obstacleGroup);
    children:insert(cloudGroup);
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
    children = self.view;
    
    LayerGroups();
    
    level:Initialize(bgGroup, obstacleGroup, cloudGroup);
    heartMonitor = HeartMonitor.new(120);
    
    children:insert(heartMonitor.displayGroup)
    
    heartMonitor.displayGroup:toFront();
    
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    storyboard.purgeScene(_PreviousScene);
    
    level:Start();
		-- timer.performWithDelay(1000, 
		-- function()
			-- heartMonitor:changeBeat();
			-- heartMonitor:beat(500);
		-- end, 0);
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
    print("exiting gameplay scene")
    --level:Destroy();
    heartMonitor:kill();
    level:DestroyScore();
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )

end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene