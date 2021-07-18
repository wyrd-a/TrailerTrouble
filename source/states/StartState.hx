package states;

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
		var startBg = new FlxSprite(0, 0);
		startBg.loadGraphic(AssetPaths.startScreen__png);

		var startButton = new FlxButton(0, 0, "Start", clickStart);
		startButton.screenCenter();

		add(startBg);
		add(startButton);
	}

	function clickStart()
	{
		FlxG.switchState(new states.PlayState());
	}
}
