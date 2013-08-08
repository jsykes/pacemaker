local runButton = {};

local BUTTON_WIDTH = _W * .4;
local BUTTON_HEIGHT = _H * 1.0;

local function touch(event)
	if(event.phase == 'began')then
		Runtime:dispatchEvent({name = 'HeartbeatDown'});
	elseif(event.phase == 'ended')then
		Runtime:dispatchEvent({name = 'HeartbeatUp'});
                Runtime:dispatchEvent({name = 'Heartbeat'});
	end
end

local function tap(event)
	Runtime:dispatchEvent({name = 'Heartbeat'});
end

function runButton:new()
	local button = setmetatable({}, {__index = runButton});
	button.group = display.newGroup();
	button.rect = display.newRect(_W - BUTTON_WIDTH, _H - BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT);
	button.rect:setFillColor(255,0,0);
	button.group:insert(button.rect);
	
	button.group:addEventListener("touch", touch);
	--button.group:addEventListener("tap", tap);
        
        button.group.isVisible = false;
        button.group.isHitTestable = true;
	return button;
end

function runButton:kill()
	self.group:removeEventListener("touch", touch);
	--self.group:removeEventListener("tap", tap);
        display.remove(self.group);
end

return runButton;