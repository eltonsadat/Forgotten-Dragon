--powerUp

powerUp = {}
powerUp["x"] = -100
powerUp["y"] = -100
powerUp["width"] = powerUp.x + 64
powerUp["height"] = powerUp.y + 64
powerUp["velocidade"] = 150
powerUp["velocidadeIncremento"] = 0
powerUp["tempoRenascimento"] = 0
powerUp["random"] = false
powerUp["randomTipo"] = false
powerUp["estado"] = 0 -- 0:inativo; 1:surgiu e se locomove (vivo); 2:coletado (morto)

powerUp["tipoNum"] = 0
powerUp["tipo"] = {}
powerUp.tipo["imagemShield"] = love.graphics.newImage ("personagens/dragao/powerUp/img/icones/shield.png") -- tipo 1
powerUp.tipo["imagemBomb"] = love.graphics.newImage ("personagens/dragao/powerUp/img/icones/bomb.png") -- tipo 2

function powerUp:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function powerUp:dragaoColisao(dragaoInstancia)
	if self.estado == 1 and dragaoInstancia.estado ~= 2 then
		if (self.width >= dragaoInstancia.boxX and self.x <= dragaoInstancia.boxWidth)
		and (self.height >= dragaoInstancia.boxY and self.y <= dragaoInstancia.boxHeight) then
			self.estado = 2
			dragaoInstancia.powerUpTipoColetado = self.tipoNum
		end
	end
end

function powerUp:surgir(inimigoInstancia)

	if (inimigoInstancia.estado == 1 or inimigoInstancia.estado == 2) and self.estado == 0 then --inimigo morto	-- Adicionado condição estado == 2
		if inimigoInstancia.name ~= nil and inimigoInstancia.name == "Barco Explosivo" then				-- Adicionado
			self.x = inimigoInstancia.x + inimigoInstancia.width/3
			self.y = inimigoInstancia.y + inimigoInstancia.height/3
		else
			self.x = inimigoInstancia.x
			self.y = inimigoInstancia.y
		end

		if self.random == false then
			local powerUpNum = math.random (20) --escolhe se vai ou nÃ£o existir powerUp
			self.random = true

			if powerUpNum == 1 then

				if self.randomTipo == false then
					local tipoNum = math.random (1, 2) --escolhe o tipo de powerUp
					self.tipoNum = tipoNum
					self.randomTipo = true
				end

				self.estado = 1 --surge e se locomove
			end
		end

	else
		self.randomTipo = false
		self.random = false
	end
end

function powerUp:draw()
	if self.estado == 1 then
		if self.tipoNum == 1 then
			love.graphics.setColor(255,255,255,255)
			love.graphics.draw(self.tipo.imagemShield, self.x, self.y)
		end

		if self.tipoNum == 2 then
			love.graphics.setColor(255,255,255,255)
			love.graphics.draw(self.tipo.imagemBomb, self.x, self.y)
		end
	end
end

function powerUp:update(dt)
	if self.estado == 1 then
		self.width = self.x + 64
		self.height = self.y + 64
		self.velocidadeIncremento = self.velocidadeIncremento + 1 * dt
		self.x = self.x - self.velocidade * self.velocidadeIncremento * dt

		if self.width <= 0 then
			self.estado = 0
			self.velocidadeIncremento = 0
		end
	end

	if self.estado == 2 then
		self.tempoRenascimento = self.tempoRenascimento + 1 * dt

		if self.tempoRenascimento >= 5 then
			self.estado = 0
			self.velocidadeIncremento = 0
			self.tempoRenascimento = 0
		end
	end
	--print(self.estado, self.tempoRenascimento)
end
