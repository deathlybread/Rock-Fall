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
		ctx.clearRect 0, 0, 500, 500

		#Fill screen with background color
		ctx.fillStyle = '#D44639'
		ctx.fillRect 0, 0, 500, 500

		#Render menu if game has not started
		do game.menu.renderMenu if game.main_hasStarted == false

		requestAnimationFrame game.render

		return

	menu:
		selectedOption: 1

		intro:
			fall_hasFinished: false
			shake_hasFinished: false
			options_hasFinished: false
			rock_posY: -100
			fall_posY: -100
			rock_posX: 146
			fall_posX: 146
			shake_direction: 'down'
			shake_fact: 10
			options_speed: 10
			options_play_posY: 580
			options_options_posY: 620
			anim_finished: false

		renderMenu: ->
			#Draw background
			ctx.drawImage wall_left, 0, 0
			ctx.drawImage wall_right, 447, 0 

			#Draw logo
			ctx.drawImage logo_rock, game.menu.intro.rock_posX, game.menu.intro.rock_posY
			ctx.drawImage logo_fall, game.menu.intro.fall_posX, game.menu.intro.fall_posY

			#Draw menu options
			#Play
			ctx.fillStyle = '#f36c60'
			ctx.font = '50px Pixel'
			ctx.fillText 'Play', 192, game.menu.intro.options_play_posY
			ctx.fillStyle = '#ffab91'
			ctx.font = '50px Pixel'
			ctx.fillText 'Play', 192, game.menu.intro.options_play_posY - 5
			#Options
			ctx.fillStyle = '#f36c60'
			ctx.font = '50px Pixel'
			ctx.fillText 'Options', 153, game.menu.intro.options_options_posY
			ctx.fillStyle = '#ffab91'
			ctx.font = '50px Pixel'
			ctx.fillText 'Options', 153, game.menu.intro.options_options_posY - 5

			if game.menu.intro.anim_finished == false 
				do game.menu.handleAnimations

			else 
				#Draw what is needed after animation -- selectors etc.

				if game.menu.selectedOption == 1
					do ctx.beginPath
					ctx.lineWidth = 10
					ctx.strokeStyle = '#ffab91'
					ctx.moveTo 159, 285
					ctx.lineTo 179, 285
					do ctx.stroke
					ctx.moveTo 326, 285
					ctx.lineTo 306, 285
					do ctx.stroke

				else if game.menu.selectedOption == 0
					do ctx.beginPath
					ctx.lineWidth = 10
					ctx.strokeStyle = '#ffab91'
					ctx.moveTo 119, 355
					ctx.lineTo 139, 355
					do ctx.stroke
					ctx.moveTo 377, 355
					ctx.lineTo 357, 355
					do ctx.stroke

				#Handle menu input
				do game.menu.handleInput

			return
		
		handleAnimations: ->
			if game.menu.intro.fall_hasFinished == false and game.menu.intro.shake_hasFinished == false and game.menu.intro.options_hasFinished == false
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

			else if game.menu.intro.fall_hasFinished == true and game.menu.intro.shake_hasFinished == false and game.menu.intro.options_hasFinished == false
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

			else if game.menu.intro.fall_hasFinished == true and game.menu.intro.shake_hasFinished == true and game.menu.intro.options_hasFinished == false
				#Options enter animation
				if game.menu.intro.options_play_posY > 305
					game.menu.intro.options_play_posY -= 3
				
				else
					game.menu.intro.anim_finished = true

				if game.menu.intro.options_options_posY > 375 
					game.menu.intro.options_options_posY -= 3

			return

		handleInput: ->
			document.addEventListener 'keydown', (e) ->
				if e.keyCode == 40 and game.menu.selectedOption == 1
					game.menu.selectedOption--

				else if e.keyCode == 38 and game.menu.selectedOption == 0
					game.menu.selectedOption++

	audio:
		old: null

		playOnce: (sound) ->
			if sound != game.audio.old 
				$('#' + sound)[0].play()
				game.audio.old = sound

				return

$ do game.preload 