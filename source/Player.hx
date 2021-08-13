package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
	static var playerAngle:Float = 0;
	public static var speed:Float = 0;

	var ANGLECHANGE:Float = 3;
	var MAXSPEED = 1500;

	public static var STARTSPEED = 1000;

	override public function update(elapsed:Float)
	{
		updateMovement();
		noReverse();
		hitboxResize();
		keepOnRoad();
		super.update(elapsed);
	}

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		loadGraphic("assets/images/playerModel.png", 74, 162);
	}

	function updateMovement()
	{
		var up:Bool = false;
		var down:Bool = false;
		var left:Bool = false;
		var right:Bool = false;
		var space:Bool = false;

		up = FlxG.keys.anyPressed([UP, W]);
		down = FlxG.keys.anyPressed([DOWN, S]);
		left = FlxG.keys.anyPressed([LEFT, A]);
		right = FlxG.keys.anyPressed([RIGHT, D]);
		space = FlxG.keys.anyPressed([SPACE]);
		if (up && down)
		{
			up = down = false;
		}
		if (left && right)
		{
			left = right = false;
		}
		if (right || left)
		{
			if (right)
			{
				angle += ANGLECHANGE;
			}
			else if (left)
			{
				angle -= ANGLECHANGE;
			}
		}
		if (up)
		{
			speed += 4;
		}

		// Cap speed
		if (speed > MAXSPEED)
		{
			speed = MAXSPEED;
		}
		else if (space)
		{
			speed -= 40;
		}
		else if (down)
		{
			speed -= 20;
		}
		// Keep speed FAST
		if (speed < 600)
		{
			speed = 600;
		}

		// Keep playerAngle between -180 and 180
		/*if (playerAngle > 179)
			{
				playerAngle = -180;
			}
			if (playerAngle < -180)
			{
				playerAngle = 179;
			}
		 */
		velocity.set(0, -1 * speed);
		velocity.rotate(FlxPoint.weak(0, 0), angle);
		velocity.y = -1 * speed;
	}

	function keepOnRoad()
	{
		if (x + width > 597)
		{
			x = 597 - width;
		}
		else if (x < 199)
		{
			x = 199;
		}
	}

	function noReverse()
	{
		if (angle > 45)
		{
			angle = 45;
		}
		else if (angle < -45)
		{
			angle = -45;
		}
	}

	function hitboxResize() // make hitbox scale with player rotation for bumper collision
	{
		var w1:Float = 74;
		var h1:Float = 162;
		width = 89 * Math.sin(Math.abs(angle) / 180 * Math.PI) + w1;
		offset.x = -(width - w1) / 2;
	}
}
