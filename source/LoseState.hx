package;

import flixel.FlxSprite;
import flixel.system.debug.interaction.tools.Transform;
import flixel.ui.FlxButton;
import flixel.FlxState;
import flixel.FlxG;

class LoseState extends FlxState
{
	var restartButton:FlxButton;

	var loseBG:FlxSprite;

	override public function create():Void
	{
		super.create();
		loseBG = new FlxSprite(0, 0);
		loseBG.loadGraphic("assets/images/loseScreen.png");
		add(loseBG);

		restartButton = new FlxButton(300, 400, "Restart", clickRestart);
		add(restartButton);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	function clickRestart()
	{
		FlxG.switchState(new PlayState());
	}
}
