package;

import flixel.FlxSprite;
import flixel.system.debug.interaction.tools.Transform;
import flixel.ui.FlxButton;
import flixel.FlxState;
import flixel.FlxG;

class WinState extends FlxState
{
	var restartButton:FlxButton;

	var winBG:FlxSprite;

	override public function create():Void
	{
		super.create();
		winBG = new FlxSprite(0, 0);
		winBG.loadGraphic("assets/images/winScreen.png");
		add(winBG);

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
