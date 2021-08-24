package env;

// Internal imports
import haxe.Exception;
import utils.Math;
import env.RoadSign;
import env.CrossRoad;
import env.CrossTrack;
import env.NatureClump;
// External imports
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class Environment
{
	// Manages environment assets, mutual exclusivity between them, etc.
	public var add:FlxBasic->FlxBasic;
	public var remove:(FlxBasic, ?Bool) -> FlxBasic;

	// Some attributes determining median size
	public var MEDIAN_WIDTH = 125;

	// Spawn chance variables
	public var envItemTypes = ["RoadSign", "CrossTrack", "CrossRoad", "NatureClump"];
	// public var envItemTypes = ["RoadSign",];
	public var SPAWN_ATTEMPTS = 3;
	public var GLOBAL_SPAWN_CHANCE = 0.25;

	// Environment attributes
	public var MAX_ROADSIGNS = 10;
	public var roadSigns = new FlxTypedGroup<env.RoadSign>(10);

	public var MAX_CROSSTRACKS = 1;
	public var crossTracks = new FlxTypedGroup<env.CrossTrack>(1);

	public var MAX_CROSSROADS = 1;
	public var crossRoads = new FlxTypedGroup<env.CrossRoad>(1);

	public var MAX_NATURECLUMPS = 3;
	public var natureClumps = new FlxTypedGroup<env.NatureClump>(3);

	public function new(add:FlxBasic->FlxBasic, remove:(FlxBasic, ?Bool) -> FlxBasic)
	{
		this.add = add;
		this.remove = remove;

		// Added road
		this.add(this.roadSigns);
		this.add(this.crossTracks);
		this.add(this.crossRoads);
		this.add(this.natureClumps);
	}

	public function update(playerY:Float)
	{
		this.removeOffscreen(playerY);
		this.makeNewEnvItem(Math.round(playerY));
	}

	private function removeOffscreen(playerY:Float)
	{
		// Haxe is deeply annoying about this, does not allow iteration over dynamic arrays
		// Big pain in the ass, lazy fix is to repeat same logic outside of loop

		for (envItem in this.roadSigns)
		{
			// If item is offscreen AND behind player, remove it
			if (!envItem.isOnScreen() && envItem.y > playerY + FlxG.height)
			{
				envItem.kill();
				this.roadSigns.remove(envItem, true);
			}
		}

		for (envItem in this.crossTracks)
		{
			// If item is offscreen AND behind player, remove it
			if (!envItem.isOnScreen() && envItem.y > playerY + FlxG.height)
			{
				envItem.kill();
				this.crossTracks.remove(envItem, true);
			}
		}

		for (envItem in this.crossRoads)
		{
			// If item is offscreen AND behind player, remove it
			if (!envItem.isOnScreen() && envItem.y > playerY + FlxG.height)
			{
				envItem.kill();
				this.crossRoads.remove(envItem, true);
			}
		}

		for (envItem in this.natureClumps)
		{
			// If item is offscreen AND behind player, remove it
			if (!envItem.isOnScreen() && envItem.y > playerY + FlxG.height)
			{
				envItem.kill();
				this.natureClumps.remove(envItem, true);
			}
		}
	}

	// Selects a random type of environment item and initializes it
	private function makeNewEnvItem(playerY:Int)
	{
		var newItem:env.EnvItem;

		// Global spawn chance
		if (Math.random() < this.GLOBAL_SPAWN_CHANCE)
		{
			var newEnvItemType = this.envItemTypes[utils.Math.randRange(0, envItemTypes.length)];

			if (newEnvItemType == "RoadSign" && this.roadSigns.length < this.MAX_ROADSIGNS)
			{
				newItem = new env.RoadSign();
				addNewEnvItem(playerY, newItem);
			}
			else if (newEnvItemType == "CrossTrack" && this.crossTracks.length < this.MAX_CROSSTRACKS && this.crossRoads.length == 0)
			{
				newItem = new env.CrossTrack();
				addNewEnvItem(playerY, newItem);
			}
			else if (newEnvItemType == "CrossRoad" && this.crossRoads.length < this.MAX_CROSSROADS && this.crossTracks.length == 0)
			{
				newItem = new env.CrossRoad();
				addNewEnvItem(playerY, newItem);
			}
			else if (newEnvItemType == "NatureClump" && this.natureClumps.length < this.MAX_NATURECLUMPS)
			{
				newItem = new env.NatureClump();
				addNewEnvItem(playerY, newItem);
			}
			else
			{
				// Do nothing
			}
		}
	}

	private function addNewEnvItem(playerY:Int, newItem:env.EnvItem)
	{
		// Item specific spawn chance
		if (Math.random() < newItem.spawnChance)
		{
			var newPos = calculateNewPosition(newItem, playerY);
			var newSprite = cast(newItem, FlxSprite);
			newSprite.setPosition(newPos.xPos, newPos.yPos);

			var spawnAttempts = 0;

			while (this.checkConflicts(newSprite) && spawnAttempts < 3)
			{
				var newPos = calculateNewPosition(newItem, playerY);
				newSprite.setPosition(newPos.xPos, newPos.yPos);
				spawnAttempts += 1;
			}

			if (spawnAttempts >= 3)
			{
				trace("Failed to spawn new item" + newItem.name + " due to overlaps; giving up on spawning it for now");
			}
			else
			{
				// When item is added, consider mutual exclusivities

				if (newItem.name == "RoadSign")
				{
					this.roadSigns.add(cast(newSprite, env.RoadSign));
				}
				else if (newItem.name == "CrossTrack")
				{
					this.crossTracks.add(cast(newSprite, env.CrossTrack));
				}
				else if (newItem.name == "CrossRoad")
				{
					this.crossRoads.add(cast(newSprite, env.CrossRoad));
				}
				else if (newItem.name == "NatureClump")
				{
					this.natureClumps.add(cast(newSprite, env.NatureClump));
				}
				else
				{
					trace("Unknown item:", newItem.name);
				}
			}
		}
	}

	// Calculates a start position for a new item based on existing environment items
	// and texture-specific attributes
	private function calculateNewPosition(envItem:env.EnvItem, playerY:Int)
	{
		// Check where item can be spawned
		var xPos:Int;
		var yPos:Int;

		if (envItem.alwaysCentered != null && envItem.alwaysCentered)
		{
			if (envItem.fixedX == null)
			{
				throw new Exception("Center aligned textures are required to have a fixed X position, since basing position on FlxG width is inconsistent");
			}
			else
			{
				xPos = envItem.fixedX;
			}
		}
		else if (envItem.alwaysLeft != null && envItem.alwaysLeft)
		{
			if (envItem.fixedX != null)
			{
				xPos = envItem.fixedX;
			}
			else
			{
				xPos = this.calculateNewXPosition(cast(envItem, FlxSprite), 0);
			}
		}
		else if (envItem.alwaysRight != null && envItem.alwaysRight)
		{
			if (envItem.fixedX != null)
			{
				xPos = envItem.fixedX;
			}
			else
			{
				xPos = this.calculateNewXPosition(cast(envItem, FlxSprite), 1);
			}
		}
		else if (envItem.eitherSide != null && envItem.eitherSide)
		{
			// If item is spawned on either width non-fixed X, spawn within range;
			if (envItem.fixedX != null)
			{
				xPos = envItem.fixedX;
			}
			else
			{
				xPos = this.calculateNewXPosition(cast(envItem, FlxSprite));
			}
		}
		else
		{
			xPos = 0;
		}

		// y pos pretty much always the same
		yPos = calculateNewYPosition(playerY);

		return {
			xPos: xPos,
			yPos: yPos
		}
	}

	// Calculate some median position within a range
	private function calculateNewXPosition(envItem:FlxSprite, ?sideOverride:Int)
	{
		// Choose left (0) / right (1)
		var leftRight:Int;
		if (sideOverride == null)
		{
			leftRight = utils.Math.randRange(0, 1);
		}
		else
		{
			leftRight = sideOverride;
		}

		// Create base X spawn range to be within median
		var xStartRange:Int;
		var xEndRange:Int;

		if (leftRight == 0)
		{
			xStartRange = 0;
			xEndRange = this.MEDIAN_WIDTH;
		}
		else
		{
			xStartRange = FlxG.width - this.MEDIAN_WIDTH;
			xEndRange = FlxG.width;
		}
		// Then check texture size to make sure it does not spawn off screen
		xEndRange = xEndRange - envItem.frameWidth;
		// Select new X position
		var xPos:Int;

		if (xEndRange <= xStartRange)
		{
			throw new Exception("Error: texture won't fit in median");
		}
		else
		{
			xPos = utils.Math.randRange(xStartRange, xEndRange);
		}
		return xPos;
	}

	// Calculate some y position within a range of player
	private function calculateNewYPosition(playerY:Int)
	{
		// Position for new item is within some screen distance ahead of the player

		var yStartRange = Math.round(playerY - (FlxG.height * 3));
		var yEndRange = Math.round(playerY - (FlxG.height * 5));

		return utils.Math.randRange(yStartRange, yEndRange);
	}

	// Checks to see if new item conflicts with existing environment item
	private function checkConflicts(newEnvItem:FlxSprite)
	{
		var conflicts = false;

		// Again with not being able to iterate over dynamic....

		for (envItem in this.roadSigns)
		{
			if (newEnvItem.overlaps(envItem))
			{
				conflicts = true;
				break;
			}
		}

		if (!conflicts)
		{
			for (envItem in this.crossRoads)
			{
				if (newEnvItem.overlaps(envItem))
				{
					conflicts = true;
					break;
				}
			}
		}

		if (!conflicts)
		{
			for (envItem in this.crossTracks)
			{
				if (newEnvItem.overlaps(envItem))
				{
					conflicts = true;
					break;
				}
			}
		}

		if (!conflicts)
		{
			for (envItem in this.natureClumps)
			{
				if (newEnvItem.overlaps(envItem))
				{
					conflicts = true;
					break;
				}
			}
		}

		return conflicts;
	}
}
