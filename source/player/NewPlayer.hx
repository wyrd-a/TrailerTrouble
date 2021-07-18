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

class NewPlayer extends FlxSprite
{
	private var sprite:String;
	private var spriteWidth:Int;
	private var spriteHeight:Int;

	private var jerk:Float;
	private var angJerk:Float;
	private var dragCoeff:Int;
	private var angDragRatio:Int;

	public function new(x:Int = 0, y:Int = 0, sprite:String = AssetPaths.playerModel__png, spriteWidth:Int = 74, spriteHeight:Int = 162, jerk:Float = 5,
			angJerk:Float = 5, dragCoeff:Float = 0.01, angDragRatio:Int = 0)
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
		var up = FlxG.keys.anyPressed([UP, W]);
		var down = FlxG.keys.anyPressed([DOWN, S]);
		var left = FlxG.keys.anyPressed([LEFT, A]);
		var right = FlxG.keys.anyPressed([RIGHT, D]);

		var conflictingY = !(up != down);
		var conflictingX = !(left != right);

		var newAccelY = acceleration.y;
		var newAccelX = acceleration.x;

		if (!conflictingY)
		{
			if (up)
			{
				newAccelY -= jerk;
			}
			else
			{
				newAccelY += jerk;
			}
		}

		acceleration.set(newAccelX, newAccelY);
	}
}
