package states;

import flixel.FlxSprite;
import flixel.system.debug.interaction.tools.Transform;
import flixel.ui.FlxButton;
import flixel.FlxState;
import flixel.FlxG;

class LoseState extends FlxState
{


	override public function create():Void
	{
		super.create();
		var loseBG = new FlxSprite(0, 0);
		loseBG.loadGraphic(AssetPaths.loseScreen__png);
		add(loseBG);

		var restartButton = new FlxButton(300, 400, "Restart", clickRestart);
		add(restartButton);
	}



	function clickRestart()
	{
		FlxG.switchState(new states.PlayState());
	}
}
