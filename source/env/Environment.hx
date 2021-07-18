package env;

// Internal imports
import env.Tree;
import env.Sign;
// External imports
import flixel.FlxBasic;
import flixel.addons.display.FlxBackdrop;

class Environment
{
	private var backdrop:FlxBackdrop;
	private var trees:Array<Tree>;
	private var signs:Array<Sign>;
	private var add:FlxBasic->FlxBasic;

	public function new(add:FlxBasic->FlxBasic)
	{
		trees = [];
		signs = [];
		backdrop = new FlxBackdrop(AssetPaths.road__png, 1, 1, true, true);

		add(backdrop);
	}

	public function updateEnv() {}
}
