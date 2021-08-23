package;

import flixel.input.FlxAccelerometer;
import flixel.FlxSprite;
import flixel.text.FlxText;
import Math;
import flixel.math.FlxPoint;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.effects.particles.FlxEmitter;
import flixel.system.FlxSound;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.FlxState;
import flixel.util.FlxTimer;
import env.Environment;

// import env.Environment;
class PlayState extends FlxState
{
	// Pause menu stuff
	var isPaused:Bool = false;
	var isMenu:Bool = false;
	var restartButton:FlxButton;
	var musicButton:FlxButton;
	var resumeButton:FlxButton;
	var sfxButton:FlxButton;
	var fullscreenButton:FlxButton;
	var pauseMenuBackground:FlxSprite;
	var pausePlayerX:Float;
	var pausePlayerY:Float;
	var pausePlayerSpeed:Float;
	var pausePlayerAngle:Float;
	var pauseCarX:Array<Float> = new Array();
	var pauseCarY:Array<Float> = new Array();
	var screenDarken:FlxSprite;

	// Win stuff
	var winscreen:FlxSprite;
	var winText:FlxText;
	var menuButton:FlxButton;
	var isWinMenu:Bool;

	// Lose stuff
	var losescreen:FlxSprite;
	var loseText:FlxText;
	var isLose:Bool = false;

	var player:Player;
	var trailer:Trailer;

	// Game winning stuff
	var WINDIST:Float = 100000;

	var isWin:Bool = false;
	var winCounter:Float = 0;
	var winImmune:Bool;

	// Particle effects
	var sparks:FlxEmitter;
	var carExplode:FlxEmitter;
	var confetti:FlxEmitter;

	// Sound stuff
	var isGrinding:Bool = false;
	var grindSound:FlxSound;
	var MainTheme:FlxSound;
	var crashSound:FlxSound;
	var PauseTheme:FlxSound;
	var buttonSound:FlxSound;

	// Displays
	var speedometer:FlxSprite;
	var speedNeedle:FlxSprite;
	// Timer variables
	var MAXTIME:Float = 180; // In seconds
	var currentTime:FlxTimer; // Keep track of time
	var timerDisp:FlxText; // Display at the top
	var timerDisplay:FlxSprite;
	var faster:FlxSprite;
	// Distance Tape
	var miniCar:FlxSprite;
	var miniRoad:FlxSprite;

	// Box positioning variables
	var playerHealth:Int = 4;
	var boxOne:Boxes;
	var boxTwo:Boxes;
	var boxThree:Boxes;
	var boxFour:Boxes;
	var boxOnePoint:FlxPoint;
	var boxTwoPoint:FlxPoint;
	var boxThreePoint:FlxPoint;
	var boxFourPoint:FlxPoint;
	var boxX:Float;
	var boxY:Float;
	var refLength:Float;
	var refAngle:Float;
	var BOXSPACING = 15;

	// Car variables
	var car:Array<Cars> = new Array();
	var carMax:Int = 20;
	var carTotal:Int = 0; // Not used for anything?
	var carSpawnX:Int;
	var chooseLane:Int;
	var chooseVehicle:Int;
	var furthestCar:Float;
	var isImmune:Bool;

	// Bumpers
	var leftBumper:Bumpers;
	var rightBumper:Bumpers;

	// Trailer positioning variables
	var h1:Int = 162;
	var h2:Int = 139;
	var w1:Int = 74;
	var w2:Float = 92;
	var theta1:Float;
	var theta2:Float;
	var a:Float;
	var b:Float;
	var trailerX:Float;
	var trailerY:Float;

	// Camera
	var uiCamera:FlxCamera;

	// fade to black
	var fadeToBlack:FlxSprite;

	// Scanline "Filter" (its an image over the whole screen)
	var scanlines:FlxSprite;

	var env:Environment;

