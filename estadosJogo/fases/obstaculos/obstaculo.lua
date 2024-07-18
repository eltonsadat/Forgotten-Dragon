-- obstaculo

obstaculo = {}

obstaculo["x"] = 800
obstaculo["y"] = 430
obstaculo["width"] = obstaculo.x + 400
obstaculo["height"] = obstaculo.y + 500
obstaculo["velocidade"] = 100--50

obstaculo["imagem"] = love.graphics.newImage("estadosJogo/fases/obstaculos/img/montanhas.png")

obstaculo["ativo"] = true

function obstaculo:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function obstaculo:reload(X, Y)
	self.x = X
	self.y = Y
end

function obstaculo:fireballColisao (fireballInstancia)
	if self.ativo == true then
		if (fireballInstancia.width >= self.x and fireballInstancia.x <= self.width) 
		and (fireballInstancia.height >= self.y and fireballInstancia.y <= self.height) then
			if fireballInstancia.estado == 1 then
				fireballInstancia.estado = 2
			end
		end
	end
end

function obstaculo:draw()
	if self.ativo == true then --vivo
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw (self.imagem, self.x, self.y)
	end
end

function obstaculo:update(dt)
	if self.ativo == true then --vivo
		self.x = self.x - self.velocidade * dt
		self.width = self.x + 400
		self.height = self.y + 500
	end
end
