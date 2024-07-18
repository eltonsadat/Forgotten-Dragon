--faseConcluida

require("estadosJogo/gameOver/gameOver")

herancaObjeto = gameOver:new() --herança em Lua

faseConcluida = herancaObjeto:new()
faseConcluida["green"] = 255

function faseConcluida:escurecerTela(dt)
	if self.etime >= 3 then
		self.red = self.red - self.fadeVelocidade * dt
		self.green = self.green - self.fadeVelocidade * dt
		if self.red <= 0 then
			self.red = 0
		end
		
		if self.green <= 0 then
			self.green = 0
		end
	end
end

function faseConcluida:draw()
	if self.vida == true then
		love.graphics.setBackgroundColor (0,0,0,255)
		love.graphics.setFont (self.fonte)
		love.graphics.setColor (self.red, self.green , 0 ,255)
		love.graphics.print ("Congratulations! Fase Completed", self.x - 170, self.y)
		love.graphics.print ("Your score: ", self.x - 100, self.y + 70)
		love.graphics.print (scoreGlobal, self.x + 100, self.y + 70)
	end
end

function faseConcluida:update(dt)
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
				self.green = 255
				self.vida = false
				faseConcluidaAtiva = false
			end
		end
		self:escurecerTela(dt)
	end
end
