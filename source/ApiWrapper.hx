package;

import io.newgrounds.crypto.Rc4;
import flixel.FlxG;
import flixel.util.FlxSignal;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
// import io.newgrounds.crypto.Rc4;
import io.newgrounds.components.ScoreBoardComponent.Period;
import io.newgrounds.objects.Medal;
import io.newgrounds.objects.Score;
import io.newgrounds.objects.ScoreBoard;
import io.newgrounds.objects.events.Response;
import io.newgrounds.objects.events.Result.GetCurrentVersionResult;
import io.newgrounds.objects.events.Result.GetVersionResult;
import lime.app.Application;
import openfl.display.Stage;
import ApiKeys;

using StringTools;

/**
 * MADE BY GEOKURELI THE LEGENED GOD HERO MVP
 */
class ApiWrapper
{
	public static var isLoggedIn:Bool = false;
	public static var scoreboardsLoaded:Bool = false;

	public static var scoreboardArray:Array<Score> = [];

	public static var ngDataLoaded(default, null):FlxSignal = new FlxSignal();
	public static var ngScoresLoaded(default, null):FlxSignal = new FlxSignal();

	public static var GAME_VER:String = "";
	public static var GAME_VER_NUMS:String = '';
	public static var gotOnlineVer:Bool = false;

	public static function noLogin(api:String)
	{
		trace('INIT NOLOGIN');
		GAME_VER = "v" + Application.current.meta.get('version');

		if (api.length != 0)
		{
			NG.create(api);

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				var call = NG.core.calls.app.getCurrentVersion(GAME_VER).addDataHandler(function(response:Response<GetCurrentVersionResult>)
				{
					GAME_VER = response.result.data.currentVersion;
					GAME_VER_NUMS = GAME_VER.split(" ")[0].trim();
					trace('CURRENT NG VERSION: ' + GAME_VER);
					trace('CURRENT NG VERSION: ' + GAME_VER_NUMS);
					gotOnlineVer = true;
				});

				call.send();
			});
		}
	}

	public function new()
	{
		trace("Attempting to connect to newgrounds");

		NG.createAndCheckSession(ApiKeys.ApiId);
		NG.core.verbose = true;
		NG.core.initEncryption(ApiKeys.ApiKey);

		trace(NG.core.attemptingLogin);

		if (NG.core.attemptingLogin)
		{
			trace("attempting login");
			NG.core.onLogin.add(onNGLogin);
		}
		else
		{
			NG.core.requestLogin(onNGLogin);
		}
	}

	function onNGLogin():Void
	{
		trace('Logged in! User:${NG.core.user.name}');
		isLoggedIn = true;
		FlxG.save.data.sessionId = NG.core.sessionId;

		NG.core.requestMedals(onNGMedalFetch);
		NG.core.requestScoreBoards(onNGBoardsFetch);

		ngDataLoaded.dispatch();
	}

	function onNGMedalFetch():Void
	{
		trace("Reading medals...");
		for (id in NG.core.medals.keys())
		{
			var medal = NG.core.medals.get(id);
			trace('loaded medal id:$id, name:${medal.name}, description:${medal.description}');
		}
		NG.core.medals.get(ApiKeys.winnerID);
		NG.core.medals.get(ApiKeys.fasterID);
	}

	function onNGBoardsFetch():Void
	{
		trace("Reading scoreboards...");

		for (id in NG.core.scoreBoards.keys())
		{
			var board = NG.core.scoreBoards.get(id);
			trace('loaded scoreboard id:$id, name:${board.name}');
		}
		// var board = NG.core.scoreBoards.get(8004); // ID found in NG project view
		// board.onUpdate.add(onNGScoresFetch);
	}

	inline static public function postScore(score:Int = 0, song:String)
	{
		trace("Posting score");

		if (isLoggedIn)
		{
			for (id in NG.core.scoreBoards.keys())
			{
				var board = NG.core.scoreBoards.get(id);

				if (song == board.name)
				{
					trace("Posted score:", score);
					trace("Attempting to post score to " + song);
					board.postScore(score, "Fastest Completion");
				}
			}
		}
	}

	// function onNGScoresFetch():Void
	// {
	// 	scoreboardsLoaded = true;
	// 	ngScoresLoaded.dispatch();
	// 	/*
	// 		for (score in NG.core.scoreBoards.get(8737).scores)
	// 		{
	// 			trace('score loaded user:${score.user.name}, score:${score.formatted_value}');
	// 		}
	// 	 */
	// 	// var board = NG.core.scoreBoards.get(8004);// ID found in NG project view
	// 	// board.postScore(HighScore.score);
	// 	// NGio.scoreboardArray = NG.core.scoreBoards.get(8004).scores;
	// }

	inline static public function logEvent(event:String)
	{
		NG.core.calls.event.logEvent(event).send();
		trace('should have logged: ' + event);
	}

	inline static public function unlockMedal(id:Int)
	{
		trace("Unlocking medal...");
		if (isLoggedIn)
		{
			var medal = NG.core.medals.get(id);
			medal.sendUnlock();
		}
	}
}
