package;

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

		// Other cars on road
		for (i in 0...carMax)
		{
			car[i] = new Cars(1000, -500); // Very important that this starts offscreen
			add(car[i]);
			car[i].kill();
		}

		// Roadsigns
		for (i in 0...50) // Just testing how the signs look at speed
		{
			RoadSign[i] = new RoadSigns(700, -360 * i);
			add(RoadSign[i]);
			trace(i);
		}

		// Particle effects
		sparks = new FlxEmitter(10, 10, 200);
		sparks.makeParticles(2, 2, FlxColor.WHITE, 200);
		add(sparks);
		sparks.start(false, .01);

		carExplode = new FlxEmitter(2, 2, 400);
		carExplode.makeParticles(4, 4, FlxColor.ORANGE, 400);
		carExplode.speed.set(25, 800, 100, 425);
		add(carExplode);
		carExplode.color.set(0xf9c22b, 0xf79617, 0xffffff);

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
		FlxG.watch.add(car, "x", "Enemy x");

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

		// Puts the player directly below center screen
		FlxG.camera.scroll.x = 0;
		FlxG.camera.scroll.y = player.y - 450;

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

		winGame(); // Check to see if player is at required distance
	}

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
				if (car[i].x + (car[i].width / 2) == car[j].x + (car[j].width / 2)) // See if cars are in the same lane
				{
					if (car[i].y - car[j].y < 50 + car[j].height && car[i].y - car[j].y > 0) // See if cars are too close
					{
						car[i].velocity.set(0, car[j].velocity.y);
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
		isImmune = false;
		for (i in 0...carMax)
		{
			// "May be slow, so use it sparingly." - FlxCollision documentation
			// Call it every frame! lmao
			if (!isImmune
				&& car[i].alive
				&& (FlxCollision.pixelPerfectCheck(player, car[i]) || FlxCollision.pixelPerfectCheck(trailer, car[i])))
			{
				car[i].kill();
				isImmune = true;
				carTotal -= 1;

				// Particle explosion
				carExplode.x = car[i].x + 30;
				carExplode.y = car[i].y + 40;
			}
			// Check to see if car is passed offscreen
			else if (car[i].y > player.y + 800)
			{
				car[i].kill();
				carTotal -= 1;
			}
		}
		if (isImmune) // Check if car hit
		{
			carExplode.start(true, 0, 0);
			playerHealth -= 1;
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
			boxSpin(boxOne);
			FlxG.switchState(new LoseState());
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

	function bumperUpdate()
	{
		FlxG.worldBounds.set();
		leftBumper.immovable = true;
		rightBumper.immovable = true;

		if (FlxG.collide(player, leftBumper))
		{
			// leftBumper.color = FlxColor.BLUE;
			sparks.emitting = true;
			sparks.x = player.x;
			sparks.y = player.y + 10;
		}
		else if (FlxG.collide(player, rightBumper))
		{
			rightBumper.color = FlxColor.WHITE;
			sparks.emitting = true;
			sparks.x = player.x + player.width;
			sparks.y = player.y + 10;
		}
		else
		{
			rightBumper.color = FlxColor.GREEN;
			// leftBumper.color = FlxColor.RED;
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
}
