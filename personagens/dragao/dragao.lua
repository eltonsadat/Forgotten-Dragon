-- dragao
dragao = {}

dragao["x"] = 0
dragao["y"] = 0
dragao["width"] = 135
dragao["height"] = 60

dragao["red"] = 255
dragao["green"] = 255
dragao["blue"] = 255
dragao["alpha"] = 255

dragao["velocidade"] = 300

dragao["vida"] = true
dragao["controlesAtivos"] = true
dragao["atacando"] = false
dragao["voando"] = true
dragao["estado"] = 0 -- 0: vivo, sem dano; 1:morte, contato com inimigo ou obstaculo; 3~4:estagio de renascimento.
dragao["chanceMenos"] = false
dragao["animAtaqueTime"] = false
dragao["fireballEstado"] = 0
dragao["powerUpTipoColetado"] = 0
dragao["powerUpNome"] = "none"
dragao["powerUpAtivado"] = false
dragao["colisaoAtiva"] = true

dragao["chances"] = 3

dragao["boxX"] = dragao.x + 75
dragao["boxY"] = dragao.y + 120
dragao["boxWidth"] = dragao.boxX + 135
dragao["boxHeight"] = dragao.boxY + 60

dragao["colidiuMaxWidth"] = false
dragao["colidiuMinWidth"] = false
dragao["colidiuMaxHeight"] = false
dragao["colidiuMinHeight"] = false

dragao["vooAnimTime"] = 0
dragao["ataqAnimTime"] = 0
dragao["tempoAlpha"] = 0
dragao["tempoInvulneravel"] = 0

dragao["dragaoImagem"] = love.graphics.newImage("personagens/dragao/img/dragao.png")
dragao["dragaoSpriteBatch"] = love.graphics.newSpriteBatch(dragao.dragaoImagem, 4)

dragao["anim"] = {}
dragao.anim["voo1"] = love.graphics.newQuad(0, 0, 300, 300, 900, 600)
dragao.anim["voo2"] = love.graphics.newQuad(300, 0, 300, 300, 900, 600)
dragao.anim["voo3"] = love.graphics.newQuad(600, 0, 300, 300, 900, 600)
dragao.anim["ataque"] = love.graphics.newQuad(0, 300, 300, 300, 900, 600)

dragao["id"] = dragao.dragaoSpriteBatch:addq(dragao.anim.voo1, 0, 0)

function dragao:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function dragao:setarPosicao(X, Y)
	self.x = X
	self.y = Y
end

function dragao:checarFireballEstado(fireballInstancia)
	self.fireballEstado = fireballInstancia.estado
end

function dragao:colisaoInimigo(inimigoInstancia)
	if inimigoInstancia.estado == 0 and self.estado == 0 and self.colisaoAtiva == true then
		if (inimigoInstancia.width >= self.boxX and inimigoInstancia.x <= self.boxWidth)
		and (inimigoInstancia.height >= self.boxY and inimigoInstancia.y <= self.boxHeight) then
			self.estado = 1
		end
	end
end

function dragao:colisaoObstaculo(obstaculoInstancia)
	if self.estado == 0 and self.colisaoAtiva == true then
		if (obstaculoInstancia.width >= self.boxX and obstaculoInstancia.x <= self.boxWidth)
		and (obstaculoInstancia.height >= self.boxY and obstaculoInstancia.y <= self.boxHeight) then
			self.estado = 1
		end
	end
end

function dragao:mostrarPowerUp(powerUpInstancia) --usar no metodo draw da fase
	if self.powerUpTipoColetado == 1 then
		love.graphics.setColor(255,255,255,255)
		love.graphics.draw(powerUpInstancia.tipo.imagemShield, 160, 45, 0, 1/2, 1/2)
	end

	if self.powerUpTipoColetado == 2 then
		love.graphics.setColor(255,255,255,255)
		love.graphics.draw(powerUpInstancia.tipo.imagemBomb, 160, 45, 0, 1/2, 1/2)
	end
end

