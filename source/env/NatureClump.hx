package env;

// Internal imports
import env.EnvItem;
import utils.Math;
// External imports
import flixel.FlxG;
import haxe.Exception;
import flixel.FlxSprite;

class NatureClump implements env.EnvItem extends flixel.FlxSprite
{
	public var name:String = "NatureClump";
	// Environment item behavior
	public var alwaysLeft:Bool;
	public var alwaysRight:Bool;
	public var alwaysCentered:Bool;

	public var fixedX:Int;
	public var spawnChance:Float;

	public var eitherSide:Bool;
	public var flippedOnLeft:Bool;
	public var flippedOnRight:Bool;

	// Sign specific vars
	public var envItemType:String;

	public static var trackTypes:Array<String> = [
		"smallBushLeft",
		"mediumBushLeft",
		"largeBushLeft",
		"smallBushRight",
		"mediumBushRight",
		"largeBushRight",
		"largeRiverRight",
		"largeRiverLeft",
	];

	public function new(?envItemType:String, ?exclusivity:Array<String>)
	{
		var availableTypes:Array<String>;
		if (exclusivity != null)
		{
			availableTypes = trackTypes.filter((exclusiveEnvItemType:String) ->
			{
				return !exclusivity.contains(exclusiveEnvItemType);
			});
		}
		else
		{
			availableTypes = trackTypes;
		}

		if (envItemType == null)
		{
			this.envItemType = availableTypes[utils.Math.randRange(0, availableTypes.length - 1)];
			initEnvItem(this.envItemType);
		}
		else if (!trackTypes.contains(envItemType))
		{
			throw new Exception("Nature clump type provided to nature clump class: " + envItemType + ", is invalid");
		}
		else
		{
			this.envItemType = envItemType;
			initEnvItem(this.envItemType);
		}

		super(0, 0);
		loadGraphic("assets/images/nature/" + this.envItemType + ".png");
	}

	private function initEnvItem(?envItemType:String)
	{
		if (envItemType == null || !trackTypes.contains(envItemType))
		{
			throw new Exception("Nature clump requires type when initializing");
		}

		this.initPosition(envItemType);
		this.initSpawnChance(envItemType);
	}

	private function initPosition(envItemType:String)
	{
		if (envItemType.indexOf("Left") > 0)
		{
			this.alwaysLeft = true;
			this.fixedX = 0;
		}
		else if (envItemType.indexOf("Right") > 0 && envItemType.indexOf("Bush") > 0)
		{
			this.alwaysRight = true;
			this.fixedX = FlxG.width - 82;
		}
		else if (envItemType.indexOf("Right") > 0 && envItemType.indexOf("River") > 0)
		{
			this.alwaysRight = true;
			this.fixedX = FlxG.width - 150;
		}
	}

	private function initSpawnChance(envItemType:String)
	{
		if (envItemType.indexOf("small") >= 0)
		{
			this.spawnChance = 0.75;
		}
		else if (envItemType.indexOf("medium") >= 0)
		{
			this.spawnChance = 0.65;
		}
		else if (envItemType.indexOf("large") >= 0)
		{
			this.spawnChance = 0.55;
		}
	}
}
