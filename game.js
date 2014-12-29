/* Copyright (c) Prithvi Kohli 2014
* All rights reserved
* prithvikohli.co.uk
* Contact: prithvi@prithvikohli.co.uk
*/

//***Global variables***
//Canvas variables
var c = document.getElementById('game');
var ctx = c.getContext('2d');
//Canvas dimesnsions constants
var WIDTH = window.innerWidth;
var HEIGHT = window.innerHeight;
//Rendering & animation
var requestAnimationFrame = window.requestAnimationFrame ||
                            window.mozRequestAnimationFrame ||
                            window.webkitRequestAnimationFrame ||
                            window.msRequestAnimationFrame;
//Global sprites
var logo_rock = new Image();
var logo_fall = new Image();
var arrow = new Image();
//**********************

//Main game object
var game = {
    main_hasStarted: false,

    //Preload images, sounds etc.
    preload: function () {
        logo_rock.src = 'assets/images/Logo-rock.png';
        logo_rock.onload = function () {console.log('LOGO_ROCK LOADED');};

        logo_fall.src = 'assets/images/Logo-fall.png';
        logo_fall.onload = function () {console.log('LOGO_FALL LOADED');};

        arrow.src = 'assets/images/Arrow.png';
        arrow.onload = function () {console.log('ARROW LOADED');};
        //Once preloading has finished, Initialise game
        game.init();
    },

    //Initialise function
    init: function () {
        //Set canvas height and width
        c.width = 500;
        c.height = 500;

        //Check if user's device is in portrait orientation
        if (HEIGHT > WIDTH) alert('Game is best played in landscape!')

        //Start rendering
        game.render();
    },

    render: function () {
        //Clear screen
        ctx.clearRect(0, 0, 500, 500);

        //If main game has not yet started (i.e., user is still at menu screen)
        if (game.main_hasStarted == false) game.menu.renderMenu();

        requestAnimationFrame(game.render)
    },

    menu: {
        intro: {
            fall_hasFinished: false,
            shake_hasFinished: false,
            rock_posY: -100,
            fall_posY: -100,
            rock_posX: 146,
            fall_posX: 146,
            shake_direction: 'down',
            shake_fact: 10
        },
        renderMenu: function () {
            //Draw logo
            ctx.drawImage(logo_rock, game.menu.intro.rock_posX, game.menu.intro.rock_posY);
            ctx.drawImage(logo_fall, game.menu.intro.fall_posX, game.menu.intro.fall_posY);

            //Animation
            if (game.menu.intro.fall_hasFinished == false || game.menu.intro.shake_hasFinished == false) {
              if (game.menu.intro.rock_posY < 100 && game.menu.intro.fall_hasFinished == false) game.menu.intro.rock_posY++;
              else {
                  if (game.menu.intro.fall_posY < 171 && game.menu.intro.fall_hasFinished == false) {
                      game.menu.intro.fall_posY += 4.5;
                      game.audio.playOnce('logo-fall');
                  }
                  else {
                      //Falling animation has finished
                      game.menu.intro.fall_hasFinished = true;

                      game.audio.playOnce('logo-hit');

                      //Shake animation
                      if (game.menu.intro.shake_direction == 'up')  {
                          if (game.menu.intro.rock_posY > 80) {
                              game.menu.intro.fall_posY -= game.menu.intro.shake_fact;
                              game.menu.intro.rock_posY -= game.menu.intro.shake_fact;

                              if (game.menu.intro.shake_fact > 0) game.menu.intro.shake_fact -= 0.2;
                              else {
                                game.menu.intro.shake_fact = 0;
                                game.menu.intro.shake_hasFinished = true;
                              }
                          }
                          else game.menu.intro.shake_direction = 'down';
                      }
                      else if (game.menu.intro.shake_direction == 'down') {
                          if (game.menu.intro.fall_posY < 191) {
                              game.menu.intro.fall_posY += game.menu.intro.shake_fact;
                              game.menu.intro.rock_posY += game.menu.intro.shake_fact;

                              if (game.menu.intro.shake_fact > 0) game.menu.intro.shake_fact -= 0.2;
                              else {
                                game.menu.intro.shake_fact = 0;
                                game.menu.intro.shake_hasFinished = true;
                              }
                          }
                          else game.menu.intro.shake_direction = 'up';
                    }
                }
            }
        }
        //Animations have finished
        else {
          //Draw menu options text
          ctx.font = '50px Pixel';
          ctx.fillStyle = '#f36c60';
          ctx.fillText('Play', 192, 313);
          ctx.fillStyle = '#ffab91';
          ctx.fillText('Play', 191, 310);
        }
      }
    },

    audio: {
        old: null,

        playOnce: function (sound) {
            if (sound != game.audio.old) {
                document.getElementById(sound).play();
                game.audio.old = sound;
            }
        }
    }
};

//Preload assets once page has loaded
window.onload = game.preload();
