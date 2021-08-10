package env;

// External imports
import flixel.FlxSprite;

class Sign extends FlxSprite
{
	public function new(x:Int = 0, y:Int = 0)
	{
		super(x, y);
		loadGraphic(AssetPaths.roadSign1__png, 100, 100);
	}
}
