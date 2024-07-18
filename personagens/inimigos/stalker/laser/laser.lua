-- laser

laser = {}
laser["x"] = 700
laser["y"] = 700
laser["width"] = laser.x + 30
laser["height"] = laser.y + 20
laser["nasceX"] = 210
laser["nasceY"] = 150
laser["velocidade"] = 400
laser["animTime"] = 0
laser["animDeathTime"] = 0

laser["estado"] = 1 -- 0: laser inicio (desativada), 1:laser se movendo (ativa), 2:morte (caso colida com drag�o)

laser["laserImagem"] = love.graphics.newImage("personagens/inimigos/stalker/laser/img/laser.png")
--laser["laserSpriteBatch"] = love.graphics.newSpriteBatch(laser.laserImagem, 5)

--laser["anim"] = {}
--laser.anim["frame1"] = love.graphics.newQuad(0, 0, 64, 64, 192, 128)
--laser.anim["frame2"] = love.graphics.newQuad(64, 0, 64, 64, 192, 128)
--laser.anim["frame3"] = love.graphics.newQuad(128, 0, 64, 64, 192, 128)
--laser.anim["destruida1"] = love.graphics.newQuad(0, 64, 64, 64, 192, 128)
--laser.anim["destruida2"] =  love.graphics.newQuad(64, 64, 64, 64, 192, 128)

--laser["id"] = laser.laserSpriteBatch:addq(laser.anim.frame1, 0, 0)

function laser:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function laser:reload(X, Y)
	self.x = X
	self.y = Y
end

function laser:checarStalkerEstado(stalkerInstancia)
	self.nasceX = stalkerInstancia.x
	self.nasceY = stalkerInstancia.y + 24
	
	if stalkerInstancia.atacando == true then
		self.estado = 1
	end
end

function laser:deathFim()
	if self.x <= 0 then
		self.estado = 0
	end
end

--function laser:disparoAnim(dt)
--	self.animTime = self.animTime + 1 * dt
--	if self.animTime > 0.1 and self.animTime < 0.3 then
--		self.laserSpriteBatch:setq(self.id, self.anim.frame1, 0, 0)
--		elseif self.animTime > 0.3 and self.animTime < 0.5 then
--			self.laserSpriteBatch:setq(self.id, self.anim.frame2, 0, 0)
--		elseif self.animTime > 0.5 and self.animTime < 0.7 then
--			self.laserSpriteBatch:setq(self.id, self.anim.frame3, 0, 0)
--		elseif self.animTime > 0.8 then
--			self.animTime = 0
--	end
--end

--function laser:deathAnim(dt)
--	self.animDeathTime = self.animDeathTime + 1 * dt
--	if self.animDeathTime > 0.1 and self.animDeathTime < 0.3 then
--		self.laserSpriteBatch:setq(self.id, self.anim.destruida1, 0, 0)
--		elseif self.animDeathTime > 0.3 and self.animDeathTime < 0.5 then
--			self.laserSpriteBatch:setq(self.id, self.anim.destruida2, 0, 0)
--		elseif self.animDeathTime > 0.5 then
--			self.animDeathTime = 0
--			self.estado = 0
--	end
--end

function laser:laserDraw()
	if self.estado ~= 0 then
		love.graphics.setColor(255,255,255,255)
		love.graphics.draw(self.laserImagem, self.x, self.y) --escala pela metade, já que a imagem original é 64x64.
	end
end

function laser:laserUpdate(dt)
	self.width = self.x + 30
	self.height = self.y + 20
	--print(self.estado , self.animDeathTime)
	
	if self.estado == 0 then --laser inicio
		self.x = self.nasceX
		self.y = self.nasceY
		--self.laserSpriteBatch:setq(self.id, self.anim.frame1, 0, 0)
	end
	
	if self.estado == 1 then --laser se movendo
		self.x = self.x - self.velocidade * dt
		--self:disparoAnim(dt)
		self:deathFim()
	end
	
	if self.estado == 2 then --colidiu com o inimigo, estado se torna "2".
		--self:deathAnim(dt)
		self:deathFim()
	end
end