	override public function create()
	{
		// Newgrounds stuff!

		buttonSound = new FlxSound();
		buttonSound = new FlxSound();
		buttonSound = FlxG.sound.load(AssetPaths.button_push__wav);
		currentTime = new FlxTimer().start(500, null, 0);
		currentTime.reset();
		FlxG.updateFramerate = 60;
		// Sound stuff
		PauseTheme = FlxG.sound.load(AssetPaths.PauseTheme__ogg);
		PauseTheme.looped = true;
		MainTheme = FlxG.sound.load(AssetPaths.MainTheme__ogg);
		MainTheme.looped = true;
		MainTheme.play();
		grindSound = FlxG.sound.load(AssetPaths.grind__wav);
		crashSound = FlxG.sound.load(AssetPaths.crash__wav);

		// Bumpers for keeping car on road
		leftBumper = new Bumpers(160, 0);
		add(leftBumper);
		rightBumper = new Bumpers(597, 0);
		add(rightBumper);
		// Background
		var bg:FlxBackdrop = new FlxBackdrop(AssetPaths.road__png, 1, 1, true, true);
		add(bg);

		// Player
		player = new Player(402 - 37, 0);
		add(player);
		Player.speed = Player.STARTSPEED;

		// Trailer
		trailer = new Trailer(0, 0);
		add(trailer);

		// Boxes in the back
		boxOne = new Boxes(0, 0);
		boxTwo = new Boxes(0, 0);
		boxThree = new Boxes(0, 0);
		boxFour = new Boxes(0, 0);
		boxOnePoint = new FlxPoint(-16, -42);
		boxTwoPoint = new FlxPoint(16, -42);
		boxThreePoint = new FlxPoint(-16, 42);
		boxFourPoint = new FlxPoint(16, 42);
		add(boxOne);
		add(boxTwo);
		add(boxThree);
		add(boxFour);

		// Other cars on road
		for (i in 0...carMax)
		{
			car[i] = new Cars(1000, -500); // Very important that this starts offscreen
			add(car[i]);
			car[i].kill();
		}

		// Env items should be above background, player, and vehicles, but below menu
		this.env = new Environment(add, remove);

		// Particle effects
		sparks = new FlxEmitter(1000, 1000, 200);
		sparks.makeParticles(2, 2, FlxColor.WHITE, 200);
		add(sparks);
		sparks.start(false, .01);

		carExplode = new FlxEmitter(1000, 1000, 200);
		carExplode.makeParticles(4, 4, FlxColor.ORANGE, 400);
		carExplode.speed.set(25, 800, 100, 425);
		add(carExplode);
		carExplode.color.set(0xf9c22b, 0xf79617, 0xffffff);

		// Info Displays
		speedometer = new FlxSprite(0, 0);
		speedometer.loadGraphic(AssetPaths.speed__png);
		add(speedometer);
		speedNeedle = new FlxSprite(0, 0);
		speedNeedle.loadGraphic(AssetPaths.speedNeedle__png);
		add(speedNeedle);
		timerDisplay = new FlxSprite(0, 0);
		timerDisplay.loadGraphic(AssetPaths.timer__png);
		add(timerDisplay);
		timerDisp = new FlxText(53, 0);
		timerDisp.size = 40;
		add(timerDisp);
		faster = new FlxSprite(0, 0).loadGraphic(AssetPaths.faster__png);
		add(faster);
		faster.kill();
		miniCar = new FlxSprite(0, 0).loadGraphic(AssetPaths.miniCar__png);
		miniRoad = new FlxSprite(0, 0).loadGraphic(AssetPaths.miniRoad__png);
		add(miniRoad);
		add(miniCar);

		uiCamera = new FlxCamera(0, 0);
		FlxG.cameras.add(uiCamera);

		super.create();

		// fade to black initialization
		fadeToBlack = new FlxSprite(0, 0);
		fadeToBlack.loadGraphic(AssetPaths.fadetoblack__png);
		add(fadeToBlack);
		fadeToBlack.alpha = 0;

		// Screen darkening
		screenDarken = new FlxSprite(0, 0);
		screenDarken.loadGraphic(AssetPaths.dark_filter__png);
		add(screenDarken);
		screenDarken.kill();

		// Win screen background and text (and confetti)
		winscreen = new FlxSprite(0, 0);
		winscreen.loadGraphic(AssetPaths.winScreen__png);
		add(winscreen);
		winscreen.kill();
		winText = new FlxText(0, 0);
		add(winText);
		winText.kill();
		confetti = new FlxEmitter(10000, 10000);
		confetti.makeParticles(4, 4, FlxColor.BLUE, 400);
		confetti.color.set(FlxColor.BLUE, FlxColor.PURPLE);
		confetti.speed.set(25, 800, 100, 425);
		add(confetti);

		// Lose Screen stuff
		losescreen = new FlxSprite(0, 0);
		losescreen.loadGraphic(AssetPaths.LOSE__png);
		add(losescreen);
		losescreen.kill();
		loseText = new FlxText(0, 0);
		add(loseText);
		loseText.kill();

		// Pause menu background
		pauseMenuBackground = new FlxSprite(0, 0);
		pauseMenuBackground.loadGraphic(AssetPaths.PAUSED_WINDOW__png);
		add(pauseMenuBackground);
		pauseMenuBackground.kill();

		// Menu buttons
		restartButton = new FlxButton(0, 0, "", restartGame);
		musicButton = new FlxButton(0, 0, "", muteMusic);
		resumeButton = new FlxButton(0, 0, "", resumeGame);
		sfxButton = new FlxButton(0, 0, "", muteSFX);
		fullscreenButton = new FlxButton(0, 0, "", fullScreen);
		restartButton.loadGraphic(AssetPaths.RETRY__png, true, 76, 50);
		musicButton.loadGraphic(AssetPaths.uncheckedMusic__png);
		resumeButton.loadGraphic(AssetPaths.RESUME__png, true, 76, 50);
		sfxButton.loadGraphic(AssetPaths.uncheckedSFX__png);
		fullscreenButton.loadGraphic(AssetPaths.uncheckedFS__png);
		menuButton = new FlxButton(0, 0, "", menuSwap);
		menuButton.loadGraphic(AssetPaths.startArrow__png, true, 76, 50);

		add(restartButton);
		add(musicButton);
		add(resumeButton);
		add(sfxButton);
		add(fullscreenButton);
		add(menuButton);
		restartButton.kill();
		musicButton.kill();
		resumeButton.kill();
		sfxButton.kill();
		fullscreenButton.kill();
		menuButton.kill();

		// Pause menu state tracking (state of the art)
		for (i in 0...carMax)
		{
			pauseCarX[i] = 0.0;
			pauseCarY[i] = 0.0;
		}
		// Scanline overlay
		scanlines = new FlxSprite(0, 0);
		scanlines.loadGraphic(AssetPaths.scanTest2__png);
		add(scanlines);

		// Debug stuff
		FlxG.watch.add(player, "x");
		FlxG.watch.add(player, "y");
		FlxG.watch.add(player, "angle");
		FlxG.watch.add(restartButton, "y");
		FlxG.watch.add(car, "x", "Enemy x");
	}

