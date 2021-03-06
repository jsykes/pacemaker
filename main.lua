require "CiderDebugger";-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
--Debug the smart way with Cider!
--start coding and press the debug button
-- reomve the status bar from the screen
display.setStatusBar( display.HiddenStatusBar )
system.activate("multitouch")

local storyboard = require('storyboard');
physics = require "physics";


_W = display.contentWidth;
_w = display.contentWidth * .5;
_H = display.contentHeight;
_h = display.contentHeight * .5;

_PreviousScene = nil;
_CurrentScene = nil;
_ChangeScene = function(newscene)
    storyboard.gotoScene(newscene, "fade", 800);
    _PreviousScene = _CurrentScene;
    _CurrentScene = newscene;
end


local function main()
    
    -- Load Scene
    -- Comment out to your scene so dev's faster
    _ChangeScene('scenes.mainmenu');
    
end
main();