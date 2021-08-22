package env;

// External imports
import flixel.FlxSprite;

interface EnvItem
{
	public var name:String;
	public var alwaysCentered:Bool;
	public var alwaysLeft:Bool;
	public var alwaysRight:Bool;
	public var fixedX:Int;
	public var eitherSide:Bool;
	public var flippedOnLeft:Bool;
	public var flippedOnRight:Bool;
	public var spawnChance:Float;
	public var envItemType:String;
	private function initEnvItem(?envItemType:String):Void;
}
