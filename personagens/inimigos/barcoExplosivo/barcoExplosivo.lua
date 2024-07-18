--Programador: Max


-- Modificações para corrigir os seguintes bugs:
--	1. Dragao morrer infinitamente sem tomar dano 	> Mudanças nesta classe;
--	2. Fireball não colidindo 						> Mudanças nesta classe;
--	3. Animação de morte não funcionando			> Mudanças nesta classe;
-- 	4. Bug com a HitBox do dragao					> Mudanças nesta classe; Adicionadas variáveis Width e Height fixas na classe dragao.lua;

-- Bugs:
--	1. Barco explosivo faz com que o dragão morra enquanto o mesmo está com o shield ativo, ao invés de retirar uma "carga" dele.

-- É preciso fazer com que os pontos sejam adicionados e o inimigo destruido pela bomba.

barcoExplosivo = {}

barcoExplosivo["imagem"] = love.graphics.newImage("personagens/inimigos/barcoExplosivo/img/barcoExplosivo.png")
barcoExplosivo["color"] = {255,255,255}

barcoExplosivo["name"] = "Barco Explosivo"
barcoExplosivo["x"]	= 800
barcoExplosivo["y"]	= 300
barcoExplosivo["height"] = barcoExplosivo.imagem:getHeight()
barcoExplosivo["width"]	= barcoExplosivo.imagem:getWidth()

barcoExplosivo["alpha"] = 255
barcoExplosivo["explosionRadius"] = 30
barcoExplosivo["explosionAlpha"] = 255

barcoExplosivo["x_speed"] = 200
barcoExplosivo["y_speed"] = 0
barcoExplosivo["y_speedMax"] = 100
barcoExplosivo["y_accel"] = 250

barcoExplosivo["target"] = "acquired"
barcoExplosivo["adcionarPontos"] = false
barcoExplosivo["pontos"] = 15
barcoExplosivo["estado"] = 0

local dx, dy, dw, dh	-- << Remover. Usado no debugger

-- Função de "Target": 	Enquanto estiver em "acquired" o navio perseguirá o Player. Caso estiver em "lost" o navio irá desacelerar e irá manter a altidude.
--						Caso o navio se encontre atrás do Player, seu "target" mudará para "lost" e voltará a ser "acquired" caso volte a estar na frente do Player.

function barcoExplosivo:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function barcoExplosivo:draw ()

	love.graphics.setColor(self.color[1],self.color[2],self.color[3], self.alpha)
	love.graphics.draw(self.imagem, self.x, self.y)

	if self.estado ~= 0 then
		love.graphics.setColor(255, 10, 10, self.explosionAlpha)
		love.graphics.circle( "fill", self.x + self.width/2, self.y + self.height/2, self.explosionRadius, 60)
	end

	-- Remover-------------------------------------- Gera HitBox do navio
	--[[if dx ~= nil then barcoExplosivo:debugger() end

	love.graphics.setColor(255, 0, 0)
	love.graphics.line(self.x, self.y, self.x + self.width, self.y)
	love.graphics.line(self.x + self.width, self.y, self.x + self.width, self.y + self.height)
	love.graphics.line(self.x + self.width, self.y + self.height, self.x, self.y + self.height)
	love.graphics.line(self.x, self.y + self.height, self.x, self.y)
	love.graphics.setColor(255,255, 255)
	------------------------------------------------]]
end

--------
function barcoExplosivo:update (dragaoInstancia, dt)
	if self.estado == 0 then
		-- Movimenta o X e o Y
		self.x = self.x - self.x_speed * dt
		self.y = self.y + self.y_speed * dt

		if self.target == "acquired" then	-- Persegue o Player
			if self.y ~= dragaoInstancia.boxY then
				if self.y > dragaoInstancia.boxY then
					if self.y_speed > self.y_speedMax * -1 then
						self.y_speed = self.y_speed - self.y_accel * dt
					end
				else
				if self.y + self.height < dragaoInstancia.boxY + dragaoInstancia.boxHeight then
					if self.y_speed < self.y_speedMax then
						self.y_speed = self.y_speed + self.y_accel * dt
					end
				end
				end
			end
		else
		if self.target == "lost" then	-- Desacelera o Y e mantem altitude
			if self.y_speed > 0 then
				self.y_speed = self.y_speed - self.y_accel * dt
				if self.y_speed < 0 then self.y_speed = 0 end
			else
				if self.y_speed < 0 then
					self.y_speed = self.y_speed + self.y_accel * dt
					if self.y_speed > 0 then self.y_speed = 0 end
				end
			end
		end
		end

		if self.x + self.width < dragaoInstancia.boxX					then self.target = "lost" 		end
		if self.x + self.width > dragaoInstancia.boxX + dragaoInstancia.boxWidth	then self.target = "acquired" 	end

		if self.x + self.width < -100 then self.x = math.random(850, 1000) end

	end
	if self.estado ~= 0 then --animacao de morte
		self.color = {0,0,0}
		self.alpha = self.alpha - (1000 * dt)
		self.explosionRadius = self.explosionRadius + 300 * dt

			self.explosionAlpha	 = self.explosionAlpha - (1000 * dt)

		if self.alpha <= 2 then
			self:dead() --morto
			self.explosionRadius = 30
			self.explosionAlpha = 255
			self.color = {255,255,255}
		end
	end