	// Make stuff happen
	override public function update(elapsed:Float)
	{
		this.env.update(this.player.y);

		checkVolume();
		if (FlxG.keys.anyJustReleased([P])) // Check to see if game is paused
		{
			isPaused = !isPaused;
		}
		if (!isPaused && player.y > -1 * WINDIST)
		{
			if (isMenu)
			{
				MainTheme.play();
				PauseTheme.pause();
				MainTheme.time = PauseTheme.time;
				screenDarken.kill();
				restartButton.kill();
				musicButton.kill();
				resumeButton.kill();
				sfxButton.kill();
				fullscreenButton.kill();
				pauseMenuBackground.kill();
				isMenu = false;
			}
			Meta.isOutOfControl = false;
			timerUpdate();

			// Puts the player directly below center screen
			uiCamera.scroll.x = 0;
			uiCamera.scroll.y = player.y - 450;
			scanlines.y = uiCamera.scroll.y;
			scanlines.x = uiCamera.x;
			meterMove();

			spawnCars(); // Spawn some cars
			preventCarsFromHittingEachother(); // This one does something, not quite sure what
			healthCheck();

			super.update(elapsed);

			carCollide();

			bumperUpdate();

			trailerHitch(); // Update trailer angle
			trailerPosition();

			// Move boxes to be on trailer
			if (playerHealth > 0)
			{
				boxPos(boxOne, boxOnePoint);
			}
			if (playerHealth > 1)
			{
				boxPos(boxTwo, boxTwoPoint);
			}
			if (playerHealth > 2)
			{
				boxPos(boxThree, boxThreePoint);
			}
			if (playerHealth > 3)
			{
				boxPos(boxFour, boxFourPoint);
			}
			// Kill offscreen boxes
			boxKiller(boxOne);
			boxKiller(boxTwo);
			boxKiller(boxThree);
			boxKiller(boxFour);
		}
		else if (player.y < -1 * WINDIST) // Win game! Yay!
		{
			Meta.isOutOfControl = true;
			if (!isWin)
			{
				isWin = true;
				pausePlayerSpeed = Player.speed;
				pausePlayerAngle = player.angle;
				pausePlayerX = player.x;
			}
			super.update(elapsed);
			winImmune = carCollide();
			preventCarsFromHittingEachother();
			if (winImmune)
			{
				playerHealth += 1;
			}
			Player.speed = pausePlayerSpeed;
			player.angle = 0;
			player.x = pausePlayerX;

			trailerHitch();
			trailerPosition();

			// Move boxes to be on trailer
			if (playerHealth > 0)
			{
				boxPos(boxOne, boxOnePoint);
			}
			if (playerHealth > 1)
			{
				boxPos(boxTwo, boxTwoPoint);
			}
			if (playerHealth > 2)
			{
				boxPos(boxThree, boxThreePoint);
			}
			if (playerHealth > 3)
			{
				boxPos(boxFour, boxFourPoint);
			}
			uiCamera.scroll.y = player.y + winCounter - 450;
			scanlines.y = uiCamera.scroll.y;
			meterMove();
			winCounter += 5;
			if (winCounter > 150 * 5)
			{
				winGame(); // Win game
			}
		}
		else if (player.alive) // Pause menu goes here
		{
			Meta.isOutOfControl = true;
			if (!isMenu)
			{
				MainTheme.pause();
				PauseTheme.play();
				PauseTheme.time = MainTheme.time;
				isMenu = true;
				screenDarken.reset(0, uiCamera.scroll.y);
				pauseMenuBackground.reset(400 - (pauseMenuBackground.width / 2), uiCamera.scroll.y + 238);
				fullscreenButton.reset(472, 300);
				sfxButton.reset(472, 349);
				musicButton.reset(472, 396);
				restartButton.reset(296, 512);
				resumeButton.reset(428, 512);
				pausePlayerX = player.x;
				pausePlayerY = player.y;
				pausePlayerSpeed = Player.speed;
				pausePlayerAngle = player.angle;
				for (i in 0...carMax)
				{
					pauseCarX[i] = car[i].x;
					pauseCarY[i] = car[i].y;
				}
			}
			super.update(elapsed);
			// Make sure the world stays still
			player.x = pausePlayerX;
			player.y = pausePlayerY;
			player.angle = pausePlayerAngle;
			Player.speed = pausePlayerSpeed;
			for (i in 0...carMax)
			{
				car[i].x = pauseCarX[i];
				car[i].y = pauseCarY[i];
			}

			if (sparks.emitting)
			{
				grindSound.stop();
				sparks.emitting = false;
			}
		}
	} // **********************************************************************************************************************************

