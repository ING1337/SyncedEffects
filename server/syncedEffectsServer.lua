-- SyncedEffects Server by ING

class 'SyncedEffects'

function SyncedEffects:__init(minID, maxID)
	self.minID      = minID or 1
	self.maxID      = maxID or 10000
	self.id         = self.minID
end

-- ####################################################################################################################################

function SyncedEffects:CreateEffect(effectID, position, angle, time, distance, velocity, spin)
	local args     = {}
	args.id        = self.id
	args.effect_id = effectID
	args.position  = position
	args.angle     = angle or Angle()
	args.time      = time or 10
	args.distance  = distance or 1024
	args.velocity  = velocity or Vector3()
	args.spin      = spin or Angle()
	
	self.id = self.id + 1
	if self.id > self.maxID then self.id = self.minID end
	
	Network:Broadcast("NewEffect", args)
	return args.id
end

function SyncedEffects:UpdateEffect(id, position, angle, velocity, spin, time)
	local args = {}
	args.id       = id
	args.position = position
	args.angle    = angle
	args.velocity = velocity
	args.spin     = spin
	args.time     = time
	Network:Broadcast("UE" .. id, args)
end

function SyncedEffects:RemoveEffect(eid)
	Network:Broadcast("RemoveEffect", {id = eid})
end

-- ####################################################################################################################################

syncedEffects = SyncedEffects()
