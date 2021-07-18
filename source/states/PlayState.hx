package states;

// Internal
import configs.Config;
import env.Environment;
import player.NewPlayer;
// External
import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	private var player:NewPlayer;
	private var environment:Environment;

	override public function create()
	{
		environment = new Environment(add);
		player = new NewPlayer();

		add(player);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.camera.scroll.x = 0;
		FlxG.camera.scroll.y = player.y - (Config.WINDOW_HEIGHT / 2);
	}
}
