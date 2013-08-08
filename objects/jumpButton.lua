local jumpButton = {};

local BUTTON_WIDTH = _W * .4;
local BUTTON_HEIGHT = _H * 1.0;

local function tap(event)
	--print("jump button tapped");
	Runtime:dispatchEvent({name = 'Jump'});
end
	
function jumpButton:new()
	local button = setmetatable({}, {__index = jumpButton});
	button.group = display.newGroup();
	button.rect = display.newRect(0, _H - BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT);
	button.rect:setFillColor(0,255,0);
	button.group:insert(button.rect);
	
	
	button.group:addEventListener("tap", tap);
        
        button.group.isVisible = false;
        button.group.isHitTestable = true;
	return button;
end

function jumpButton:kill()
	self.group:removeEventListener("tap", tap);
        
        display.remove(self.group);
end

return jumpButton;