-- SyncedEffects Server by ING

class 'SyncedEffects'

function SyncedEffects:__init(minID, maxID)
	self.minID = minID or 1
	self.maxID = maxID or 10000
	self.id    = self.minID
	
	Events:Subscribe("CreateSyncedEffect", self, self.CreateSyncedEffect)
	Events:Subscribe("UpdateSyncedEffect", self, self.UpdateSyncedEffect)
	Events:Subscribe("RemoveSyncedEffect", self, self.RemoveSyncedEffect)
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
	
	self.id = self.id + 1
	if self.id > self.maxID then self.id = self.minID end
	
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
	Network:Broadcast("CreateEffect", args)
end

function SyncedEffects:UpdateSyncedEffect(args)
	args.id = self.id
	Network:Broadcast("UpdateEffect" .. self.id, args)
end

function SyncedEffects:RemoveSyncedEffect(args)
	Network:Broadcast("RemoveEffect", {id = self.id})
end

-- ####################################################################################################################################

SyncedEffect = SyncedEffects()
