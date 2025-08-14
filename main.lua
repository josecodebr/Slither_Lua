--Por Jose
-- Definições do jogo
local screenWidth = 800
local screenHeight = 600
local gameState = "playing" -- "playing", "gameover"

-- Carregamento de fontes e sons
local font
local eatSound
local deathSound

local cabeca_cobra
local segmento
-- Cobra do jogador
local player = {
    x = screenWidth / 2,
    y = screenHeight / 2,
    size = 10,
    speed = 150,
    body = {},
    direction = "right",
    isGrowing = false,
    color = {0, 0.5, 0, 1}, -- Verde
    score = 0,
    accelSpeed = 300,
    isAccelerating = false
}

-- Partículas
local foodParticles = love.graphics.newParticleSystem(love.graphics.newImage("particle.png"), 100)
local deathParticles = love.graphics.newParticleSystem(love.graphics.newImage("particle.png"), 200)
local fundo 
-- Alimentos (massinhas)
local foods = {}
local foodCount = 2000
local foodSize = 5
local foods_img
-- Tempo de jogo
local dt = 0

-- Inicialização do jogo
function love.load()
	rotation = 0
    love.window.setMode(screenWidth, screenHeight)
    love.window.setTitle("Slither.io Single-Player")
	foods_img = love.graphics.newImage("food.png")
	fundo = love.graphics.newImage("fundo2.png")
	cabeca_cobra = love.graphics.newImage("cabeca.png")
	segmento = love.graphics.newImage("segmento.png")
    -- Carrega a fonte e os sons
    font = love.graphics.newFont(20)
    eatSound = love.audio.newSource("eat_sound.wav", "static")
    deathSound = love.audio.newSource("death_sound.wav", "static")

    -- Configura os sistemas de partículas
    foodParticles:setParticleLifetime(0.5)
    foodParticles:setEmissionRate(50)
    --foodParticles:setColors(0.9, 0.9, 0, 1, 0.9, 0.9, 0, 0)
    foodParticles:setSpeed(50, 100)
    foodParticles:setSpread(math.pi)

    deathParticles:setParticleLifetime(1)
    deathParticles:setEmissionRate(200)
    --deathParticles:setColors(1, 1, 1, 1, 1, 1, 1, 0)
    deathParticles:setSpeed(100, 200)
    deathParticles:setSpread(math.pi * 2)

    -- Gera os alimentos
    foods = {}
    for i = 1, foodCount do
        table.insert(foods, {
            x = math.random(foodSize, screenWidth - foodSize),
            y = math.random(foodSize, screenHeight - foodSize)
        })
    end

    -- Reinicia a cobra do jogador
    player.x = screenWidth / 2
    player.y = screenHeight / 2
    player.direction = "right"
    player.body = {}
    player.score = 0
    for i = 1, 5 do
        table.insert(player.body, {x = player.x - i * player.size, y = player.y})
    end

    gameState = "playing"
end

-- Atualização do jogo (a cada frame)
function love.update(delta)
    dt = delta

    if gameState ~= "playing" then
        return
    end

    -- Lógica de aceleração do jogador
    if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
        player.isAccelerating = true
        if #player.body > 5 then
            table.remove(player.body, 1)
        end
    else
        player.isAccelerating = false
    end

    -- Atualiza a cobra e checa as colisões
    updateSnake(player, dt)
    checkCollisions(player)
    
    -- Atualiza os sistemas de partículas
    foodParticles:update(dt)
    deathParticles:update(dt)
end

