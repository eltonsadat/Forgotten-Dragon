-- telaInicial

telaInicial = {}
telaInicial["x"] = 330
telaInicial["y"] = 400

telaInicial["red"] = 0
telaInicial["green"] = 0
telaInicial["blue"] = 0

telaInicial["fontAlpha"] = 0
telaInicial["fadeTime"] = 0
telaInicial["fontTime"] = 0

telaInicial["fadeVelocidade"] = 150

telaInicial["fonteCaminho"] = "estadosJogo/HUD/img/AccidentalPresidency.ttf"
telaInicial["imagemCaminho"] = "estadosJogo/telaInicial/background/dragonGameIntro.png"
telaInicial["logoCaminho"] = "estadosJogo/telaInicial/background/logoDragao.png"		---- Adicionado

telaInicial["fonte"] = love.graphics.newFont(telaInicial.fonteCaminho, 20)
telaInicial["imagem"] = love.graphics.newImage(telaInicial.imagemCaminho)
telaInicial["logo"] = love.graphics.newImage(telaInicial.logoCaminho)	--	--	--	--	---- Adicionado daqui
telaInicial["logoY"] = 80
telaInicial["logo_y_speed"] = 0
telaInicial["logo_y_speedMax"] = 15
telaInicial["logo_y_accel"] = 20
telaInicial["logoD"] = "down"											--	--	--	--	---- Até aqui

telaInicial["keyPress"] = false
telaInicial["vida"] = false
telaInicial["inicio"] = true

function telaInicial:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function telaInicial:checarAcaoJogador()
	local start =  love.joystick.isDown(1,10)

	if love.keyboard.isDown("p") or start or love.keyboard.isDown("return") then
		if self.inicio == false then
			self.keyPress = true
		end
	end
end

function telaInicial:clarearTela(dt)
	if self.inicio == true then
		self.fadeTime = self.fadeTime + 1 * dt

		if self.fadeTime >= 0.3 then
			self.red = self.red + self.fadeVelocidade * dt
			self.green = self.green + self.fadeVelocidade * dt
			self.blue = self.blue + self.fadeVelocidade * dt

			if self.red >= 253 and self.green >= 253 and self.blue >= 253 then
				self.fadeTime = 0
				self.fontAlpha = 255
				self.inicio = false
			end
		end
	end
end

function telaInicial:escurecerTela(dt)
	if self.keyPress == true and self.inicio == false then
		self.red = self.red - self.fadeVelocidade * dt
		self.green = self.green - self.fadeVelocidade * dt
		self.blue = self.blue - self.fadeVelocidade * dt
		self.fontTime = self.fontTime + 1 * dt

		if self.fontTime >= 0.1 then
			self.fontAlpha = 0
			if self.fontTime >= 0.2 then
				self.fontAlpha = 255
				self.fontTime = 0
			end
		end

		if self.red <= 2 and self.green <= 2 and self.blue <= 2 then
			self.keyPress = false
			self.red = 255
			self.green = 255
			self.blue = 255
			self.fontAlpha = 255
			self.fontTime = 0
			self.vida = false
			telaInicialAtiva = false
		end
	end
end

function telaInicial:draw()
	if self.vida == true then
		love.graphics.setBackgroundColor(32,125,13,255)
		love.graphics.setColor (self.red, self.green, self.blue, 255)
		love.graphics.draw(self.imagem,0,0)
		love.graphics.draw(self.logo,800/2 - self.logo:getWidth()/2 * 0.8, self.logoY, 0, 0.8, 0.8) -- Adicionado

		love.graphics.setFont(self.fonte)
		love.graphics.setColor (48, 0, 255, self.fontAlpha)
		love.graphics.print("Press START Button", self.x, self.y)
	else
		love.graphics.setBackgroundColor(0,0,0,0)
	end
end

function telaInicial:update(dt)
	if self.vida == true then
		self:clarearTela(dt)
		self:checarAcaoJogador()
		self:escurecerTela(dt)
	end
	-------- Adicionado daqui
	self.logoY = self.logoY + self.logo_y_speed * dt

	if self.logoD == "up" then
		if self.logo_y_speed > self.logo_y_speedMax * -1 then
			self.logo_y_speed = self.logo_y_speed - self.logo_y_accel * dt
		end
	else
		if self.logoD == "down" then
			if self.logo_y_speed < self.logo_y_speedMax then
				self.logo_y_speed = self.logo_y_speed + self.logo_y_accel * dt
			end
		end
	end


	if 		self.logoY >= 70 	and self.logoD ~= "up" 		then self.logoD = "up"
	else if self.logoY <= 60 	and self.logoD ~= "down"	then self.logoD = "down" 	end
	end
	-------- Até aqui

end
