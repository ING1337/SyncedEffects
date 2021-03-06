-- EffectGun Demo by ING

TriggerEffect = function(args, player)
	if args.button == 1 then
		-- create a new synced effect
		lastEffectID = SyncedEffect:Create(args.id, args.raycast.position, nil, 10, 1024, Vector3(0, 2, 0))
	else
		-- update the last effect position
		SyncedEffect:Update(lastEffectID, args.raycast.position)
	end
end

PlayerSpawn = function(args)
	args.player:SetPosition(Vector3(-10290, 203, -3030)) -- it's funnier to test here...
	return false
end

-- ####################################################################################################################################

lastEffectID = 0
Network:Subscribe("TriggerEffect", TriggerEffect)
Events:Subscribe("PlayerSpawn", PlayerSpawn)
