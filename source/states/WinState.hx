package states;

// Internal imports

// External imports
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.system.debug.interaction.tools.Transform;

class WinState extends FlxState
{


	override public function create():Void
	{
		super.create();
		var winBG = new FlxSprite(0, 0);
		winBG.loadGraphic(AssetPaths.winScreen__png);
		add(winBG);

		var restartButton = new FlxButton(300, 400, "Restart", clickRestart);
		add(restartButton);
	}


	function clickRestart()
	{
		FlxG.switchState(new states.PlayState());
	}
}
