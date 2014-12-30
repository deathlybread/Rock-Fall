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
#**********************

#Main game object
game = 
	main_hasStarted: false

	#Preload images
	preload: ->
		logo_rock.src = 'assets/images/Logo-rock.png'
		logo_rock.onload = -> console.log('LOGO_ROCK LOADED')

		logo_fall.src = 'assets/images/Logo-fall.png'
		logo_fall.onload = -> console.log('LOGO_FALL LOADED')

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

						return
						
	audio:
		old: null

		playOnce: (sound) ->
			if sound != game.audio.old 
				$('#' + sound)[0].play()
				game.audio.old = sound

				return

$ do game.preload 