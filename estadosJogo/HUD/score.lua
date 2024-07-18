-- score

score = {}
score["x"] = 20
score["y"] = 20
score["fonteCaminho"] = "estadosJogo/HUD/img/AccidentalPresidency.ttf"
score["fonte"] = love.graphics.newFont(score.fonteCaminho, 20)
score["vida"] = true
score["valor"] = 0

function score:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function score:draw()
	if self.vida == true then
	love.graphics.setColor(121,121,255,255)
	love.graphics.rectangle("fill",self.x - 10, self.y - 5, 200 , 70)
	
	love.graphics.setColor(8,190,53,255)
	love.graphics.rectangle("fill",self.x, self.y, 180 , 60)

	love.graphics.setFont(self.fonte)
	love.graphics.setColor(0,0,0,255)
	love.graphics.print("SCORE: ", self.x, self.y)
	love.graphics.setColor(255,0,0,255)
	love.graphics.print(self.valor, self.x + 50, self.y)
	end
end

function score:adcionarPontos(inimigoInstancia)
	if self.vida == true and inimigoInstancia.adcionarPontos == true then
		self.valor = self.valor + inimigoInstancia.pontos
		inimigoInstancia.adcionarPontos = false
	end
end
