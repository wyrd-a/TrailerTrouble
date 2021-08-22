package env;

// Internal imports
import env.EnvItem;
import utils.Math;
// External imports
import flixel.FlxG;
import haxe.Exception;
import flixel.FlxSprite;

class CrossTrack implements env.EnvItem extends flixel.FlxSprite
{
	public var name:String = "CrossTrack";
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

	public static var trackTypes:Array<String> = ["tunnelTracks",];

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
			throw new Exception("Sign type provided to road sign class: " + envItemType + ", is invalid");
		}
		else
		{
			this.envItemType = envItemType;
			initEnvItem(this.envItemType);
		}

		super(0, 0);
		loadGraphic("assets/images/crossTracks/" + this.envItemType + ".png");
	}

	private function initEnvItem(?envItemType:String)
	{
		if (envItemType == null || !trackTypes.contains(envItemType))
		{
			throw new Exception("CrossTrack requires type when initializing");
		}

		this.initPosition(envItemType);
		this.initSpawnChance(envItemType);
	}

	private function initPosition(envItemType:String)
	{
		if (envItemType == "tunnelTracks")
		{
			this.alwaysCentered = true;
			this.fixedX = 0;
		}
	}

	private function initSpawnChance(envItemType:String)
	{
		if (envItemType == "tunnelTracks")
		{
			this.spawnChance = 0.05;
		}
	}
}
