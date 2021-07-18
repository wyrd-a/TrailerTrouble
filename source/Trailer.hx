package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Trailer extends FlxSprite
{
	// Define the car's size and look
	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		loadGraphic("assets/images/trailer.png", 92, 139);
	}

	// What changes with the car every frame
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}