end

--------
function barcoExplosivo:checkCollision(dragaoInstancia)

	if self.estado == 0 and dragaoInstancia.estado == 0 then

		-- Colisão em 2 casos: 	1 - Inimigo/Objeto menor que o Player/Objeto.
		--						2 - Inimigo/Objeto maior que o Player/Objeto.
		--
		-- Código que pode ser utilizado em outros testes de colisão, utilizando a mesma lógica.
		-- Testa colisão em todos os pontos onde uma "hitbox" intersecta a outra.


		-- Testa colisão na ordem: Navio com Player

		if 	((self.x >= dragaoInstancia.boxX and self.x <= dragaoInstancia.boxX + dragaoInstancia.width) or
			(self.x + self.width >= dragaoInstancia.boxX and self.x + self.width <= dragaoInstancia.boxX + dragaoInstancia.width))
				and
			((self.y >= dragaoInstancia.boxY and self.y <= dragaoInstancia.boxY + dragaoInstancia.height) or
			(self.y + self.height >= dragaoInstancia.boxY and self.y + self.height <= dragaoInstancia.boxY + dragaoInstancia.height)) then

			if dragaoInstancia.estado == 0 and dragaoInstancia.colisaoAtiva == true then
				dragaoInstancia.estado = 1
			end

			self.estado = 3

		else
			-- Testa colisão na ordem: Player com Navio
			if 	((dragaoInstancia.boxX >= self.x and dragaoInstancia.boxX <= self.x + self.width) or
				(dragaoInstancia.boxX + dragaoInstancia.width >= self.x and dragaoInstancia.boxX + dragaoInstancia.width <= self.x + self.width))
					and
				((dragaoInstancia.boxY >= self.y and dragaoInstancia.boxY <= self.y + self.height) or
				(dragaoInstancia.boxY + dragaoInstancia.height >= self.y and dragaoInstancia.boxY + dragaoInstancia.height <= self.y + self.height)) then

				if dragaoInstancia.estado == 0 and dragaoInstancia.colisaoAtiva == true then
					dragaoInstancia.estado = 1
				end

				self.estado = 3
			end
		end
	end
end

--------
function barcoExplosivo:fireballColisao(fireballInstancia)

	-- Remover---------------- Usado para debug
	--dx = fireballInstancia.x
	--dy = fireballInstancia.y
	--dw = 60
	--dh = 60
	--------------------------

	if self.estado == 0 and fireballInstancia.estado == 1 then
		if 	((self.x >= fireballInstancia.x and self.x <= fireballInstancia.x + 60 ) or
			(self.x + self.width >= fireballInstancia.x and self.x + self.width <= fireballInstancia.x + 60 ))
				and
			((self.y >= fireballInstancia.y and self.y <= fireballInstancia.y + 60 ) or
			(self.y + self.height >= fireballInstancia.y and self.y + self.height <= fireballInstancia.y + 60 )) then

				self.estado = 1
				self.adcionarPontos = true
				fireballInstancia.estado = 2

		else
			-- Testa colisão na ordem: Player com Navio
			if 	((fireballInstancia.x >= self.x and fireballInstancia.x <= self.x + self.width) or
				(fireballInstancia.x + 60 >= self.x and fireballInstancia.x + 60 <= self.x + self.width))
					and
				((fireballInstancia.y >= self.y and fireballInstancia.y <= self.y + self.height) or
				(fireballInstancia.y + 60 >= self.y and fireballInstancia.y + 60 <= self.y + self.height)) then

				self.estado = 1
				self.adcionarPontos = true
				fireballInstancia.estado = 2
			end
		end
	end
end

function barcoExplosivo:dead()
	self.x = math.random(900, 1400)
	self.y = math.random(50, 500)
	self.alpha = 255
	self.estado = 0
end


---- Remover ---------------------	Gera HitBox do navio
function barcoExplosivo:debugger()

	--[[
	print("Hitbox Navio:")
	print(self.x .. "  " .. self.x + self.width)
	print(self.y .. "  " .. self.y + self.height)
	print("Hitbox Dragao:")
	print(dx .. "  " .. dx + dw)
	print(dy .. "  " .. dy + dh)
	--]]

	love.graphics.setColor(255, 0, 0)
	love.graphics.line(dx, dy, dx + dw, dy)
	love.graphics.line(dx, dy, dx, dy + dh)
	love.graphics.line(dx + dw, dy, dx + dw, dy + dh)
	love.graphics.line(dx, dy + dh, dx + dw, dy + dh)
	love.graphics.setColor(255,255, 255)


end
------------------------------
