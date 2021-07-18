package;

// Internal imporrts
import configs.Config;
import states.StartState;
// External imports
import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		FlxG.fixedTimestep = false;
		super();
		addChild(new FlxGame(Config.WINDOW_WIDTH, Config.WINDOW_HEIGHT, StartState));
	}
}
