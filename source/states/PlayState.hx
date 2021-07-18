package states;

import js.html.AbortController;
import flixel.animation.FlxBaseAnimation;
import flixel.text.FlxText;
import Math;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.math.FlxPoint;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

class PlayState extends FlxState
{
	var player:Player;

	var trailer:Trailer;
	var WINDIST:Float = 100000;

	// Particle effects
	var sparks:FlxEmitter;
	var carExplode:FlxEmitter;

	// Displays
	var speedDisp:FlxText = new FlxText(0, 0);
	var distDisp:FlxText;

	// Timer variables
	var MAXTIME:Float = 180; // In seconds
	var currentTime:Float = 0; // Keep track of time
	var timerDisp:FlxText; // Display at the top
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
	var car:Cars;
	var carMax:Int = 1;
	var carTotal:Int = 0;
	var carSpawnX:Int;
	var chooseLane:Int;
	var chooseVehicle:Int;

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

	// Side of Road stuff
	var RoadSign:Array<RoadSigns> = new Array();

	override public function create()
	{
		// Bumpers for keeping car on road
		leftBumper = new Bumpers(160, 0);
		add(leftBumper);
		rightBumper = new Bumpers(597, 0);
		add(rightBumper);

		// Background
		var bg:FlxBackdrop = new FlxBackdrop(AssetPaths.road__png, 1, 1, true, true);
		add(bg);

		// Player
		player = new Player(324, 0);
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

		// Test car
		car = new Cars(324, -500);
		add(car);
		car.kill();

		// Roadsigns
		for (i in 0...20) // Just testing how the signs look at speed
		{
			RoadSign[i] = new RoadSigns(0, -2000 * i);
			add(RoadSign[i]);
			trace(i);
		}

		// Particle effects
		sparks = new FlxEmitter(10, 10, 200);
		sparks.makeParticles(2, 2, FlxColor.WHITE, 200);
		add(sparks);
		sparks.start(false, .01);

		carExplode = new FlxEmitter(10, 10, 200);
		carExplode.makeParticles(10, 10, FlxColor.ORANGE, 200);
		add(carExplode);

		// Timer
		timerDisp = new FlxText(0, 0);
		timerDisp.size = 20;
		add(timerDisp);

		// Info Displays
		speedDisp = new FlxText(0, 0);
		distDisp = new FlxText(0, 0);
		speedDisp.bold = true;
		distDisp.bold = true;
		speedDisp.size = 20;
		distDisp.size = 20;
		add(speedDisp);
		add(distDisp);

		// Debug stuff
		FlxG.watch.add(player, "x");
		FlxG.watch.add(player, "y");
		FlxG.watch.add(player, "angle");
		FlxG.watch.add(car, "y", "Enemy Y");

		super.create();
	}

	// Make stuff happen
	override public function update(elapsed:Float)
	{
		timerUpdate();
		distDisp.text = "Distance: " + Math.round(-1 * player.y);
		speedDisp.text = "Speed: " + (Player.speed);
		speedDisp.y = player.y + 300;
		distDisp.y = player.y - 24 + 300;
		distDisp.x = 0;
		speedDisp.x = 0;

		carCollide();

		// Camera testing
		FlxG.camera.scroll.x = 0;
		FlxG.camera.scroll.y = player.y - 450;

		spawnCars(); // Spawn some cars
		healthCheck();

		bumperUpdate();

		super.update(elapsed);

		// Note: This block HAS to be in this order
		// Gotta move the player, then the trailer, then the boxes
		// player.velocity.set(0, -1 * Player.speed);
		// player.velocity.rotate(FlxPoint.weak(0, 0), player.angle);
		trailerHitch(); // Update trailer angle
		trailerPosition();
		// Move boxes to be on trailer
		boxPos(boxOne, boxOnePoint);
		boxPos(boxTwo, boxTwoPoint);
		boxPos(boxThree, boxThreePoint);
		boxPos(boxFour, boxFourPoint);

		winGame(); // Check to see if player is at required distance
	}

	// Make cars within range of the player
	function spawnCars()
	{
		if (!car.alive) // 190, 324, 440
		{
			// Choose lane for car to drive in
			chooseLane = Std.random(3);
			if (chooseLane == 0)
			{
				carSpawnX = 190 + 50;
			}
			else if (chooseLane == 1)
			{
				carSpawnX = 324 + 50;
			}
			else
			{
				carSpawnX = 440 + 50;
			}

			// Spawn car offscreen in front of player in a lane
			car.reset(carSpawnX, player.y - 800);
			chooseVehicle = Std.random(Cars.vehicles.length);
			car.loadGraphic("assets/images/" + Cars.vehicles[chooseVehicle] + ".png");
			carTotal += 1;
		}
	}

	// Make trailer follow player
	function trailerHitch()
	{
		// Make trailer angle lag behind player angle
		if (trailer.angle != player.angle)
		{
			trailer.angle += .1 * (player.angle - trailer.angle);
		}

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
		// "May be slow, so use it sparingly." - FlxCollision documentation
		// Call it every frame! lmao
		if (FlxCollision.pixelPerfectCheck(player, car) || FlxCollision.pixelPerfectCheck(trailer, car))
		{
			car.kill();
			playerHealth -= 1;
			carTotal -= 1;

			// Particle explosion
			carExplode.x = car.x + 30;
			carExplode.y = car.y + 40;
			carExplode.start(true, 0, 0);
		}
		// Check to see if car is passed offscreen
		else if (car.y > player.y + 800)
		{
			car.kill();
			carTotal -= 1;
		}
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
			FlxG.switchState(new LoseState());
		}
		else if (playerHealth == 1)
		{
			boxTwo.kill();
		}
		else if (playerHealth == 2)
		{
			boxThree.kill();
		}
		else if (playerHealth == 3)
		{
			boxFour.kill();
		}
	}

	function winGame()
	{
		if (player.y * -1 >= WINDIST)
		{
			FlxG.switchState(new WinState());
		}
	}

	function timerUpdate()
	{
		currentTime += 1 / 30; // Karl plz help the whole game is tied to framerate and thats bad design
		if (-player.velocity.y * (MAXTIME - currentTime) < WINDIST + player.y) // Check to see if player is too slow to complete course
		{
			timerDisp.color = FlxColor.RED;
			// Also wanna make a "TOO SLOW" popup or something idk, we'll get art for it
		}
		else
		{
			timerDisp.color = FlxColor.WHITE;
		}
		timerDisp.text = "Time: " + Math.round(MAXTIME - currentTime); // update timer display
		timerDisp.y = player.y - 100; // Keep timer onscreen
		if (currentTime >= MAXTIME) // See if time has run out
		{
			FlxG.switchState(new LoseState());
		}
	}

	function bumperUpdate() // Need to make it so bumpers don't move in the x direction ;)
	{
		FlxG.worldBounds.set();
		leftBumper.immovable = true;
		rightBumper.immovable = true;

		if (FlxG.collide(player, leftBumper))
		{
			// leftBumper.color = FlxColor.BLUE;
			sparks.emitting = true;
			sparks.x = leftBumper.x + 20;
			sparks.y = player.y + 10;
		}
		else if (FlxG.collide(player, rightBumper))
		{
			// rightBumper.color = FlxColor.BLUE;
			sparks.emitting = true;
			sparks.x = rightBumper.x;
			sparks.y = player.y + 10;
		}
		else
		{
			// rightBumper.color = FlxColor.RED;
			// leftBumper.color = FlxColor.RED;
			sparks.emitting = false;
		}
		rightBumper.y = player.y - 100;
		leftBumper.y = player.y - 100;
	}
}