function dragao:ativarPowerUp()
	if self.powerUpTipoColetado == 1 then
		self.powerUpAtivado = true
		self.powerUpNome = "shield"
		print("shield")
		self.powerUpTipoColetado = 0
	end

	if self.powerUpTipoColetado == 2 then
		self.powerUpAtivado = true
		self.powerUpNome = "bomb"
		print("bomb")
		self.powerUpTipoColetado = 0
	end
end

function dragao:reduzChances()
	if self.estado == 1 then
		self.estado = 2
		if self.estado == 2 and self.chanceMenos == false then
			self.chances = self.chances - 1
			self.chanceMenos = true
		end
	end
end

function dragao:dragaoDeath(dt)
	if self.estado == 2 then
		self.controlesAtivos = false
		self.voando = false
		self.alpha = self.alpha - 200 * dt

		if self.alpha <= 2 then
			self.estado = 3
			self.alpha = 0

			if self.chances <= 0 then
				self.vida = false
				dragaoVida = self.vida
			end
		end
	end
end

function dragao:renascer(dt)
	if self.estado == 3 then
		self:setarPosicao(-200, 40)
		self.voando = true
		self.alpha = 255
		self.estado = 4
	end

	if self.estado == 4 then
		if self.x <= 40 then
			self.x = self.x + self.velocidade * dt
		elseif self.x >= 40 then
			self.controlesAtivos = true
			self.estado = 5
		end
	end

	if self.estado >= 3 then
		self.tempoInvulneravel = self.tempoInvulneravel + 1 * dt
		self.tempoAlpha = self.tempoAlpha + 1 * dt

		if self.tempoAlpha >= 0.1 then
			self.alpha = 0
			if self.tempoAlpha >= 0.2 then
				self.alpha = 255
				self.tempoAlpha = 0
			end
		end
	end

	if self.tempoInvulneravel >= 4 then
		self.estado = 0
		self.chanceMenos = false
		self.tempoInvulneravel = 0
	end
end

function dragao:dragaoAnimVoo(dt)
	if self.voando == true and self.atacando == false then
		self.vooAnimTime = self.vooAnimTime + 1 * dt
		if self.vooAnimTime > 0.1 and self.vooAnimTime < 0.2 then
			self.dragaoSpriteBatch:setq(self.id, self.anim.voo1,0, 0)
			elseif self.vooAnimTime > 0.3 and self.vooAnimTime < 0.4 then
				self.dragaoSpriteBatch:setq(self.id, self.anim.voo2,0, 0)
			elseif self.vooAnimTime > 0.4 and self.vooAnimTime < 0.5 then
				self.dragaoSpriteBatch:setq(self.id, self.anim.voo3,0, 0)
			elseif self.vooAnimTime > 0.5 and self.vooAnimTime < 0.6 then
				self.dragaoSpriteBatch:setq(self.id, self.anim.voo2, 0, 0)
			elseif self.vooAnimTime > 0.6 then
				self.dragaoSpriteBatch:setq(self.id, self.anim.voo1, 0, 0)
				self.vooAnimTime = 0
		end
	end
end

function dragao:controlesKeyboard(dt)
	local keyboard_Left 		= love.keyboard.isDown("a") or love.keyboard.isDown("left")		-- Modificado
	local keyboard_Right 		= love.keyboard.isDown("d") or love.keyboard.isDown("right")	-- Modificado
	local keyboard_Up 			= love.keyboard.isDown("w") or love.keyboard.isDown("up")		-- Modificado
	local keyboard_Down 		= love.keyboard.isDown("s") or love.keyboard.isDown("down")		-- Modificado
	local keyboard_Ataque 		= love.keyboard.isDown("l") or love.keyboard.isDown("c")		-- Modificado
	local keyboard_usarPowerUp 	= love.keyboard.isDown("k") or love.keyboard.isDown("x")		-- Modificado


	if self.controlesAtivos == true then
		if keyboard_Left and self.colidiuMinWidth == false then
			self.x = self.x - self.velocidade * dt
		end

		if keyboard_Right and self.colidiuMaxWidth == false then
			self.x = self.x + self.velocidade * dt
		end

		if keyboard_Up and self.colidiuMinHeight == false then
			self.y = self.y - self.velocidade * dt
		end

		if keyboard_Down and self.colidiuMaxHeight == false then
			self.y = self.y + self.velocidade * dt
		end

		if keyboard_Ataque and self.fireballEstado == 0 then
			self.atacando = true
			self.animAtaqueTime = true
		end

		if keyboard_usarPowerUp and self.powerUpTipoColetado ~= 0 then
			 self:ativarPowerUp()
		end
	end
