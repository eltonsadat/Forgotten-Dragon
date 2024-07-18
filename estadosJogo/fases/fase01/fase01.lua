--fase01

require("personagens/dragao/dragao")
require("personagens/dragao/fireball/fireball")
require("personagens/dragao/powerUp/powerUp")
require("personagens/dragao/powerUp/shield")
require("personagens/dragao/powerUp/bomb")

require("estadosJogo/HUD/score")
require("estadosJogo/HUD/chances")

require("personagens/inimigos/ghost/ghost")
require("personagens/inimigos/barcoExplosivo/barcoExplosivo")
require("personagens/inimigos/stalker/stalker")
require("personagens/inimigos/stalker/laser/laser")

require("estadosJogo/fases/obstaculos/obstaculo")

fase01 = {}
fase01["x"] = 0
fase01["y"] = 0
fase01["tempoInicio"] = 0
fase01["estagio"] = 0

fase01["vida"] = false
fase01["iniciada"] = false

fase01["fonte"] = love.graphics.newFont("estadosJogo/HUD/img/AccidentalPresidency.ttf", 50)
fase01["pauseImagem"] = love.graphics.newImage("estadosJogo/fases/estadoPause/faseEstado.png")

function fase01:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function fase01:load()
	background1 = background:new()
	
	obstaculo1 = obstaculo:new()
	obstaculo1:reload(800, 520)
	obstaculo2 = obstaculo:new()
	obstaculo2:reload(1220, 520)
	obstaculo3 = obstaculo:new()
	obstaculo3:reload(1640, 520)
	obstaculo4 = obstaculo:new()
	obstaculo4:reload(2060, 520)
	
	score1 = score:new()
	
	powerUp1 = powerUp:new()
	powerUp2 = powerUp:new()
	powerUp3 = powerUp:new()
	powerUp4 = powerUp:new()
	powerUp5 = powerUp:new()
	powerUp6 = powerUp:new()	-- Adicionado PowerUp6 e suas respectivas funções no código para o PowerUp do Barco Explosivo
	
	shield1 = shield:new()
	
	bomb1 = bomb:new()
	
	chances1 = chances:new()
	
	dragao1 = dragao:new()
	dragao1:setarPosicao(20, 20)
	dragao1.dragaoSpriteBatch:setq(dragao1.id, dragao1.anim.voo1,0, 0)
	
	fireball1 = fireball:new()
	
	ghost1 = ghost:new()
	ghost1:reload(800, 20)
	ghost1.velocidade = math.random(130, 230)
	
	ghost2 = ghost:new()
	ghost2:reload(830, 120)
	ghost2.velocidade = math.random(130, 230)
	
	ghost3 = ghost:new()
	ghost3:reload(860, 220)
	ghost3.velocidade = math.random(130, 230)
	
	ghost4 = ghost:new()
	ghost4:reload(860, 320)
	ghost4.velocidade = math.random(130, 230)
	
	ghost5 = ghost:new()
	ghost5:reload(860, 420)
	ghost5.velocidade = math.random(130, 230)
	
	barcoExplosivo1 = barcoExplosivo:new()
	
	stalker1 = stalker:new()
	laser1 = laser:new()
end

function fase01:tempoParaInicio(dt)
	if self.iniciada == false then
	
		self.tempoInicio = self.tempoInicio + 1 * dt
		
		if self.tempoInicio >= 1.5 then
			self.iniciada = true
			self.tempoInicio = 0
		end
	end
end

function fase01:startDraw()
	love.graphics.setColor(80,213,80,255)
	love.graphics.draw(self.pauseImagem, (winWidth / 2) - 90, (winHeight / 2) - 45)
	love.graphics.setFont(self.fonte)
	love.graphics.setColor(146,255,79,255)
	love.graphics.print("START", 363, 265)
			
	if gamePaused == true then -- evita que o jogo inicie pausado
		pauseAtivado = false
		gamePaused = false
	end
end

function fase01:pauseDraw()
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(self.pauseImagem, (winWidth / 2) - 90, (winHeight / 2) - 45)
	love.graphics.setFont(self.fonte)
	love.graphics.setColor(255,193,0,255)
	love.graphics.print("PAUSE", 362, 265)
end

