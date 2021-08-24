package;

import flixel.FlxG;
import io.newgrounds.NG;
import flixel.FlxSprite;

class Meta extends FlxSprite
{
	public static var playerTime:Float;
	public static var playerDist:Float;
	public static var isMusicMuted:Bool;
	public static var isSFXMuted:Bool;
	public static var isOutOfControl:Bool;

	public static var newgroundsAPI:NG;

	public function new()
	{
		super();
	}
}
