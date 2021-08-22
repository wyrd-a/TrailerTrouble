package env;

// Internal imports
import env.EnvItem;
import utils.Math;
// External imports
import flixel.FlxG;
import haxe.Exception;
import flixel.FlxSprite;

class RoadSign implements env.EnvItem extends flixel.FlxSprite
{
	public var name:String = "RoadSign";

	// Environment item behavior
	public var alwaysLeft:Bool;
	public var alwaysRight:Bool;
	public var alwaysCentered:Bool;

	public var fixedX:Int;
	public var spawnChance:Float;

	public var eitherSide:Bool;

	// Sign specific vars
	public var envItemType:String;

	public static var signTypes:Array<String> = [
		"89Sign",
		"95Sign",
		"overheadTripleSign",
		"rightOverheadSign",
		"simpleSign",
		"speedLimitSign",
	];

	public function new(?envItemType:String, ?exclusivity:Array<String>)
	{
		var availableTypes:Array<String>;
		if (exclusivity != null)
		{
			availableTypes = signTypes.filter((exclusiveEnvItemType:String) ->
			{
				return !exclusivity.contains(exclusiveEnvItemType);
			});
		}
		else
		{
			availableTypes = signTypes;
		}

		if (envItemType == null)
		{
			this.envItemType = availableTypes[utils.Math.randRange(0, availableTypes.length - 1)];
			initEnvItem(this.envItemType);
		}
		else if (!signTypes.contains(envItemType))
		{
			throw new Exception("Sign type provided to road sign class: " + envItemType + ", is invalid");
		}
		else
		{
			this.envItemType = envItemType;
			initEnvItem(this.envItemType);
		}

		super(0, 0);
		loadGraphic("assets/images/roadSigns/" + this.envItemType + ".png");
	}

	private function initEnvItem(?envItemType:String)
	{
		if (envItemType == null || !signTypes.contains(envItemType))
		{
			throw new Exception("RoadSign requires type when initializing");
		}

		this.initPosition(envItemType);
		this.initSpawnChance(envItemType);
	}

	private function initPosition(envItemType:String)
	{
		if (envItemType == "89Sign" || envItemType == "95Sign")
		{
			this.alwaysRight = true;
		}
		else if (envItemType == "overheadTripleSign")
		{
			this.alwaysCentered = true;
			this.fixedX = 125;
		}
		else if (envItemType == "rightOverheadSign")
		{
			this.alwaysRight = true;
			this.fixedX = 465;
		}
		else if (envItemType == "simpleSign" || envItemType == "testSign" || envItemType == "speedLimitSign")
		{
			this.eitherSide = true;
		}
	}

	private function initSpawnChance(envItemType:String)
	{
		if (envItemType == "89Sign" || envItemType == "95Sign")
		{
			this.spawnChance = 0.1;
		}
		else if (envItemType == "simpleSign")
		{
			this.spawnChance = 0.25;
		}
		else if (envItemType == "overHeadTripleSign" || envItemType == "rightOverheadSign")
		{
			this.spawnChance = 0.05;
		}
		else
		{
			this.spawnChance = 0.1;
		}
	}
}
