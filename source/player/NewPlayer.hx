package player;

// Internal import
import configs.Config;
import utils.Movement;
// External import
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class NewPlayer extends FlxSprite
{
	private var sprite:String;
	private var spriteWidth:Int;
	private var spriteHeight:Int;

	override public function update(elapsed:Float)
	{
		updateMovement();
		super.update(elapsed);
	}

	public function new(x:Int = 0, y:Int = 0, sprite:String = AssetPaths.playerModel__png, spriteWidth:Int = 74, spriteHeight:Int = 162)
	{
		super(x, y);
		loadGraphic(sprite, spriteHeight, spriteWidth);
	}

	function updateMovement()
	{
		var up = FlxG.keys.anyPressed([UP, W]);
		var down = FlxG.keys.anyPressed([DOWN, S]);
		var left = FlxG.keys.anyPressed([LEFT, A]);
		var right = FlxG.keys.anyPressed([RIGHT, D]);

		utils.Movement.calcMovement(up, down, left, right, 1.0, 1.0);
	}

	function updatePosition() {}
}
