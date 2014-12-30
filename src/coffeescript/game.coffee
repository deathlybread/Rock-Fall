###
	Copyright (c) Prithvi Kohli 2014
	All rights reserved
	prithvikohli.co.uk
	Contact: prithvi@prithvikohli.co.uk
###

#***Global variables***
#Canvas variables
c = $('#game')[0]
ctx = c.getContext('2d')
#Window dimensions constants
WIDTH = window.innerWidth
HEIGHT = window.innerHeight
#Rendering & animation
requestAnimationFrame = window.requestAnimationFrame ||
                            window.mozRequestAnimationFrame ||
                            window.webkitRequestAnimationFrame ||
                            window.msRequestAnimationFrame
#Global sprites
logo_rock = new Image()
logo_fall = new Image()
arrow = new Image()
wall_left = new Image()
wall_right = new Image()
#**********************

#Main game object
game = 
	main_hasStarted: false

	#Preload images and sounds
	preload: ->
		logo_rock.src = 'assets/images/Logo-rock.png'
		logo_rock.onload = -> console.log 'LOGO_ROCK LOADED'

		logo_fall.src = 'assets/images/Logo-fall.png'
		logo_fall.onload = -> console.log 'LOGO_FALL LOADED'

		wall_left.src = 'assets/images/Wall-left.png'
		wall_left.onload = -> console.log 'WALL_LEFT LOADED'

		wall_right.src = 'assets/images/Wall-right.png'
		wall_right.onload = -> console.log 'WALL_RIGHT LOADED'
		#Once preloading has finished, initialise game
		do game.init

		return

	init: ->
		#Set canvas dimension
		c.width = 500
		c.height = 500

		#Check if user's device is in portrait orientation
		alert 'Game best played in landscape orientation!' if HEIGHT > WIDTH
		
		#Start rendering
		do game.render

		return

	render: ->
		#Clear screen
		ctx.clearRect(0, 0, 500, 500)

		#Fill screen with background color
		ctx.fillStyle = '#e84e40'
		ctx.fillRect(0, 0, 500, 500)

		#Render menu if game has not started
		do game.menu.renderMenu if game.main_hasStarted == false

		requestAnimationFrame(game.render)

		return

	menu:
		intro:
			fall_hasFinished: false
			shake_hasFinished: false
			rock_posY: -100
			fall_posY: -100
			rock_posX: 146
			fall_posX: 146
			shake_direction: 'down'
			shake_fact: 10

		renderMenu: ->
			#Draw background
			ctx.drawImage(wall_left, 0, 0)
			ctx.drawImage(wall_right, 447, 0)

			#Draw logo
			ctx.drawImage(logo_rock, game.menu.intro.rock_posX, game.menu.intro.rock_posY)
			ctx.drawImage(logo_fall, game.menu.intro.fall_posX, game.menu.intro.fall_posY)

			#Animations
			if game.menu.intro.fall_hasFinished == false 
				if game.menu.intro.rock_posY < 100 
					game.menu.intro.rock_posY++
				else 
					if game.menu.intro.fall_posY < 171
						game.menu.intro.fall_posY += 4.5
						game.audio.playOnce 'logo-fall'
					else 
						#Fall animation has finished
						game.audio.playOnce 'logo-hit'

						game.menu.intro.fall_hasFinished = true

			else if game.menu.intro.fall_hasFinished == true and game.menu.intro.shake_hasFinished == false
				#Shake animation
				if game.menu.intro.shake_direction == 'up'
					if game.menu.intro.rock_posY > 80
						game.menu.intro.rock_posY -= game.menu.intro.shake_fact
						game.menu.intro.fall_posY -= game.menu.intro.shake_fact

						if game.menu.intro.shake_fact > 0
							game.menu.intro.shake_fact -= 0.2
						else 
							game.menu.intro.shake_fact = 0
							game.menu.intro.shake_hasFinished = true

					else game.menu.intro.shake_direction = 'down'		

				else if game.menu.intro.shake_direction == 'down'
					if (game.menu.intro.fall_posY < 191)
						game.menu.intro.fall_posY += game.menu.intro.shake_fact
						game.menu.intro.rock_posY += game.menu.intro.shake_fact

						if game.menu.intro.shake_fact > 0
							game.menu.intro.shake_fact -= 0.2
						else
							game.menu.intro.shake_fact = 0
							game.menu.intro.shake_hasFinished = true
						
					else
						game.menu.intro.shake_direction = 'up'

			return
						
	audio:
		old: null

		playOnce: (sound) ->
			if sound != game.audio.old 
				$('#' + sound)[0].play()
				game.audio.old = sound

				return

$ do game.preload 