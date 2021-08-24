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

	public static var rightMountedSigns = [
		"2fort",
		"archbtw",
		"centralia",
		"forks",
		"luckyville",
		"upstream",
		"warnerbradford",
		"whereami"
	];

	public static var eitherMountedSigns = [
		"89Sign",
		"95Sign",
		"speedLimitSign",
		"clickandflick",
		"upstream2",
		"gofaster",
		"lookatyourscreen",
		"bikespipes",
		"hiii"
	];

	public static var centerMountedSigns = ["chocolate", "tictactoe", "howsitgoing", "lanelabels", "magnets"];

	public var signTypes:Array<String>;

	public function new(?envItemType:String)
	{
		this.signTypes = [].concat(rightMountedSigns).concat(eitherMountedSigns).concat(centerMountedSigns);

		if (envItemType == null)
		{
			this.envItemType = signTypes[utils.Math.randRange(0, signTypes.length - 1)];
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
		else if (centerMountedSigns.contains(envItemType))
		{
			this.alwaysCentered = true;
			this.fixedX = 125;
		}
		else if (rightMountedSigns.contains(envItemType))
		{
			this.alwaysRight = true;
			this.fixedX = 465;
		}
		else if (eitherMountedSigns.contains(envItemType))
		{
			this.eitherSide = true;
		}
	}

	private function initSpawnChance(envItemType:String)
	{
		// Global spawn chance
		this.spawnChance = 0.1;
	}
}
