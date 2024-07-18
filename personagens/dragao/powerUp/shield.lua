--shield

shield = {}
shield["x"] = -300
shield["y"] = 0
shield["width"] = shield.x + 200
shield["height"] = shield.y + 200
shield["alpha"] = 110
shield["resistencia"] = 3
shield["reduziuResistencia"] = false
shield["tempoDano"] = 0
shield["estado"] = 0 --0:inativo; 1:ativado; 2:dano; 3:destruido
shield["imagem"] = love.graphics.newImage("personagens/dragao/powerUp/img/efeitos/shield.png")

function shield:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function shield:colisaoInimigo(inimigoInstancia)

	if inimigoInstancia.name ~= nil and inimigoInstancia.name == "Barco Explosivo" then								-- Adicionado
		if inimigoInstancia.estado == 0 and self.estado == 1 then													--
			if (inimigoInstancia.width + inimigoInstancia.x >= self.x and inimigoInstancia.x <= self.width) 		--
			and (inimigoInstancia.height +inimigoInstancia.y >= self.y and inimigoInstancia.y <= self.height) then 	--
				self.estado = 2																						--
			end																										--
		end																											--

	else																											--
		if inimigoInstancia.estado == 0 and self.estado == 1 then
			if (inimigoInstancia.width >= self.x and inimigoInstancia.x <= self.width)
			and (inimigoInstancia.height >= self.y and inimigoInstancia.y <= self.height) then
				self.estado = 2
			end
		end
	end																												--
end

function shield:colisaoObstaculo(obstaculoInstancia)
	if obstaculoInstancia.ativo == true and self.estado == 1 then
		if (obstaculoInstancia.width >= self.x and obstaculoInstancia.x <= self.width)
		and (obstaculoInstancia.height >= self.y and obstaculoInstancia.y <= self.height) then
			self.estado = 2
		end
	end
end

function shield:draw()
	if self.estado == 1 then
		love.graphics.setColor(255, 255, 255, self.alpha)
		love.graphics.draw(self.imagem, self.x, self.y)
	end

	if self.estado == 2 then
		love.graphics.setColor(255, 10, 10, self.alpha)
		love.graphics.draw(self.imagem, self.x, self.y)
	end
end

function shield:update (dragaoInstancia, dt)
	if dragaoInstancia.powerUpAtivado == true and dragaoInstancia.powerUpNome == "shield" then
		self.estado = 1
		dragaoInstancia.colisaoAtiva = false
		dragaoInstancia.powerUpNome = "none"
		dragaoInstancia.powerUpAtivado = false
	end

	if self.estado ~= 0 then
		self.x = dragaoInstancia.x + 40
		self.y = dragaoInstancia.y + 50
		self.width = self.x + 200
		self.height = self.y + 200

		if self.estado == 2 then
			self.tempoDano = self.tempoDano + 1 * dt

			if self.reduziuResistencia == false then
				self.resistencia = self.resistencia - 1
				self.reduziuResistencia = true
			end

			if self.tempoDano >= 1.5 then
				self.reduziuResistencia = false
				self.tempoDano = 0
				self.estado = 1
			end

			if self. resistencia <= 0 then
				self.estado = 3
			end

			if self.estado == 3 then
				self.estado = 0
				self.resistencia = 3
				self.reduziuResistencia = false
				dragaoInstancia.colisaoAtiva = true
				dragaoInstancia.estado = 5
			end
		end
	end

	--print(self.estado, self.resistencia, self.tempoDano)
end
