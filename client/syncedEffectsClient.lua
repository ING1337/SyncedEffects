-- SyncedEffects Client by ING

class 'SyncedEffects'

function SyncedEffects:__init(fps)
	self.effects    = {}
	self.fps        = 1000 / (fps or 30)
	self.timer      = Timer()
	self.lastRender = 0
	
	Events:Subscribe("Render", self, self.RenderEffects)
	Network:Subscribe("CreateEffect", self, self.Create)
	Network:Subscribe("RemoveEffect", self, self.Remove)
end

-- ####################################################################################################################################

function SyncedEffects:RenderEffects()
	time = self.timer:GetMilliseconds()
	
	if time > self.lastRender + self.fps  then
		timing = (time - self.lastRender) / 1000
		self.lastRender = time
		
		for k, e in pairs(self.effects) do
			if e.time and e.time < time then
				self:Remove(e)
			else
				e.position = e.position + e.velocity * timing
				e.angle    = e.angle    * self:ScaleAngle(e.spin, timing)
				e.effect:SetPosition(e.position)
				e.effect:SetAngle(e.angle)
			end
		end
	end
end

-- ####################################################################################################################################

function SyncedEffects:Create(e)
	e.distance = e.distance or 1024
	if Vector3.Distance(e.position, LocalPlayer:GetPosition()) > e.distance then return end
	
	e.angle    = e.angle or Angle()
	e.time     = e.time and e.time * 1000 + self.timer:GetMilliseconds() or nil
	e.velocity = e.velocity or Vector3()
	e.spin     = e.spin or Angle()
	e.effect   = ClientEffect.Create(AssetLocation.Game, e)
	e.sub      = Network:Subscribe("UpdateEffect" .. e.id, self, self.Update)
	--if e.time > 0 then e.time = e.time * 1000 + self.timer:GetMilliseconds() end
	self.effects[e.id] = e
end

function SyncedEffects:Update(e)
	local effect = self.effects[e.id]
	if effect then
		if e.position then effect.position = e.position end
		if e.angle    then effect.angle    = e.angle end
		if e.velocity then effect.velocity = e.velocity end
		if e.spin     then effect.spin     = e.spin end
		if e.time     then effect.time     = e.time * 1000 + self.timer:GetMilliseconds() end
	end
end

function SyncedEffects:Remove(e)
	local effect = self.effects[e.id]
	if effect then
		effect.effect:Remove()
		Network:Unsubscribe(effect.sub)
		self.effects[e.id] = nil
	end
end

-- ####################################################################################################################################

function SyncedEffects:ScaleAngle(angle, scale)
	return Angle(angle.yaw * scale, angle.pitch * scale, angle.roll * scale)
end

-- ####################################################################################################################################

syncedEffects = SyncedEffects()
