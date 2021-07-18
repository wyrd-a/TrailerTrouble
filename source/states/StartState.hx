package states;

// Internal imports

// External imports
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.system.debug.interaction.tools.Transform;

class StartState extends FlxState
{
	override public function create():Void
	{
		super.create();
		var startBG = new FlxSprite(0, 0);

		startBG.loadGraphic(AssetPaths.startScreen__png);
		add(startBG);

		var startButton = new FlxButton(300, 400, "Start", clickStart);
		add(startButton);
	}

	// override public function update(elapsed:Float):Void
	// {
	// 	super.update(elapsed);
	// }

	function clickStart()
	{
		FlxG.switchState(new states.PlayState());
	}
}
