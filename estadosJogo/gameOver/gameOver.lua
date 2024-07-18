-- gameOver

gameOver = {}
gameOver["x"] = (love.graphics.getWidth() / 2) - 80
gameOver["y"] =  -80
gameOver["red"] = 255
gameOver["fonte"] = love.graphics.newFont("estadosJogo/HUD/img/AccidentalPresidency.ttf", 50)
gameOver["velocidade"] = 80
gameOver["fadeVelocidade"] = 150
gameOver["vida"] = false
gameOver["etime"] = 0

function gameOver:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function gameOver:escurecerTela(dt)
	if self.etime >= 3 then
		self.red = self.red - self.fadeVelocidade * dt
		if self.red <= 0 then
			self.red = 0
		end
	end
end

function gameOver:draw()
	if self.vida == true then
		love.graphics.setBackgroundColor(0,0,0,255)
		love.graphics.setFont(self.fonte)
		love.graphics.setColor (self.red, 0 , 0 ,255)
		love.graphics.print("Game  Over", self.x, self.y)
		love.graphics.print("Your score: ", self.x - 100, self.y + 70)
		love.graphics.print(scoreGlobal, self.x + 100, self.y + 70)
	end
end

function gameOver:update(dt)
	if self.vida == true then
		if self. y <= (winHeight - 120) / 2 then
			self.y = self.y + self.velocidade * dt
		else 
			self.etime = self.etime + 1 * dt
			if self.etime >= 2 then
				self.y = self.y + self.velocidade * dt
			end
			if self.y >= winHeight then
				self.red = 255
				self.vida = false
				GameOverAtivo = false
			end
		end
		self:escurecerTela(dt)
	end
end
