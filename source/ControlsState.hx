package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.ui.FlxButton;

class ControlsState extends FlxState
{
	var controlsScreen:FlxSprite;
	var nextButton:FlxButton;

	override public function create():Void
	{
		controlsScreen = new FlxSprite(0, 0);
		controlsScreen.loadGraphic(AssetPaths.controlsPage__png);
		add(controlsScreen);

		nextButton = new FlxButton(700, 800, "", goNext);
		nextButton.loadGraphic(AssetPaths.startArrow__png, true, 76, 50);
		add(nextButton);
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	function goNext()
	{
		FlxG.switchState(new PlayState());
	}
}
