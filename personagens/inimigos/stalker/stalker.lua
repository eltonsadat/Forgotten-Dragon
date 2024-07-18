--stalker

stalker = {}

stalker["x"] = 700
stalker["y"] = 200
stalker["width"] = stalker.x + 64
stalker["height"] = stalker.y + 48

stalker["velocidadeX"] = 250
stalker["velocidadeY"] = 100

stalker["atacando"] = false
stalker["timer"] = 0

stalker["red"] = 255
stalker["green"] = 255
stalker["blue"] = 255
stalker["alpha"] = 255

stalker["estado"] = 0 --0:vivo, 1:animacao de morte, 2:morto

stalker["imagem"] = love.graphics.newImage("personagens/inimigos/stalker/img/stalker.png")

function stalker:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function stalker:reload(X, Y)
	self.x = X
	self.y = Y
	self.estado = 0
end

function stalker:stalkerDeath()
	self.estado = 2 -- morto
end

function stalker:stalkerCollision(fireballInstancia)
	if self.estado == 0 and fireballInstancia.estado == 1 then
		if (fireballInstancia.width >= self.x and fireballInstancia.x <= self.width) and (fireballInstancia.height >= self.y and fireballInstancia.y <= self.height) then	
			self.estado = 1
			fireballInstancia.estado = 2
		end
	end
end

function stalker:stalkerDraw()
	if self.estado == 0 then --vivo
		self.red = 255
		self.green = 255
		self.blue = 255
		self.alpha = 255
		love.graphics.setColor(self.red, self.green, self.blue, self.alpha)
		love.graphics.draw (self.imagem, self.x, self.y)
	end
	
	if self.estado == 1 then --animacao de morte
		self.red = 0
		self.green = 0
		self.blue = 0
		love.graphics.setColor(self.red, self.green, self.blue, self.alpha)
		love.graphics.draw (self.imagem, self.x, self.y)
	end
end

function stalker:checarLaserEstado(laserInstancia)
	self.laserEstado = laserInstancia.estado
end

function stalker:stalkerUpdate(dt)
	--print(self.estado)

	if self.estado == 0 then --vivo
		if self.x <= winWidth/2 then
			--faz nada
		else
			self.x = self.x - self.velocidadeX * dt
		end
		if(self.y > dragao1.y + 120) then
			self.y = self.y - (self.velocidadeY*dt)
		end
		if(self.y < dragao1.y + 120) then
			self.y = self.y + (self.velocidadeY*dt)
		end
		self.width = self.x + 64
		self.height = self.y + 48
		self:tempoAnimacaoAtaque(dt)
		stalker:laserNaTela(dt)
		self:stalkerAtaque()
	end
			
	if self.estado == 1 then --animacao de morte
		self.alpha = self.alpha - 255 * dt
		laser1.y = 700
		if self.alpha <= 2 then
			self:stalkerDeath() --morto
		end
	end
end

function stalker:tempoAnimacaoAtaque(dt)
	if self.atacando == false then
		self.timer = self.timer + 1 * dt
		if self.timer >= 1 and laser1.x <= 0 then
			self.atacando = true
		end
	end
end

function stalker:laserNaTela(dt)
	laser1.x = laser1.x - laser.velocidade * dt
end

function stalker:stalkerAtaque()
	if self.atacando == true then
		laser1.x = stalker1.x
		laser1.y = stalker1.y + 24
		self.timer = 0
		self.atacando = false
	end
end
