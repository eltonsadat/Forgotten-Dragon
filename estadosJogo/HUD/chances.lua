-- chances

-- score

chances = {}
chances["x"] = 20
chances["y"] = 45
chances["fonteCaminho"] = "estadosJogo/HUD/img/AccidentalPresidency.ttf"
chances["imagemChancesCaminho"] = "estadosJogo/HUD/img/dragaoChances.png"
chances["fonte"] = love.graphics.newFont(chances.fonteCaminho, 20)
chances["imagemChances"] = love.graphics.newImage(chances.imagemChancesCaminho)
chances["vida"] = true
chances["valor"] = 3

function chances:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function chances:draw()
	if self.vida == true then
	love.graphics.setFont(self.fonte)
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(self.imagemChances, self.x, self.y, 0, 1/2, 1/2)
	love.graphics.setColor(0,0,0,255)
	love.graphics.print(" = ", self.x + 35, self.y + 3)
	love.graphics.setColor(255,0,0,255)
	love.graphics.print(self.valor, self.x + 60, self.y + 5)
	end
end

function chances:checarChances(dragaoInstancia)
	if self.vida == true then
		self.valor = dragaoInstancia.chances
	end
end
