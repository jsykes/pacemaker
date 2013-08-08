----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------
 
local storyboard = require( "storyboard" )
local scene = storyboard.newScene();
require("HeartMonitor.HeartLine");
 
 local setInvisible;
 local setVisible;

-- Menu Text Obj
local menuText;
local gameTitle;
local menuTextShowing = true;

setInvisible = function()
    transition.to(menuText, {alpha=0, time=600, onComplete=setVisible});
end

setVisible = function()
    transition.to(menuText, {alpha=1.0, time=600, onComplete=setInvisible});
end


-- Start the game on screen touch
local function screenTouched(event)
    if(event.phase == "ended") then
        _ChangeScene('scenes.tutorial');
    end
end

local heartLine;
local lineTime;

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
 
-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
        
        -- Menu Background
--	local background = display.newImage(group,"gfx/title.png",0,0,true);
	local background = display.newRect(0, 0, _W, _H);
	group:insert(background);
	heartLine = HeartLine.new(100);
	heartLine:beat();
	lineTimer = timer.performWithDelay(1200,function() heartLine:beat() end, 0);
        
	-- Game Title
	gameTitle = display.newText(group, "pace maker", 0, 0, native.systemFont, 64);
	gameTitle.x = _w; gameTitle.y = _H * .15;
	gameTitle:setTextColor(0, 0, 0);
	
	-- Menu Text
	menuText = display.newText(group, "touch screen to play", 0, 0, native.systemFont, 64);
	menuText:setReferencePoint(display.CenterReferencePoint);
	menuText.x = _w; menuText.y = _H * 0.75;
	menuText:setTextColor(0, 0, 0);
	setVisible();
end
 
 
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    storyboard.purgeScene(_PreviousScene);
	local group = self.view
        
        Runtime:addEventListener("touch", screenTouched);
end
 
 
-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
        
        Runtime:removeEventListener("touch",screenTouched);
		timer.cancel(lineTimer);
		heartLine.displayGroup:removeSelf();
	
end
 
 
-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
        
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