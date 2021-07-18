package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Boxes extends FlxSprite
{
	static public var BOXW:Int = 24;
	static public var BOXH:Int = 32;

	public function new(x:Float = 0, y:Float = 0)
	{
		super();
		loadGraphic(AssetPaths.box__png);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
