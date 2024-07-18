--background

background = {}
background["x1"] = 0
background["x2"] = background.x1 + 800
background["velocidade"] = 50
background["vida"] = true
background["imagem1"] = love.graphics.newImage("estadosJogo/fases/fase01/img/background1.png")
background["imagem2"] = love.graphics.newImage("estadosJogo/fases/fase01/img/background1.png")

function background:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function background:draw()
	if self.vida == true then
		love.graphics.setColor(255,255,255,255)
		love.graphics.draw(self.imagem1, self.x1, 0)
		love.graphics.draw(self.imagem2, self.x2, 0)
	end
end

function background:update(dt)
	if self.vida == true then
		self.x1 = self.x1 - self.velocidade * dt
		self.x2 = self.x2 - self.velocidade * dt
		
		if self.x1 < -800 then
			self.x1 = self.x2 + 800
		end
		
		if self.x2 < -800 then
			self.x2 = self.x1 + 800
		end
	end
end
