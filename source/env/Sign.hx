package env;

// External imports
import flixel.FlxSprite;

class Sign extends FlxSprite
{
	public function new()
	{
		super(0, 0);
		loadGraphic(AssetPaths.roadSign1__png, 100, 100);
	}
}
