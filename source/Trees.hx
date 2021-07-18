package;

import flixel.FlxSprite;
import flixel.FlxG;

class Trees extends FlxSprite
{
	public function new(x:Float = 800 - 87, y:Float = 0)
	{
		super(x, y);

		loadGraphic(AssetPaths.trees__png);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
