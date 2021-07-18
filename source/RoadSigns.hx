package;

import flixel.FlxSprite;

class RoadSigns extends FlxSprite
{
	// Define the sign's size and look
	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		loadGraphic("assets/images/" + "trees" + ".png");
	}

	// What changes with the sign every frame
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