	// Make cars within range of the player
	function spawnCars()
	{
		// Check if any cars are in the way
		furthestCar = 0;
		for (i in 0...carMax)
		{
			if (furthestCar > car[i].y)
			{
				furthestCar = car[i].y;
			}
		}
		for (i in 0...carMax)
		{
			if (!car[i].alive && furthestCar > player.y - 400) // Spaces cars properly
			{
				// Choose lane for car to drive in
				chooseLane = Std.random(3);
				if (chooseLane == 0) // 280
				{
					carSpawnX = 280;
				}
				else if (chooseLane == 1) // 402
				{
					carSpawnX = 402;
				}
				else // 520
				{
					carSpawnX = 520;
				}

				// Spawn car offscreen in front of player in a lane
				car[i].loadGraphic("assets/images/" + Cars.vehicles[chooseVehicle] + ".png");
				car[i].reset(carSpawnX - Std.int(car[i].width / 2), player.y - 50 * Std.random(3) - car[i].height - 600);
				car[i].velocity.set(0, -100 * Std.random(3) - 600); // Choose a random car speed
				chooseVehicle = Std.random(Cars.vehicles.length); // Pick out a car graphic
				carTotal += 1;
				furthestCar = car[i].y;
			}
		}
	}

	// Prevent cars from hitting each other
	function preventCarsFromHittingEachother()
	{
		for (i in 0...carMax)
		{
			for (j in 0...carMax)
			{
				if (car[i].x + (car[i].width / 2) == car[j].x + (car[j].width / 2)) // See if cars are in the same lane
				{
					if (car[i].y - car[j].y < 50 + car[j].height && car[i].y - car[j].y > 0) // See if cars are too close
					{
						car[i].velocity.set(0, car[j].velocity.y);
					}
				}
			}
		}
	}

