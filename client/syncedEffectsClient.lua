-- SyncedEffects Client by ING

class 'SyncedEffects'

function SyncedEffects:__init(fps)
	self.effects    = {}
	self.fps        = 1000 / (fps or 30)
	self.timer      = Timer()
	self.lastRender = 0
	
	Events:Subscribe("Render", self, self.RenderEffects)
	Network:Subscribe("NewEffect", self, self.NewEffect)
	Network:Subscribe("RemoveEffect", self, self.RemoveEffect)
end

-- ####################################################################################################################################

function SyncedEffects:RenderEffects()
	time = self.timer:GetMilliseconds()
	
	if time > self.lastRender + self.fps  then
		for k, e in pairs(self.effects) do
			if e.time > 0 and e.time < time then
				self:RemoveEffect(e)
			else
				timing = (time - self.lastRender) / 1000
				e.position = e.position + e.velocity * timing
				e.angle    = e.angle    * self:ScaleAngle(e.spin, timing)
				e.effect:SetPosition(e.position)
				e.effect:SetAngle(e.angle)
			end
		end
		self.lastRender = time
	end
end

-- ####################################################################################################################################

function SyncedEffects:NewEffect(e)
	if Vector3.Distance(e.position, LocalPlayer:GetPosition()) <= e.distance then
		e.effect = ClientEffect.Create(AssetLocation.Game, e)
		e.sub    = Network:Subscribe("UE" .. e.id, self, self.UpdateEffect)
		if e.time > 0 then e.time = e.time * 1000 + self.timer:GetMilliseconds() end
		self.effects[e.id] = e
	end
end

function SyncedEffects:UpdateEffect(e)
	local effect = self.effects[e.id]
	if effect then
		if e.position then effect.position = e.position end
		if e.angle    then effect.angle    = e.angle end
		if e.velocity then effect.velocity = e.velocity end
		if e.spin     then effect.spin     = e.spin end
		if e.time     then effect.time     = e.time * 1000 + self.timer:GetMilliseconds() end
	end
end

function SyncedEffects:RemoveEffect(e)
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

