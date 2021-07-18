package;

import flixel.FlxSprite;
import flixel.system.debug.interaction.tools.Transform;
import flixel.ui.FlxButton;
import flixel.FlxState;
import flixel.FlxG;

class StartState extends FlxState
{
	var startButton:FlxButton;

	var startBG:FlxSprite;

	override public function create():Void
	{
		super.create();
		startBG = new FlxSprite(0, 0);
		startBG.loadGraphic("assets/images/startScreen.png");
		add(startBG);

		startButton = new FlxButton(300, 400, "Start", clickStart);
		add(startButton);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	function clickStart()
	{
		FlxG.switchState(new PlayState());
	}
}