	// Make trailer follow player
	function trailerHitch()
	{
		// Make trailer angle lag behind player angle
		if (trailer.angle != player.angle)
		{
			trailer.angle += .075 * (player.angle - trailer.angle);
		}

		// Set a max relative angle
		if (Math.abs(player.angle - trailer.angle) > 30)
		{
			if (player.angle > trailer.angle)
			{
				trailer.angle = player.angle + 30;
			}
			else
			{
				trailer.angle = player.angle - 30;
			}
		}

		// Make car turn less due to trailer angle
		if (trailer.angle != player.angle)
		{
			player.angle += 0.1 * (trailer.angle - player.angle);
		}
	}

	function trailerPosition()
	{
		w1 = Std.int(player.width);
		// Set trailer position respective to angles
		theta1 = player.angle * Math.PI / 180;
		theta2 = trailer.angle * Math.PI / 180;
		a = h1 / 2;
		b = h2 / 2;
		trailerX = 0 + w1 / 2 - b * Math.sin(theta2) - a * Math.sin(theta1) - w2 / 2;
		trailerY = 0 - h1 / 2 - b * Math.cos(theta2) - a * Math.cos(theta1) + h2 / 2;
		trailer.setPosition(player.x + trailerX, player.y - trailerY);
	}

	function carCollide()
	{
		isImmune = false;
		for (i in 0...carMax)
		{
			// "May be slow, so use it sparingly." - FlxCollision documentation
			// Call it every frame! lmao
			if (!isImmune && car[i].alive)
			{
				if (FlxG.overlap(player, car[i], hitBoxHit)
					|| FlxG.overlap(trailer, car[i], hitBoxHit)) // KARL CHECK HERE FOR OPTIMIZATION STUFF
				{
					if (FlxCollision.pixelPerfectCheck(player, car[i]) || FlxCollision.pixelPerfectCheck(trailer, car[i]))
					{
						car[i].kill();
						isImmune = true;
						carTotal -= 1;

						// Particle explosion
						carExplode.x = car[i].x + (car[i].width / 2);
						carExplode.y = car[i].y + (car[i].height / 2);
					}
				}
			}
			// Check to see if car is passed offscreen
			if (car[i].y > player.y + 800 && !isWin)
			{
				car[i].kill();
				carTotal -= 1;
			}
		}
		if (isImmune) // Check if car hit
		{
			carExplode.speed.set(1, 10000);
			carExplode.start(true, 0, 0);
			crashSound.stop();
			crashSound.play();
			playerHealth -= 1;
		}
		return isImmune;
	}

