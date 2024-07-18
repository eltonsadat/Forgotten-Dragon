-- gerenciadorJogo

require("estadosJogo/telaInicial/telaInicial")
require("estadosJogo/fases/fase01/fase01")
require("estadosJogo/background/background")
require("estadosJogo/gameOver/gameOver")
require("estadosJogo/faseConcluida/faseConcluida")

gerenciadorJogo = {}

gerenciadorJogo["telaInicialInstanciada"] = false
gerenciadorJogo["fase01Instanciada"] = false
gerenciadorJogo["faseConcluidaInstanciada"] = false
gerenciadorJogo["gameOverInstanciada"] = false

function gerenciadorJogo:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function gerenciadorJogo:Iniciar()
	if self.telaInicialInstanciada == false then
		ti = telaInicial:new()
		ti.vida = true
		self.telaInicialInstanciada = true
		telaInicialAtiva = true
	end
end

function gerenciadorJogo:loadFase01()
	f1 = fase01:new()
	f1:load()
	f1.vida = true
end

function gerenciadorJogo:loadFaseConcluida()
	fc = faseConcluida:new()
	fc.vida = true
end

function gerenciadorJogo:loadGameOver()
	go = gameOver:new()
	go.vida = true
end

function gerenciadorJogo:destruirObjetos()			
	f1 = nil
	dragao1 = nil
	ghost1 = nil
	ghost2 = nil
	ghost3 = nil
	ghost4 = nil
	ghost5 = nil
	score1 = nil
	chances1 = nil
	shield1 = nil
	bomb1 = nil
	powerUp1 = nil
	powerUp2 = nil
	powerUp3 = nil
	powerUp4 = nil
	powerUp5 = nil
	background1 = nil
	obstaculo1 = nil
	obstaculo2 = nil
	obstaculo3 = nil
	obstaculo4 = nil
	fireball1 = nil
end

function gerenciadorJogo:draw()
	if telaInicialAtiva == true and self.telaInicialInstanciada == true then
		ti:draw()
	end
	
	if fase01Ativa == true and self.fase01Instanciada == true then
		f1:draw()
	end
	
	if GameOverAtivo == true and self.gameOverInstanciada == true then
		go:draw()
	end
	
	if faseConcluidaAtiva == true and self.faseConcluidaInstanciada == true then
		fc:draw()
	end
end

function gerenciadorJogo:update(dt)
	if telaInicialAtiva == true and self.telaInicialInstanciada == true then
		ti:update(dt)
	end
	
	if telaInicialAtiva == false then
		if self.fase01Instanciada == false then --instanciar fase 1
			self:loadFase01()
			ti = nil
			dragaoVida = true
			fase01Ativa = true
			self.fase01Instanciada = true
		end
		
		if fase01Ativa == true then
			f1:update(dt)
		end
		
		if GameOverAtivo == false and faseEncerrada == true and self.fase01Instanciada == true then -- terminou a fase
			if self.faseConcluidaInstanciada == false then --instanciar fase concluida
				self:loadFaseConcluida()
				faseConcluidaAtiva = true
				self.faseConcluidaInstanciada = true
				
				fase01Ativa = false
				self:destruirObjetos()
			end
			
			if faseConcluidaAtiva == true then
				fc:update(dt)
			end
			
			if faseConcluidaAtiva == false and telaInicialAtiva == false  then --reiniciar ciclo
				fc = nil
				self.telaInicialInstanciada = false
				self.fase01Instanciada = false
				self.gameOverInstanciada = false
				self.faseConcluidaInstanciada = false
				faseEncerrada = false
				self:Iniciar()
			end
		end
		
		if dragaoVida == false then --Game Over
			fase01Ativa = false
			self:destruirObjetos()
		end
		
		if dragaoVida == false and self.fase01Instanciada == true then
			if self.gameOverInstanciada == false then --instanciar Game Over
				self:loadGameOver()
				GameOverAtivo = true
				self.gameOverInstanciada = true
			end
			
			if GameOverAtivo == true then
				go:update(dt)
			end
			
			if GameOverAtivo == false and telaInicialAtiva == false  then --reiniciar ciclo
				go = nil
				self.telaInicialInstanciada = false
				self.fase01Instanciada = false
				self.gameOverInstanciada = false
				faseEncerrada = false
				self:Iniciar()
			end
		end
	end
end
