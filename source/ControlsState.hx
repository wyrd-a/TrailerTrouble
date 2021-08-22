package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.system.FlxSound;

class ControlsState extends FlxState
{
	var controlsScreen:FlxSprite;
	var nextButton:FlxButton;

	var buttonSound:FlxSound;

	var scanlines:FlxSprite;

	override public function create():Void
	{
		buttonSound = new FlxSound();
		buttonSound = FlxG.sound.load(AssetPaths.button_push__wav);
		if (Meta.isSFXMuted)
		{
			buttonSound.volume = 0;
		}

		controlsScreen = new FlxSprite(0, 0);
		controlsScreen.loadGraphic(AssetPaths.controlsPage__png);
		add(controlsScreen);

		nextButton = new FlxButton(700, 800, "", goNext);
		nextButton.loadGraphic(AssetPaths.startArrow__png, true, 76, 50);
		add(nextButton);

		scanlines = new FlxSprite(0, 0).loadGraphic(AssetPaths.scanTest2__png);
		add(scanlines);
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	function goNext()
	{
		pushButton();
		FlxG.switchState(new PlayState());
	}

	function pushButton()
	{
		buttonSound.stop();
		buttonSound.play();
	}
}
