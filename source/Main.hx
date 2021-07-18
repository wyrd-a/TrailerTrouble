package;

// Internal imporrts
import states.StartState;

// External imports
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(800, 900, StartState));
	}
}
