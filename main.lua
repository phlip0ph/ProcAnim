SCREEN_HEIGHT = 800
SCREEN_WIDTH = 800

function love.load()
	jointLength = 30
	wormSpeed = 60
	worm = {
		tip = {
			posX = SCREEN_WIDTH / 2,
			posY = SCREEN_HEIGHT / 2 - 100,
			speedX = 0,
			speedY = 0,
			angle = 0
		},
		m1 = {
			posX = SCREEN_WIDTH / 2,
			posY = SCREEN_HEIGHT / 2 - 100 + jointLength,
			speedX = 0,
			speedY = 0,
			angle = 0
		},
		m2 = {
			posX = SCREEN_WIDTH / 2,
			posY = SCREEN_HEIGHT / 2 - 100 + jointLength*2,
			speedX = 0,
			speedY = 0,
			angle = 0
		},
		m3 = {
			posX = SCREEN_WIDTH / 2,
			posY = SCREEN_HEIGHT / 2 - 100 + jointLength*3,
			speedX = 0,
			speedY = 0,
			angle = 0
		},
		m4 = {
			posX = SCREEN_WIDTH / 2,
			posY = SCREEN_HEIGHT / 2 - 100 + jointLength*4,
			speedX = 0,
			speedY = 0,
			angle = 0
		},
		bot = {
			posX = SCREEN_WIDTH / 2,
			posY = SCREEN_HEIGHT / 2 - 100 + jointLength*5,
			speedX = 0,
			speedY = 0,
			angle = 0
		},
	}

	pointRadius = 20
	mouse = {
		posX = 0,
		posY = 0
	}
end

function updateWormTip(dt)
	mouse.posX, mouse.posY = love.mouse.getPosition()
	worm.tip.angle = math.atan2((mouse.posY - worm.tip.posY),(mouse.posX - worm.tip.posX))

	-- if(math.abs(worm.tip.posX - mouse.posX) < 10) then
	-- 	worm.tip.speedX = 0
	-- else
	-- 	worm.tip.speedX = worm.tip.speedX + math.cos(worm.tip.angle) * wormSpeed * dt
	-- end
	--
	-- if(math.abs(worm.tip.posY - mouse.posY) < 10) then
	-- 	worm.tip.speedY = 0
	-- else
	-- 	worm.tip.speedY = worm.tip.speedY + math.sin(worm.tip.angle) * wormSpeed * dt
	-- end
	--
	-- worm.tip.posX = (worm.tip.posX + worm.tip.speedX  *  dt)
	-- worm.tip.posY = (worm.tip.posY + worm.tip.speedY *  dt)
	posDifference = math.sqrt((mouse.posY - worm.tip.posY)^2 + (mouse.posX -worm.tip.posX)^2 )
	if(posDifference > jointLength) then
		dx = mouse.posX - worm.tip.posX
		dy = mouse.posY - worm.tip.posY
		worm.tip.posX = worm.tip.posX + (dx*dt)
		worm.tip.posY = worm.tip.posY + (dy*dt)
	end
end

function followLeader(leader, follower, dt)
	--Try to translate to the indicator then also rotate around it. Then things can be drawn at a fixed distance/coordinate
	local maxDist = jointLength + 5
	follower.angle = math.atan2((leader.posY - follower.posY),(leader.posX - follower.posX))
	posDifference = math.sqrt((follower.posY - leader.posY)^2 + (leader.posX - follower.posX)^2 )
	if(posDifference > jointLength) then
		dx = leader.posX - follower.posX
		dy = leader.posY - follower.posY
		follower.posX = follower.posX + (dx*dt)
		follower.posY = follower.posY + (dy*dt)
	end
end

function love.update(dt)
	updateWormTip(dt)
	followLeader(worm.tip, worm.m1, dt)
	followLeader(worm.m1, worm.m2, dt)
	followLeader(worm.m2, worm.m3, dt)
	followLeader(worm.m3, worm.m4, dt)
	followLeader(worm.m4, worm.bot, dt)
end

function love.draw()
	--Draw worm joints
	love.graphics.circle('line', worm.tip.posX, worm.tip.posY, pointRadius)
	love.graphics.circle('line', worm.m1.posX, worm.m1.posY, pointRadius)
	love.graphics.circle('line', worm.m2.posX, worm.m2.posY, pointRadius)
	love.graphics.circle('line', worm.m3.posX, worm.m3.posY, pointRadius)
	love.graphics.circle('line', worm.m4.posX, worm.m4.posY, pointRadius)
	love.graphics.circle('line', worm.bot.posX, worm.bot.posY, pointRadius)
	love.graphics.circle('fill', worm.tip.posX + math.cos(worm.tip.angle) * pointRadius, worm.tip.posY + math.sin(worm.tip.angle) * pointRadius, 5)
	--Draw worm arms
	love.graphics.setColor(1,0,0)
	love.graphics.translate(worm.tip.posX + math.cos(worm.tip.angle) * pointRadius, worm.tip.posY + math.sin(worm.tip.angle) * pointRadius)
	love.graphics.rotate(worm.tip.angle)
	love.graphics.circle('line', 0, 40, 15)
	love.graphics.circle('line', 0, -40, 15)
	love.graphics.origin()
	--Draw worm bones
	love.graphics.setColor(1,1,1)
	love.graphics.line(worm.tip.posX, worm.tip.posY, worm.m1.posX, worm.m1.posY)
	love.graphics.line(worm.m1.posX, worm.m1.posY, worm.m2.posX, worm.m2.posY)
	love.graphics.line(worm.m2.posX, worm.m2.posY, worm.m3.posX, worm.m3.posY)
	love.graphics.line(worm.m3.posX, worm.m3.posY, worm.m4.posX, worm.m4.posY)
	love.graphics.line(worm.m4.posX, worm.m4.posY, worm.bot.posX, worm.bot.posY)

	--Debug printing
	love.graphics.print(table.concat({
		'worm.tip.angle: '..worm.tip.angle,
		'worm.tip.posX: '..worm.tip.posX,
		'worm.tip.posY: '..worm.tip.posY,
		'worm.m1.angle: '..worm.m1.angle,
		'worm.m1.posX: '..worm.m1.posX,
		'worm.m1.posY: '..worm.m1.posY,
		'worm.bot.angle: '..worm.bot.angle,
		'worm.bot.posX: '..worm.bot.posX,
		'worm.bot.posY: '..worm.bot.posY,
		},'\n'))
end
