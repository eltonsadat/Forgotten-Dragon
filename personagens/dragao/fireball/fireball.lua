-- fireball

fireball = {}
fireball["x"] = 210
fireball["y"] = 150
fireball["width"] = fireball.x + 32
fireball["height"] = fireball.y + 32
fireball["nasceX"] = 210
fireball["nasceY"] = 150
fireball["velocidade"] = 1000
fireball["animTime"] = 0
fireball["animDeathTime"] = 0

fireball["estado"] = 0 -- 0: fireball inicio (desativada), 1:fireball se movendo (ativa), 2:morte (caso colida com inimigo)

fireball["fireballImagem"] = love.graphics.newImage("personagens/dragao/fireball/img/fireball.png")

fireball["fireballSpriteBatch"] = love.graphics.newSpriteBatch(fireball.fireballImagem, 5)

fireball["anim"] = {}
fireball.anim["frame1"] = love.graphics.newQuad(0, 0, 64, 64, 192, 128)
fireball.anim["frame2"] = love.graphics.newQuad(64, 0, 64, 64, 192, 128)
fireball.anim["frame3"] = love.graphics.newQuad(128, 0, 64, 64, 192, 128)
fireball.anim["destruida1"] = love.graphics.newQuad(0, 64, 64, 64, 192, 128)
fireball.anim["destruida2"] =  love.graphics.newQuad(64, 64, 64, 64, 192, 128)

fireball["id"] = fireball.fireballSpriteBatch:addq(fireball.anim.frame1, 0, 0)

function fireball:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function fireball:checarDragaoEstado(dragaoInstancia)
	self.nasceX = dragaoInstancia.x + 210
	self.nasceY = dragaoInstancia.y + 130
	

	if dragaoInstancia.atacando == true then
		self.estado = 1
		dragaoInstancia.atacando = false
	end
end

function fireball:deathFimTela()
	if self.x >= winWidth then
		self.estado = 0
	end
end

function fireball:disparoAnim(dt)
	self.animTime = self.animTime + 3 * dt
	if self.animTime > 0.1 and self.animTime < 0.2 then
		self.fireballSpriteBatch:setq(self.id, self.anim.frame1, 0, 0)
		elseif self.animTime > 0.2 and self.animTime < 0.3 then
			self.fireballSpriteBatch:setq(self.id, self.anim.frame2, 0, 0)
		elseif self.animTime > 0.3 and self.animTime < 0.4 then
			self.fireballSpriteBatch:setq(self.id, self.anim.frame3, 0, 0)
		elseif self.animTime > 0.5 then
			self.animTime = 0
	end
end

function fireball:deathAnim(dt)
	self.animDeathTime = self.animDeathTime + 3 * dt
	if self.animDeathTime > 0.1 and self.animDeathTime < 0.3 then
		self.fireballSpriteBatch:setq(self.id, self.anim.destruida1, 0, 0)
		elseif self.animDeathTime > 0.3 and self.animDeathTime < 0.5 then
			self.fireballSpriteBatch:setq(self.id, self.anim.destruida2, 0, 0)
		elseif self.animDeathTime > 0.5 then
			self.animDeathTime = 0
			self.estado = 0
	end
end

function fireball:fireballDraw()
	if self.estado ~= 0 then
		love.graphics.setColor(255,255,255,255)
		love.graphics.draw(self.fireballSpriteBatch, self.x, self.y, 0, 1, 1) --escala pela metade, já que a imagem original é 64x64.
	end
end

function fireball:fireballUpdate(dt)
	self.width = self.x + 64
	self.height = self.y + 64 
	
	if self.estado == 0 then --fireball inicio
		self.x = self.nasceX
		self.y = self.nasceY
		self.fireballSpriteBatch:setq(self.id, self.anim.frame1, 0, 0)
	end
	
	if self.estado == 1 then --fireball se movendo
		self.x = self.x + self.velocidade * dt
		self:disparoAnim(dt)
		self:deathFimTela()
	end
	
	if self.estado == 2 then --colidiu com o inimigo, estado se torna "2".
		self.animTime = 0
		self:deathAnim(dt)
	end
end
