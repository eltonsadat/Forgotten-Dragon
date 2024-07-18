--Forgotten Dragon V_0.45

--main

require("gerenciadorJogo")

winWidth = love.graphics.getWidth()
winHeight = love.graphics.getHeight()
dragaoVida = true
telaInicialAtiva = false
fase01Ativa = false
faseConcluidaAtiva = false
GameOverAtivo = false
faseEncerrada = false
gamePaused = false
pauseAtivado = false
scoreGlobal = 0

keyboard_Pause = "p"

function love.load()
	love.mouse.setVisible(false)
	gerenciadorJogo1 = gerenciadorJogo:new()
	gerenciadorJogo1:Iniciar()
end

function love.draw()
	gerenciadorJogo1:draw()
end

function love.update(dt)
	gerenciadorJogo1:update(dt)
end

function love.keypressed(key,unicode)
	if key == "escape" then
		love.event.quit()
	end

	if (key == "p" or key == "return") and pauseAtivado == false then		-- Modificado
		gamePaused = true
		pauseAtivado = true
	else
		if (key == "p" or key == "return") and pauseAtivado == true then	-- Modificado
			pauseAtivado = false
			gamePaused = false
		end
	end
end

function love.joystickpressed(joystick, button)
	if button == 10 and pauseAtivado == false then
		gamePaused = true
		pauseAtivado = true
	else
		if button == 10 and pauseAtivado == true then
		pauseAtivado = false 
		gamePaused = false
		end
	end
end

function love.quit()
	print("Bye! Thanks for playing and come back soon.")
end
