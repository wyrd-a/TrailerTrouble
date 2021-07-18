package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Bumpers extends FlxSprite
{
	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		makeGraphic(40, 400, FlxColor.RED);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
