-- SyncedEffects Server by ING

class 'SyncedEffects'

function SyncedEffects:__init(minID, maxID)
	self.minID = minID or 1
	self.maxID = maxID or 10000
	self.id    = self.minID
	Events:Subscribe("CreateSyncedEffect", self, self.CreateSyncedEffect)
end

-- ####################################################################################################################################

function SyncedEffects:Create(effectID, position, angle, time, distance, velocity, spin)
	local args     = {}
	args.id        = self.id
	args.effect_id = effectID
	args.position  = position
	args.angle     = angle
	args.time      = time
	args.distance  = distance
	args.velocity  = velocity
	args.spin      = spin
	
	self.id = self.id >= self.maxID and self.minID or self.id + 1
	Network:Broadcast("CreateEffect", args)
	return args.id
end

function SyncedEffects:Update(id, position, angle, velocity, spin, time)
	local args = {}
	args.id       = id
	args.position = position
	args.angle    = angle
	args.velocity = velocity
	args.spin     = spin
	args.time     = time
	Network:Broadcast("UpdateEffect" .. id, args)
end

function SyncedEffects:Remove(eid)
	Network:Broadcast("RemoveEffect", {id = eid})
end

-- ####################################################################################################################################

function SyncedEffects:CreateSyncedEffect(args)
	args.id = self.id
	self.id = self.id + 1
	Network:Broadcast("CreateEffect", args)
end

-- ####################################################################################################################################

SyncedEffect = SyncedEffects()