	function boxPos(box:Boxes, point:FlxPoint)
	{
		theta2 = trailer.angle * Math.PI / 180;
		refAngle = Math.tan(point.y / point.x);
		refLength = point.x / Math.sin(refAngle);
		boxX = 0 + w2 / 2 + refLength * Math.sin(refAngle - theta2) - Boxes.BOXW / 2 + BOXSPACING * Math.sin(-theta2);
		boxY = 0 + h2 / 2 + refLength * Math.cos(refAngle - theta2) - Boxes.BOXH / 2 + BOXSPACING * Math.cos(-theta2);
		box.setPosition(trailer.x + boxX, trailer.y + boxY);
		box.angle = trailer.angle;
	}

	function healthCheck()
	{
		if (playerHealth <= 0)
		{
			boxSpin(boxOne);
			loseGame();
		}
		else if (playerHealth == 1)
		{
			boxSpin(boxTwo);
		}
		else if (playerHealth == 2)
		{
			boxSpin(boxThree);
		}
		else if (playerHealth == 3)
		{
			boxSpin(boxFour);
		}
	}

	function winGame()
	{
		if (!isWinMenu)
		{
			NGio.postScore(Std.int(currentTime.elapsedTime * 100), "Fastest Completion");
			NGio.unlockMedal(64830);
			if (currentTime.elapsedTime < 90)
			{
				NGio.unlockMedal(64831);
			}
			winscreen.reset(400 - (winscreen.width / 2), uiCamera.scroll.y + 238);
			winText.text = "You made it in " + Math.round(currentTime.elapsedTime * 100) / 100 + " Seconds!";
			winText.reset(220, uiCamera.scroll.y + 300);
			winText.size = 20;
			restartButton.reset(218, 514);
			menuButton.reset(506, 514);
			isWinMenu = !isWinMenu;
			confetti.emitting = true;
			confetti.start(true);
		}
		winscreen.y = uiCamera.scroll.y + 238;
		winText.y = uiCamera.scroll.y + 330;
		confetti.x = 400;
		confetti.y = uiCamera.scroll.y + 450;
	}

	function timerUpdate()
	{
		if (-player.velocity.y * (MAXTIME - currentTime.elapsedTime) < WINDIST + player.y) // Check to see if player is too slow to complete course
		{
			faster.revive();
		}
		else
		{
			faster.kill();
		}
		timerDisp.text = Std.string(Math.round(MAXTIME - currentTime.elapsedTime)); // update timer display
		if (currentTime.elapsedTime >= MAXTIME) // See if time has run out
		{
			loseGame();
		}
	}

	function bumperUpdate()
	{
		FlxG.worldBounds.set();
		leftBumper.immovable = true;
		rightBumper.immovable = true;

		if (FlxG.collide(player, leftBumper))
		{
			Player.speed -= 5;
			sparks.emitting = true;
			sparks.x = player.x;
			sparks.y = player.y + 10;
			grindSound.play();
		}
		else if (FlxG.collide(player, rightBumper))
		{
			Player.speed -= 5;
			rightBumper.color = FlxColor.WHITE;
			sparks.emitting = true;
			sparks.x = player.x + player.width;
			sparks.y = player.y + 10;
			grindSound.play();
		}
		else
		{
			grindSound.stop();
			rightBumper.color = FlxColor.GREEN;
			sparks.emitting = false;
		}
		rightBumper.y = player.y - 100;
		leftBumper.y = player.y - 100;
	}

	function boxSpin(box:Boxes) // Use when killing boxes
	{
		box.angularVelocity = 900;
		box.velocity.set(100 * Std.random(5), -100 * Math.random());
	}

	function boxKiller(box:Boxes)
	{
		if (box.y > player.y + 800)
		{
			box.kill();
		}
	}

	function meterMove()
	{
		speedometer.x = scanlines.x + 800 - speedometer.width;
		speedometer.y = scanlines.y + 900 - speedometer.height;

		faster.setPosition(speedometer.x + 71, speedometer.y + 149);

		// Needle angle control
		speedNeedle.angle = (Player.speed - ((Player.MINSPEED + Player.MAXSPEED) / 2)) * (260 / (-Player.MINSPEED + Player.MAXSPEED));
		speedNeedle.x = speedometer.x + 102 + (33 * Math.sin(speedNeedle.angle / 180 * Math.PI)) - (speedNeedle.width / 2);
		speedNeedle.y = speedometer.y + 102 - (33 * Math.cos(speedNeedle.angle / 180 * Math.PI)) - (speedNeedle.height / 2);

		timerDisplay.y = scanlines.y + 900 - timerDisplay.height;
		timerDisp.y = timerDisplay.y + 87;

		miniRoad.setPosition(50, scanlines.y + 100);
		if (!isWin)
		{
			miniCar.setPosition(40, scanlines.y + 100 + 510 * ((WINDIST + player.y) / WINDIST));
		}
		else
		{
			miniCar.setPosition(40, scanlines.y + 100);
		}
	}

