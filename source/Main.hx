package;

import flixel.FlxGame;
import openfl.display.Sprite;
import flixel.FlxG;

class Main extends Sprite
{
	public function new()
	{
		FlxG.fixedTimestep = false;
		super();
		addChild(new FlxGame(800, 900, StartState));
	}
}
