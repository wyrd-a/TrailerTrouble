package;

import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.FlxState;
import flixel.FlxG;
import flixel.system.FlxSound;
import io.newgrounds.NG;

class StartState extends FlxState
{
	var buttonSound:FlxSound;
	var introVoice:FlxSound;

	var startButton:FlxButton;
	var optionButton:FlxButton;

	var fullscreenButton:FlxButton;
	var musicButton:FlxButton;
	var sfxButton:FlxButton;
	var backButton:FlxButton;

	var optionsScreen:FlxSprite;

	var startBG:FlxSprite;
	var title:FlxSprite;

	var isFullscreen:Bool;
	var isMusic:Bool;
	var isSFX:Bool;
	var isGameStart:Bool;

	var creditsButton:FlxButton;
	var creditsScreen:FlxSprite;
	var creditsBack:FlxButton;

	var MenuTheme:FlxSound;

	var timeoutTimer:Int;

	var fadeToBlack:FlxSprite;

	var scanlines:FlxSprite;

	override public function create():Void
	{
		buttonSound = FlxG.sound.load(AssetPaths.button_push__wav);
		introVoice = new FlxSound();
		introVoice = FlxG.sound.load(AssetPaths.IntroVoice__wav);
		introVoice.volume = 0.8;
		introVoice.play();
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

		title = new FlxSprite(0, 50);
		title.loadGraphic(AssetPaths.TITLE__png);
		title.x = 400 - (title.width / 2);
		add(title);

		startButton = new FlxButton(350, 200, "", clickStart);
		startButton.loadGraphic("assets/images/STARTBUTTON.png", true, 254, 63);
		add(startButton);
		startButton.x = 400 - (startButton.width / 2);

		optionButton = new FlxButton(350, 300, "", openOptions);
		optionButton.loadGraphic("assets/images/OPTIONBUTTON.png", true, 254, 63);
		add(optionButton);
		optionButton.x = 400 - (optionButton.width / 2);

		// Options Screen popup
		optionsScreen = new FlxSprite(0, 150);
		optionsScreen.loadGraphic(AssetPaths.OptionsMainMenu__png);
		optionsScreen.x = 400 - (optionsScreen.width / 2);
		add(optionsScreen);
		optionsScreen.kill();

		// Options screen buttons
		fullscreenButton = new FlxButton(472, 212, "", makeFullScreen);
		fullscreenButton.loadGraphic(AssetPaths.uncheckedFS__png);
		sfxButton = new FlxButton(472, 261, "", muteSFX);
		sfxButton.loadGraphic(AssetPaths.uncheckedSFX__png);
		musicButton = new FlxButton(472, 308, "", muteMusic);
		musicButton.loadGraphic(AssetPaths.uncheckedMusic__png);
		add(fullscreenButton);
		add(musicButton);
		add(sfxButton);
		fullscreenButton.kill();
		musicButton.kill();
		sfxButton.kill();

		backButton = new FlxButton(0, 390, "", backCommand);
		backButton.loadGraphic(AssetPaths.backButton__png, true, 160, 50);
		backButton.x = 400 - (backButton.width / 2);
		add(backButton);
		backButton.kill();

		// Credits
		creditsButton = new FlxButton(25, 825, "", openCredits);
		creditsButton.loadGraphic(AssetPaths.credits_button__png, true, 140, 50);
		creditsScreen = new FlxSprite(0, 0).loadGraphic(AssetPaths.credits__png);
		creditsBack = new FlxButton(25, 825, "", closeCredits);
		creditsBack.loadGraphic(AssetPaths.ARROW_BACK__png, true, 76, 50);
		add(creditsButton);
		add(creditsScreen);
		add(creditsBack);
		creditsScreen.kill();
		creditsBack.kill();

		// Black fade
		fadeToBlack = new FlxSprite(0, 0);
		fadeToBlack.loadGraphic(AssetPaths.fadetoblack__png);
		add(fadeToBlack);
		fadeToBlack.alpha = 0;

		// scanlines
		scanlines = new FlxSprite(0, 0).loadGraphic(AssetPaths.scanTest2__png);
		add(scanlines);
	}

	override public function update(elapsed:Float):Void
	{
		buttonCheck();
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
			if (!Meta.isMusicMuted)
			{
				MenuTheme.volume = 1 - (timeoutTimer / 100);
			}
			if (timeoutTimer >= 100)
			{
				FlxG.switchState(new ControlsState());
			}
		}
	}

	function clickStart()
	{
		pushButton();
		isGameStart = true;
	}

	function openOptions()
	{
		pushButton();
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
		pushButton();
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
		pushButton();
		if (Meta.isMusicMuted)
		{
			Meta.isMusicMuted = false;
			MenuTheme.volume = 1;
			musicButton.loadGraphic(AssetPaths.uncheckedMusic__png);
		}
		else
		{
			Meta.isMusicMuted = true;
			MenuTheme.volume = 0;
			musicButton.loadGraphic(AssetPaths.checkedMusic__png);
		}
	}

	function muteSFX()
	{
		pushButton();
		if (Meta.isSFXMuted)
		{
			Meta.isSFXMuted = false;
			sfxButton.loadGraphic(AssetPaths.uncheckedSFX__png);
		}
		else
		{
			Meta.isSFXMuted = true;
			sfxButton.loadGraphic(AssetPaths.checkedSFX__png);
		}
	}

	function backCommand()
	{
		pushButton();
		startButton.revive();
		optionButton.revive();
		optionsScreen.kill();
		fullscreenButton.kill();
		musicButton.kill();
		sfxButton.kill();
		backButton.kill();
	}

	function buttonCheck()
	{
		if (Meta.isSFXMuted)
		{
			sfxButton.loadGraphic(AssetPaths.checkedSFX__png);
			buttonSound.volume = 0;
			introVoice.volume = 0;
		}
		else
		{
			sfxButton.loadGraphic(AssetPaths.uncheckedSFX__png);
			buttonSound.volume = 1;
			introVoice.volume = .8;
		}
		if (Meta.isMusicMuted)
		{
			musicButton.loadGraphic(AssetPaths.checkedMusic__png);
		}
		else
		{
			musicButton.loadGraphic(AssetPaths.uncheckedMusic__png);
		}
	}

	function openCredits()
	{
		pushButton();
		creditsScreen.revive();
		startButton.kill();
		optionButton.kill();
		creditsBack.revive();
		creditsButton.kill();
	}

	function closeCredits()
	{
		pushButton();
		creditsScreen.kill();
		startButton.revive();
		optionButton.revive();
		creditsButton.revive();
		creditsBack.kill();
	}

	function pushButton()
	{
		buttonSound.stop();
		buttonSound.play();
	}
}
