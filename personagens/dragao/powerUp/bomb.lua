--bomb

bomb = {}
bomb["x"] = -300
bomb["y"] = 0
bomb["alpha"] = 150
bomb["radius"] = 1
bomb["estadoAtivado"] = false

function bomb:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function bomb:destruir(inimigoInstancia)
	if inimigoInstancia.estado == 0 and self.estadoAtivado == true then
		if self.radius < 500 then
			inimigoInstancia.estado = 1 
		end
	end
end

function bomb:draw()
	if self.estadoAtivado == true then
		love.graphics.setColor(255, 10, 10, self.alpha)
		love.graphics.circle( "fill", 400, 300, self.radius, 60)
	end
end

function bomb:update (dragaoInstancia, dt)
	if dragaoInstancia.powerUpAtivado == true and dragaoInstancia.powerUpNome == "bomb" then
		self.estadoAtivado = true
		dragaoInstancia.powerUpNome = "none"
		dragaoInstancia.powerUpAtivado = false
	end
	
	if self.estadoAtivado == true then
		self.radius = self.radius + 200 * dt
		
		if self.radius >= 500 then
			self.estadoAtivado = false
			self.radius = 1
		end
	end
end