function fase01:draw()
	if self.vida == true then
		background1:draw()

		obstaculo1:draw()	-- Agora desenhados atrás de tudo mas na frente do BG
		obstaculo2:draw()
		obstaculo3:draw()
		obstaculo4:draw()

		dragao1:mostrarPowerUp(powerUp1)
		dragao1:mostrarPowerUp(powerUp2)
		dragao1:mostrarPowerUp(powerUp3)
		dragao1:mostrarPowerUp(powerUp4)
		dragao1:mostrarPowerUp(powerUp5)
		dragao1:mostrarPowerUp(powerUp6)

		dragao1:dragaoDraw()

		powerUp1:draw()
		powerUp2:draw()
		powerUp3:draw()
		powerUp4:draw()
		powerUp5:draw()
		powerUp6:draw()

		ghost1:draw()
		ghost2:draw()
		ghost3:draw()
		ghost4:draw()
		ghost5:draw()

		barcoExplosivo1:draw()
		
		stalker1:stalkerDraw()
		laser1:laserDraw()

		fireball1:fireballDraw()

		bomb1:draw()

		shield1:draw()

		score1:draw()

		chances1:draw()
		
		dragao1:mostrarPowerUp(powerUp1)
		dragao1:mostrarPowerUp(powerUp2)
		dragao1:mostrarPowerUp(powerUp3)
		dragao1:mostrarPowerUp(powerUp4)
		dragao1:mostrarPowerUp(powerUp5)
		dragao1:mostrarPowerUp(powerUp6)
		
		if self.iniciada == false then
			self:startDraw()
		end

		if gamePaused == true then
			self:pauseDraw()
		end
	end
end

function fase01:inimigoFimTela(inimigoInstancia, pontoReload, posX, posY, velMin ,velMax)
	if inimigoInstancia.width <= pontoReload then
		inimigoInstancia:reload (posX, posY)
		inimigoInstancia.velocidade = math.random(velMin, velMax)
	end
end

function fase01:inimigoRessuscita(inimigoInstancia, posX, posY, velMin, velMax)
	if inimigoInstancia.name == "Barco Explosivo" and inimigoInstancia.estado == 1 then				-- Adicionado
		score1:adcionarPontos(inimigoInstancia)
	else
		if inimigoInstancia.estado == 2 then
			score1:adcionarPontos(inimigoInstancia)
			inimigoInstancia:reload (posX, posY)
			inimigoInstancia.velocidade = math.random(velMin + 30, velMax + 30)
		end
	end
end

function fase01:atualizarFase()
	--print(self.estagio)
	
	if obstaculo1.width <= 0 then
		obstaculo1.x = obstaculo4.x + 420
	end
			
	if obstaculo2.width <= 0 then
		obstaculo2.x = obstaculo1.x + 420
	end 
				
	if obstaculo3.width <= 0 then
		obstaculo3.x = obstaculo2.x + 420
	end
		
	if obstaculo4.width <= 0 then
		obstaculo4.x = obstaculo3.x + 420
		self.estagio = self.estagio + 1 -- Quando este obstáculo terminar a sua tragetória, acrescenta uma nova etapa ao estágio.
	end
	
	if self.estagio == 0 then
		self:inimigoFimTela(ghost1, -300, 800, 20, 100, 200)
		self:inimigoFimTela(ghost2, -300, 800, 120, 100, 200)
		self:inimigoFimTela(ghost3, -300, 800, 220, 100, 200)
		self:inimigoFimTela(ghost4, -300, 800, 320, 100, 200)
		self:inimigoFimTela(ghost5, -300, 800, 420, 100, 200)
		
		self:inimigoRessuscita(ghost1, 1000, 20, 100, 200)
		self:inimigoRessuscita(ghost2, 1000, 120, 100, 200)
		self:inimigoRessuscita(ghost3, 1000, 220, 100, 200)
		self:inimigoRessuscita(ghost4, 1000, 320, 100, 200)
		self:inimigoRessuscita(ghost5, 1000, 420, 100, 200)
		self:inimigoRessuscita(barcoExplosivo1)
	end
	
	if self.estagio == 1 or self.estagio == 6 or self.estagio == 9 then
		self:inimigoFimTela(ghost1, -300, 800, 20, 100, 200)
		self:inimigoFimTela(ghost2, -300, 800, 120, 100, 200)
		self:inimigoFimTela(ghost3, -300, 800, 220, 100, 200)
		
		self:inimigoRessuscita(ghost1, 1000, 20, 100, 200)
		self:inimigoRessuscita(ghost2, 1000, 120, 100, 200)
		self:inimigoRessuscita(ghost3, 1000, 220, 100, 200)
		self:inimigoRessuscita(barcoExplosivo1)
	end
	
	if self.estagio == 2 or self.estagio == 4 or self.estagio == 7 then
		self:inimigoFimTela(ghost1, -300, 800, 20, 100, 200)
		self:inimigoFimTela(ghost2, -300, 800, 120, 100, 200)
		
		self:inimigoRessuscita(ghost1, 1000, 20, 100, 200)
		self:inimigoRessuscita(ghost2, 1000, 120, 100, 200)
		self:inimigoRessuscita(barcoExplosivo1)
	end
	
	if self.estagio == 3 or self.estagio == 5 or self.estagio == 8 then
		self:inimigoFimTela(ghost1, -300, 800, 20, 100, 200)
		
		self:inimigoRessuscita(ghost1, 1000, 20, 100, 200)
		self:inimigoRessuscita(barcoExplosivo1)
	end
	
	if self.estagio == 1 or self.estagio == 6 or self.estagio == 9 then
		obstaculo3.y = 350
		obstaculo4.y = 350
		if obstaculo1.width <= 0 then
			obstaculo1.y = 350
		end
		if obstaculo2.width <= 0 then
			obstaculo2.y = 350
		end
	end
	
	if self.estagio == 2 or self.estagio == 4 or self.estagio == 7 then
		obstaculo3.y = 250
		obstaculo4.y = 520
		if obstaculo1.width <= 0 then
			obstaculo1.y = 320
		end
		if obstaculo2.width <= 0 then
			obstaculo2.y = 560
		end
	end
	
	if self.estagio == 3 or self.estagio == 5 or self.estagio == 8 then
		obstaculo3.y = 200
		obstaculo4.y = 200
		if obstaculo1.width <= 0 then
			obstaculo1.y = 200
		end
		if obstaculo2.width <= 0 then
			obstaculo2.y = 200
		end
	end
	
	if self.estagio == 10 then
		obstaculo3.y = 700
		obstaculo4.y = 700
		if obstaculo1.width <= 0 then
			obstaculo1.y = 700
		end
		if obstaculo2.width <= 0 then
			obstaculo2.y = 700
		end
	end
	
	if self.estagio == 11 then
		faseEncerrada = true
	end