-- Lógica de atualização da cobra do jogador
function updateSnake(snake, delta)
    local newHead = {x = snake.x, y = snake.y}
    local currentSpeed = snake.speed

    if snake.isAccelerating then
        currentSpeed = snake.accelSpeed
    end

    -- Lógica de controle do jogador
	
	--local rotation = 0
    if love.keyboard.isDown("up") and snake.direction ~= "down" then
        snake.direction = "up"
		rotation = -math.pi / 2 
    elseif love.keyboard.isDown("down") and snake.direction ~= "up" then
		rotation = math.pi / 2
        snake.direction = "down"
    elseif love.keyboard.isDown("left") and snake.direction ~= "right" then
		rotation = math.pi 
        snake.direction = "left"
    elseif love.keyboard.isDown("right") and snake.direction ~= "left" then
        snake.direction = "right"
		rotation = 0
    end

    if snake.direction == "up" then
        snake.y = snake.y - currentSpeed * delta
    elseif snake.direction == "down" then
        snake.y = snake.y + currentSpeed * delta
    elseif snake.direction == "left" then
        snake.x = snake.x - currentSpeed * delta
    elseif snake.direction == "right" then
        snake.x = snake.x + currentSpeed * delta
    end

    -- Atualiza o corpo da cobra
    if not snake.isGrowing then
        table.remove(snake.body, 1)
    else
        snake.isGrowing = false
    end
    table.insert(snake.body, newHead)
end

-- Lógica de colisão para a cobra do jogador
function checkCollisions(snake)
    -- Colisão com alimentos
    for i = #foods, 1, -1 do
        local food = foods[i]
        local dist = math.sqrt((snake.x - food.x)^2 + (snake.y - food.y)^2)
        if dist < snake.size / 2 + foodSize / 2 then
            table.remove(foods, i)
            snake.isGrowing = true
            snake.score = snake.score + 1
            
            -- Toca o som de comer e cria partículas
            eatSound:play()
            foodParticles:emit(20)
            foodParticles:moveTo(food.x, food.y)

            -- Repõe o alimento
            table.insert(foods, {
                x = math.random(foodSize, screenWidth - foodSize),
                y = math.random(foodSize, screenHeight - foodSize)
            })
        end
    end

    -- Colisão com as paredes
    if snake.x < 0 or snake.x > screenWidth or snake.y < 0 or snake.y > screenHeight then
        onDeath(snake)
    end
    
    -- Colisão com o próprio corpo
    for i, segment in ipairs(snake.body) do
        local dist = math.sqrt((snake.x - segment.x)^2 + (snake.y - segment.y)^2)
        if dist < snake.size / 2 and i < #snake.body - 2 then
            onDeath(snake)
        end
    end
end

-- Lógica de morte
function onDeath(snake)
    if snake == player then
        gameState = "gameover"
        deathSound:play()
        deathParticles:emit(100)
        deathParticles:moveTo(snake.x, snake.y)
    end
end

-- Desenho na tela
function love.draw()
	--love.graphics.rectangle("fill", 0,0, screenWidth, screenHeight)
	love.graphics.draw(fundo, 0, 0)
    -- Desenha os alimentos
    for i, food in ipairs(foods) do
        --love.graphics.circle("fill", food.x, food.y, foodSize)
		love.graphics.draw(foods_img, food.x, food.y)
    end

    -- Desenha a cobra do jogador
    drawSnake(player)

    -- Desenha o placar
    love.graphics.setFont(font)
    --love.graphics.setColor(player.color)
    love.graphics.printf("Pontos: " .. player.score, 10, 10, screenWidth - 20, "left")

    -- Desenha os sistemas de partículas
    love.graphics.draw(foodParticles)
    love.graphics.draw(deathParticles)

    -- Tela de Game Over
    if gameState == "gameover" then
        --love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("Game Over! Pressione ENTER para reiniciar.", 0, screenHeight / 2, screenWidth, "center")
    end
end

-- Lógica de desenho da cobra
function drawSnake(snake)
    for i, segment in ipairs(snake.body) do
        
		love.graphics.draw(segmento, segment.x-8, segment.y-8)
		love.graphics.circle("fill", segment.x, segment.y, snake.size -3)
    end
	love.graphics.draw(
        cabeca_cobra,
        snake.x,
        snake.y,
        rotation,
        1, -- escala x
        1, -- escala y
        cabeca_cobra:getWidth() / 2, -- origem x (centro)
        cabeca_cobra:getHeight() / 2 -- origem y (centro)
		)
end

-- Lógica de eventos de teclado
function love.keypressed(key)
    if gameState == "gameover" and key == "return" then
        love.load()
    end
end