end

function dragao:controlesJoystick(dt)
	if self.controlesAtivos == true then
		local direction_Left_Right = love.joystick.getAxis(1,1)
		local direction_Up_Down = love.joystick.getAxis(1,2)
		local shoot =  love.joystick.isDown(1,4)
		local usarPowerUp =  love.joystick.isDown(1,3)

		if direction_Left_Right > 0 and self.colidiuMaxWidth == false then
			self.x = self.x + (direction_Left_Right * self.velocidade * dt)
		end

		if direction_Left_Right < 0 and self.colidiuMinWidth == false then
			self.x = self.x + (direction_Left_Right * self.velocidade * dt)
		end

		if direction_Up_Down > 0 and self.colidiuMaxHeight == false then
			self.y = self.y + (direction_Up_Down * self.velocidade * dt)
		end

		if direction_Up_Down < 0 and self.colidiuMinHeight == false then
			self.y = self.y + (direction_Up_Down * self.velocidade * dt)
		end

		if shoot and self.fireballEstado == 0 then
			self.atacando = true
			self.animAtaqueTime = true
		end

		if usarPowerUp and self.powerUpTipoColetado ~= 0 then
			 self:ativarPowerUp()
		end
	end
end

function dragao:AnimacaoAtaque(dt)
	if self.animAtaqueTime == true then
			self.dragaoSpriteBatch:setq(self.id, self.anim.ataque,0, 0)
			self.ataqAnimTime = self.ataqAnimTime + 1 * dt
			if self.ataqAnimTime >= 0.3 then
				self.animAtaqueTime = false
				self.ataqAnimTime = 0
			end
	end
end

function dragao:boxUpdate()
	self.boxX = self.x + 75
	self.boxY = self.y + 120
	self.boxWidth = self.boxX + 135
	self.boxHeight = self.boxY + 100 --60
end

function dragao:dragaoLimitarMovimentacao()
	if self.boxWidth >= winWidth then
		self.colidiuMaxWidth = true
	else
		self.colidiuMaxWidth = false
	end

	if self.boxX <= 0 then
		self.colidiuMinWidth = true
	else
		self.colidiuMinWidth = false
	end

	if self.boxHeight >= winHeight then
		self.colidiuMaxHeight = true
	else
		self.colidiuMaxHeight = false
	end

	if self.boxY <= 0 then
		self.colidiuMinHeight = true
	else
		self.colidiuMinHeight = false
	end
end

function dragao:dragaoDraw()
	if self.vida == true then
		if self.estado == 0 then
			self.red = 255
			self.green = 255
			self.blue = 255
			self.alpha = 255
			love.graphics.setColor(self.red, self.green, self.blue, self.alpha)
			love.graphics.draw(self.dragaoSpriteBatch, self.x, self.y)
		end

		if self.estado == 2 then
			self.red = 255
			self.green = 0
			self.blue = 0
			love.graphics.setColor(self.red, self.green, self.blue, self.alpha)
			love.graphics.draw(self.dragaoSpriteBatch, self.x, self.y)
		end

		if self.estado >= 4 then
			self.red = 255
			self.green = 255
			self.blue = 255
			love.graphics.setColor(self.red, self.green, self.blue, self.alpha)
			love.graphics.draw(self.dragaoSpriteBatch, self.x, self.y)
		end
	end
end

function dragao:dragaoUpdate(dt)
	if self.vida == true then
		self:controlesKeyboard(dt)
		self:controlesJoystick(dt)
		self:boxUpdate()
		self:dragaoLimitarMovimentacao()
		self:reduzChances()
		self:dragaoDeath(dt)
		self:renascer(dt)
		self:dragaoAnimVoo(dt)
		self:AnimacaoAtaque(dt)
		--print(self.estado, self.tempoInvulneravel, self.powerUpTipoColetado)
	end
end