	function checkVolume()
	{
		if (Meta.isMusicMuted)
		{
			PauseTheme.volume = 0;
			MainTheme.volume = 0;
		}
		else
		{
			PauseTheme.volume = 1;
			MainTheme.volume = 1;
		}
		if (Meta.isSFXMuted)
		{
			grindSound.volume = 0;
			crashSound.volume = 0;
			buttonSound.volume = 0;
		}
		else
		{
			grindSound.volume = 1;
			crashSound.volume = 1;
			buttonSound.volume = 1;
		}
		if (!FlxG.fullscreen)
		{
			fullscreenButton.loadGraphic(AssetPaths.uncheckedFS__png);
		}
		else
		{
			fullscreenButton.loadGraphic(AssetPaths.checkedFS__png);
		}
		if (Meta.isMusicMuted)
		{
			musicButton.loadGraphic(AssetPaths.checkedMusic__png);
		}
		else
		{
			musicButton.loadGraphic(AssetPaths.uncheckedMusic__png);
		}
		if (Meta.isSFXMuted)
		{
			sfxButton.loadGraphic(AssetPaths.checkedSFX__png);
		}
		else
		{
			sfxButton.loadGraphic(AssetPaths.uncheckedSFX__png);
		}
	}

	function loseGame()
	{
		if (player.alive)
		{
			crashSound.stop();
			crashSound.play();
			boxSpin(boxFour);
			boxSpin(boxThree);
			boxSpin(boxTwo);
			boxSpin(boxOne);
			playerHealth = 0;
			currentTime.cancel();
			carExplode.x = player.x + (player.width / 2);
			carExplode.y = player.y + (player.height / 2);
			carExplode.start(true, 0, 0);
			player.kill();
			trailer.kill();
		}
		if (fadeToBlack.alpha < 1)
		{
			fadeToBlack.alpha += 0.01;
			fadeToBlack.y = uiCamera.scroll.y;
		}
		else if (!isLose) // Lose Screen
		{
			MainTheme.pause();
			PauseTheme.play();
			PauseTheme.time = MainTheme.time;
			isLose = true;
			losescreen.reset(400 - (winscreen.width / 2), uiCamera.scroll.y + 238);
			loseText.reset(220, uiCamera.scroll.y + 300);
			loseText.size = 20;
			loseText.text = "You made it " + (-1 * Math.round(player.y / WINDIST * 100)) + "% of the way!";
			restartButton.reset(218, 514);
			menuButton.reset(506, 514);
		}
	}

	// Button Functions
	function restartGame()
	{
		pushButton();
		FlxG.switchState(new PlayState());
	}

	function muteSFX()
	{
		pushButton();
		if (Meta.isSFXMuted)
		{
			Meta.isSFXMuted = false;
		}
		else
		{
			Meta.isSFXMuted = true;
		}
	}

	function fullScreen()
	{
		pushButton();
		FlxG.fullscreen = !FlxG.fullscreen;
	}

	function resumeGame()
	{
		pushButton();
		isPaused = false;
	}

	function muteMusic()
	{
		pushButton();
		if (Meta.isMusicMuted)
		{
			Meta.isMusicMuted = false;
		}
		else
		{
			Meta.isMusicMuted = true;
		}
	}

	function menuSwap()
	{
		pushButton();
		FlxG.switchState(new StartState());
	}

	function pushButton()
	{
		buttonSound.stop();
		buttonSound.play();
	}

	function hitBoxHit(objA, objB)
	{
		return 1;
	}
}
