package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
	static var playerAngle:Float = 0;
	public static var speed:Float = 0;

	var ANGLECHANGE:Float = 4;
	var MAXSPEED = 1500;

	public static var STARTSPEED = 1000;

	override public function update(elapsed:Float)
	{
		updateMovement();
		// keepOnRoad();
		noReverse();
		hitboxResize();
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

		up = FlxG.keys.anyPressed([UP, W]);
		down = FlxG.keys.anyPressed([DOWN, S]);
		left = FlxG.keys.anyPressed([LEFT, A]);
		right = FlxG.keys.anyPressed([RIGHT, D]);
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
		else if (down)
		{
			speed -= 20;

			// Keep speed positive
			if (speed < 0)
			{
				speed = 0;
			}
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
	}

	function keepOnRoad()
	{
		if (x + 74 > 597)
		{
			x = 597 - 74;
		}
		else if (x < 200)
		{
			x = 200;
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
		if (angle > 0)
		{
			offset.x = -(width - w1) / 2;
		}
		else
		{
			offset.x = -(width - w1) / 2;
		}
	}
}