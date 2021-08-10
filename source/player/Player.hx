package player;

// Internal import
import configs.Config;
// import utils.Movement;
// External import
import Math;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
	private var speed:Float = 0;
	private var accel:Float = 4;
	private var brake:Float = 20;
	private var ebrake:Float = 40;
	private var maxAngle:Float = 90;
	private var minSpeed:Float = 0;
	private var maxSpeed:Float = 1500;
	private var rotationAccel:Float = 2;

	public function new(x:Int = 0, y:Int = 0, sprite:String = AssetPaths.playerModel__png, spriteWidth:Int = 74, spriteHeight:Int = 162)
	{
		super(x, y);
		var sprite = loadGraphic(sprite, spriteHeight, spriteWidth);
		sprite.setPosition((Config.WINDOW_WIDTH / 2) - (sprite.width / 2), (Config.WINDOW_HEIGHT) - sprite.height);
	}

	override public function update(elapsed:Float)
	{
		updateMovement();
		super.update(elapsed);
	}

	private function updateMovement()
	{
		var up:Bool = FlxG.keys.anyPressed([UP, W]);
		var down:Bool = FlxG.keys.anyPressed([DOWN, S]);
		var left:Bool = FlxG.keys.anyPressed([LEFT, A]);
		var right:Bool = FlxG.keys.anyPressed([RIGHT, D]);
		var space:Bool = FlxG.keys.anyPressed([SPACE]);

		if (up && down)
		{
			up = down = false;
		}

		if (left && right)
		{
			left = right = false;
		}

		if (right)
		{
			this.angle = Math.min(this.angle + rotationAccel, maxAngle);
		}

		if (left)
		{
			this.angle = Math.max(this.angle - rotationAccel, -maxAngle);
		}

		if (up)
		{
			speed = Math.min(speed + accel, maxSpeed);
		}
		else
		{
			speed = Math.max(speed - accel, minSpeed);
		}

		if (down)
		{
			speed = Math.max(speed - brake, minSpeed);
		}

		if (space)
		{
			speed = Math.max(speed - ebrake, minSpeed);
		}

		this.velocity.set(0, -1 * speed);
		this.velocity.rotate(FlxPoint.weak(0, 0), this.angle);
		this.velocity.y = -1 * speed;
	}
}
