package env;

// Internal imports
import env.EnvItem;
import utils.Math;
// External imports
import flixel.FlxG;
import haxe.Exception;
import flixel.FlxSprite;

class CrossRoad implements env.EnvItem extends flixel.FlxSprite
{
	public var name:String = "CrossRoad";
	// Environment item behavior
	public var alwaysLeft:Bool;
	public var alwaysRight:Bool;
	public var alwaysCentered:Bool;

	public var fixedX:Int;
	public var spawnChance:Float;

	public var eitherSide:Bool;

	// Sign specific vars
	public var envItemType:String;

	public static var roadTypes:Array<String> = ["leftMedian", "overBridge"];

	public function new(?envItemType:String, ?exclusivity:Array<String>)
	{
		var availableTypes:Array<String>;
		if (exclusivity != null)
		{
			availableTypes = roadTypes.filter((exclusiveEnvItemType:String) ->
			{
				return !exclusivity.contains(exclusiveEnvItemType);
			});
		}
		else
		{
			availableTypes = roadTypes;
		}

		if (envItemType == null)
		{
			this.envItemType = availableTypes[utils.Math.randRange(0, availableTypes.length - 1)];
			initEnvItem(this.envItemType);
		}
		else if (!roadTypes.contains(envItemType))
		{
			throw new Exception("Sign type provided to road sign class: " + envItemType + ", is invalid");
		}
		else
		{
			this.envItemType = envItemType;
			initEnvItem(this.envItemType);
		}

		super(0, 0);
		loadGraphic("assets/images/crossRoads/" + this.envItemType + ".png");
	}

	private function initEnvItem(?envItemType:String)
	{
		if (envItemType == null || !roadTypes.contains(envItemType))
		{
			throw new Exception("Cross road requires type when initializing");
		}

		this.initPosition(envItemType);
		this.initSpawnChance(envItemType);
	}

	private function initPosition(envItemType:String)
	{
		if (envItemType == "leftMedian")
		{
			this.alwaysLeft = true;
			this.fixedX = 0;
		}
		else if (envItemType == "overBridge")
		{
			this.alwaysCentered = true;
			this.fixedX = 0;
		}
	}

	private function initSpawnChance(envItemType:String)
	{
		if (envItemType == "leftMedian" || envItemType == "overBridge")
		{
			this.spawnChance = 0.05;
		}
	}
}
