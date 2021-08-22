package;

import flixel.FlxSprite;
import flixel.system.debug.interaction.tools.Transform;
import flixel.ui.FlxButton;
import flixel.FlxState;
import flixel.FlxG;
import flixel.system.FlxSound;

class StartState extends FlxState
{
	var startButton:FlxButton;
	var optionButton:FlxButton;

	var fullscreenButton:FlxButton;
	var musicButton:FlxButton;
	var sfxButton:FlxButton;
	var backButton:FlxButton;

	var optionsScreen:FlxSprite;

	var startBG:FlxSprite;

	var isFullscreen:Bool;
	var isMusic:Bool;
	var isSFX:Bool;
	var isGameStart:Bool;

	var MenuTheme:FlxSound;

	var timeoutTimer:Int;

	var fadeToBlack:FlxSprite;

	override public function create():Void
	{
		super.create();
		isGameStart = false;
		timeoutTimer = 0;
		MenuTheme = new FlxSound();
		MenuTheme = FlxG.sound.load(AssetPaths.MenuTheme__ogg);
		MenuTheme.play();
		MenuTheme.looped = true;

		startBG = new FlxSprite(0, 0);
		startBG.loadGraphic("assets/images/Title_Art.png");
		add(startBG);

		startButton = new FlxButton(350, 200, "", clickStart);
		startButton.loadGraphic("assets/images/STARTBUTTON.png", true, 254, 63);
		add(startButton);
		startButton.x = 400 - (startButton.width / 2);

		optionButton = new FlxButton(350, 300, "", openOptions);
		optionButton.loadGraphic("assets/images/OPTIONBUTTON.png", true, 254, 63);
		add(optionButton);
		optionButton.x = 400 - (startButton.width / 2);

		// Options Screen popup
		optionsScreen = new FlxSprite(0, 150);
		optionsScreen.loadGraphic(AssetPaths.OptionsMainMenu__png);
		optionsScreen.x = 400 - (optionsScreen.width / 2);
		add(optionsScreen);
		optionsScreen.kill();

		// Options screen buttons
		fullscreenButton = new FlxButton(470, 210, "", makeFullScreen);
		fullscreenButton.loadGraphic(AssetPaths.uncheckedFS__png);
		musicButton = new FlxButton(470, 260, "", muteMusic);
		musicButton.loadGraphic(AssetPaths.uncheckedMusic__png);
		sfxButton = new FlxButton(470, 300, "", muteSFX);
		sfxButton.loadGraphic(AssetPaths.uncheckedSFX__png);
		add(fullscreenButton);
		add(musicButton);
		add(sfxButton);
		fullscreenButton.kill();
		musicButton.kill();
		sfxButton.kill();

		backButton = new FlxButton(0, 700, "", backCommand);
		backButton.loadGraphic(AssetPaths.backButton__png, true, 160, 50);
		backButton.x = 400 - (backButton.width / 2);
		add(backButton);
		backButton.kill();

		// Black fade
		fadeToBlack = new FlxSprite(0, 0);
		fadeToBlack.loadGraphic(AssetPaths.fadetoblack__png);
		add(fadeToBlack);
		fadeToBlack.alpha = 0;
	}

	override public function update(elapsed:Float):Void
	{
		if (!isGameStart)
		{
			if (!FlxG.fullscreen)
			{
				fullscreenButton.loadGraphic(AssetPaths.uncheckedFS__png);
				isFullscreen = FlxG.fullscreen;
			}
			super.update(elapsed);
		}
		else
		{
			timeoutTimer += 1;
			fadeToBlack.alpha = timeoutTimer / 100;
			MenuTheme.volume = 1 - (timeoutTimer / 100);
			if (timeoutTimer >= 100)
			{
				FlxG.switchState(new ControlsState());
			}
		}
	}

	function clickStart()
	{
		isGameStart = true;
	}

	function openOptions()
	{
		startButton.kill();
		optionButton.kill();
		optionsScreen.reset(400 - (optionsScreen.width / 2), 150);
		fullscreenButton.revive();
		musicButton.revive();
		sfxButton.revive();
		backButton.revive();
	}

	function makeFullScreen()
	{
		if (isFullscreen)
		{
			isFullscreen = false;
			FlxG.fullscreen = false;
			fullscreenButton.loadGraphic(AssetPaths.uncheckedFS__png);
		}
		else
		{
			isFullscreen = true;
			FlxG.fullscreen = true;
			fullscreenButton.loadGraphic(AssetPaths.checkedFS__png);
		}
	}

	function muteMusic()
	{
		if (isMusic)
		{
			isMusic = false;
			Meta.isMusicMuted = false;
			MenuTheme.volume = 1;
			musicButton.loadGraphic(AssetPaths.uncheckedMusic__png);
		}
		else
		{
			isMusic = true;
			Meta.isMusicMuted = true;
			MenuTheme.volume = 0;
			musicButton.loadGraphic(AssetPaths.checkedMusic__png);
		}
	}

	function muteSFX()
	{
		if (isSFX)
		{
			isSFX = false;
			Meta.isSFXMuted = false;
			sfxButton.loadGraphic(AssetPaths.uncheckedSFX__png);
		}
		else
		{
			isSFX = true;
			Meta.isSFXMuted = true;
			sfxButton.loadGraphic(AssetPaths.checkedSFX__png);
		}
	}

	function backCommand()
	{
		startButton.revive();
		optionButton.revive();
		optionsScreen.kill();
		fullscreenButton.kill();
		musicButton.kill();
		sfxButton.kill();
		backButton.kill();
	}
}
