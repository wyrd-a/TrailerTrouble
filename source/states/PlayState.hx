package states;

// Internal
import player.Player;
import configs.Config;
import env.Environment;
// External
import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	private var player:Player;
	private var environment:Environment;

	override public function create()
	{
		this.environment = new Environment(add, remove);
		this.player = new Player();

		add(player);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// Manually update environment
		environment.updateEnv(this.player.y);

		FlxG.camera.scroll.x = 0;
		FlxG.camera.scroll.y = player.y - (Config.WINDOW_HEIGHT / 2);
	}
}
