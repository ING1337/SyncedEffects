-- EffectGun Demo by ING

OnMouseClick = function(args)
	local sendArgs = {}
	sendArgs.id      = id
	sendArgs.button  = args.button
	sendArgs.raycast = Physics:Raycast(Camera:GetPosition(), Camera:GetAngle() * Vector3.Forward, 0, 1024)
	Network:Send("MouseTrigger", sendArgs)
end

OnMouseWheel = function(args)
	id = id + (Key:IsDown(16) and 20 or 1) * (args.delta > 0 and 1 or -1)
	if id < 0 then id = #Effects - 1 end
	if id > #Effects - 1 then id = 0 end
end

OnRender = function(args)
	Render:DrawText(Vector2(5, 5), tostring(id) .. " - " .. Effects[id + 1], Color(255, 255, 255), 23)
end

-- ####################################################################################################################################

id      = 0
Events:Subscribe("Render", OnRender)
Events:Subscribe("MouseDown", OnMouseClick)
Events:Subscribe("MouseScroll", OnMouseWheel)
