--ghost

ghost = {}

ghost["x"] = 800
ghost["y"] = 300
ghost["width"] = ghost.x + 64
ghost["height"] =ghost.y + 64
ghost["velocidade"] = 200
ghost["pontos"] = 10

ghost["adcionarPontos"] = false

ghost["red"] = 255
ghost["green"] = 255
ghost["blue"] = 255
ghost["alpha"] = 255

ghost["estado"] = 0 --0:vivo, 1:animacao de morte, 2:morto

ghost["imagem"] = love.graphics.newImage("personagens/inimigos/ghost/img/ghost.png")

function ghost:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function ghost:reload(X, Y)
	self.x = X
	self.y = Y
	self.estado = 0
end

function ghost:ghostDeath()
	self.estado = 2 -- morto
end

function ghost:fireballColisao(fireballInstancia)
	if self.estado == 0 and fireballInstancia.estado == 1 then
		if (fireballInstancia.width >= self.x and fireballInstancia.x <= self.width) 
		and (fireballInstancia.height >= self.y and fireballInstancia.y <= self.height) then	
			self.estado = 1
			self.adcionarPontos = true
			fireballInstancia.estado = 2
		end
	end
end

function ghost:draw()
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

function ghost:ghostUpdate(dt)
	--print(self.estado)

	if self.estado == 0 then --vivo
		self.x = self.x - self.velocidade * dt
		self.width = self.x + 64
		self.height = self.y + 64
	end
			
	if self.estado == 1 then --animacao de morte
		self.alpha = self.alpha - 255 * dt
		if self.alpha <= 2 then
			self:ghostDeath() --morto
		end
	end
end