end

function fase01:update(dt)
	if self.vida == true then

		self:tempoParaInicio(dt)

		if self.iniciada == true and gamePaused == false then --Pausar jogo
			background1:update(dt)

			fireball1:checarDragaoEstado(dragao1)
			dragao1:checarFireballEstado(fireball1)

			fireball1:fireballUpdate(dt)

			dragao1:colisaoInimigo(ghost1)
			dragao1:colisaoInimigo(ghost2)
			dragao1:colisaoInimigo(ghost3)
			dragao1:colisaoInimigo(ghost4)
			dragao1:colisaoInimigo(ghost5)

			barcoExplosivo1:checkCollision(dragao1)

			powerUp1:surgir(ghost1)
			powerUp2:surgir(ghost2)
			powerUp3:surgir(ghost3)
			powerUp4:surgir(ghost4)
			powerUp5:surgir(ghost5)
			powerUp6:surgir(barcoExplosivo1)

			powerUp1:update(dt)
			powerUp2:update(dt)
			powerUp3:update(dt)
			powerUp4:update(dt)
			powerUp5:update(dt)
			powerUp6:update(dt)

			powerUp1:dragaoColisao(dragao1)
			powerUp2:dragaoColisao(dragao1)
			powerUp3:dragaoColisao(dragao1)
			powerUp4:dragaoColisao(dragao1)
			powerUp5:dragaoColisao(dragao1)
			powerUp6:dragaoColisao(dragao1)

			dragao1:colisaoObstaculo(obstaculo1)
			dragao1:colisaoObstaculo(obstaculo2)
			dragao1:colisaoObstaculo(obstaculo3)
			dragao1:colisaoObstaculo(obstaculo4)

			dragao1:dragaoUpdate(dt)

			shield1:update(dragao1, dt)

			bomb1:update(dragao1, dt)
			bomb1:destruir(ghost1)
			bomb1:destruir(ghost2)
			bomb1:destruir(ghost3)
			bomb1:destruir(ghost4)
			bomb1:destruir(ghost5)
			bomb1:destruir(barcoExplosivo1)		-- Adicionado

			shield1:colisaoInimigo(ghost1)
			shield1:colisaoInimigo(ghost2)
			shield1:colisaoInimigo(ghost3)
			shield1:colisaoInimigo(ghost4)
			shield1:colisaoInimigo(ghost5)
			shield1:colisaoInimigo(barcoExplosivo1)

			shield1:colisaoObstaculo(obstaculo1)
			shield1:colisaoObstaculo(obstaculo2)
			shield1:colisaoObstaculo(obstaculo3)
			shield1:colisaoObstaculo(obstaculo4)

			chances1:checarChances(dragao1)

			obstaculo1:update(dt)
			obstaculo1:fireballColisao(fireball1)

			obstaculo2:update(dt)
			obstaculo2:fireballColisao(fireball1)

			obstaculo3:update(dt)
			obstaculo3:fireballColisao(fireball1)

			obstaculo4:update(dt)
			obstaculo4:fireballColisao(fireball1)

			ghost1:ghostUpdate(dt)
			ghost1:fireballColisao(fireball1)

			ghost2:ghostUpdate(dt)
			ghost2:fireballColisao(fireball1)

			ghost3:ghostUpdate(dt)
			ghost3:fireballColisao(fireball1)

			ghost4:ghostUpdate(dt)
			ghost4:fireballColisao(fireball1)

			ghost5:ghostUpdate(dt)
			ghost5:fireballColisao(fireball1)

			barcoExplosivo1:update(dragao1, dt)
			barcoExplosivo1:fireballColisao(fireball1)
			
			laser1:laserUpdate(dt)
			laser1:checarStalkerEstado(stalker1)
			
			stalker1:stalkerUpdate(dt)
			stalker1:checarLaserEstado(laser1)
			stalker1:stalkerCollision(fireball1)

			self:atualizarFase()

			scoreGlobal = score1.valor
		end
	end
end
