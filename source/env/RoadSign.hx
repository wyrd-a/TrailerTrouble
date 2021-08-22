package env;

// Internal imports
import haxe.Exception;
import env.EnvItem;
// External imports
import flixel.FlxSprite;

class RoadSign implements env.EnvItem extends flixel.FlxSprite
{
	// Environment item behavior
	public var alwaysCentered:Bool;
	public var alwaysLeft:Bool;
	public var alwaysRight:Bool;
	public var fixedX:Int;
	public var eitherSide:Bool;
	public var flippedOnLeft:Bool;
	public var flippedOnRight:Bool;

	// Sign specific vars
	public var signType:String;

	private var allSigns:Array<String>;
	private var eitherSideSigns = ["roadSign1"];
	private var centerSigns = ["roadSign2", "roadSign8"];
	private var rightSideSigns = ["roadSign4", "roadSign5", "roadSign6", "roadSign7"];

	public function new(signType:String)
	{
		// Initialize all signs
		this.allSigns = this.eitherSideSigns.concat(this.centerSigns.concat(this.rightSideSigns));

		super();
	}

	private function initEnvItem(?envItemType:String)
	{
		// No left check yet because there are no left only signs

		if (envItemType == null)
		{
			throw new Exception("RoadSign requires type when initializing");
		}
	}
}
