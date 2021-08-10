package env;

// Internal imports
import env.Tree;
import env.Sign;
import utils.Math;
// External imports
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;

typedef EnvItem =
{
	var spawnChance:Float;
	var splittable:Bool;
	var maxCount:Int;
	var items:Array<flixel.FlxSprite>;
}

class Environment
{
	// Stuff related to image sizes
	private var medianWidth:Int = 125;

	private var backdrop:FlxBackdrop;
	private var add:FlxBasic->FlxBasic;
	private var remove:(FlxBasic, ?Bool) -> FlxBasic;
	private var envItems = new Map<String, EnvItem>();

	public function new(add:FlxBasic->FlxBasic, remove:(FlxBasic, ?Bool) -> FlxBasic)
	{
		this.add = add;
		this.remove = remove;

		// Create background
		this.backdrop = new FlxBackdrop(AssetPaths.road__png, 1, 1, false, true);
		this.add(backdrop);

		// envItems.set("trees", {maxCount: 10, splittable: true, items: []});
		this.envItems.set("signs", {
			maxCount: 10,
			spawnChance: 0.1,
			splittable: true,
			items: []
		});
		// envItems.set("tracks", {maxCount: 1, splittable: false, items: []});

		// Initialize environmental adds
		for (v in this.envItems.keys())
		{
			var initialItemsCount = Math.floor(utils.Math.randomRange(0, this.envItems[v].maxCount));

			for (_ in 0...initialItemsCount)
			{
				if (this.envItems[v].splittable)
				{
					var bounds = makeBounds();

					// Randomly generate position for item, don't add until free space is found
					var newItem = makeItem(v, bounds.leftBound, bounds.rightBound, bounds.topBound, bounds.bottomBound);
					while (conflicts(newItem))
					{
						newItem = makeItem(v, bounds.leftBound, bounds.rightBound, bounds.topBound, bounds.bottomBound);
					}

					this.envItems[v].items.push(newItem);
				}
			}
		}

		// Once items are added, send them to screen
		for (v in this.envItems.keys())
		{
			for (item in this.envItems[v].items)
			{
				trace("New item!", item);
				this.add(item);
			}
		}
	}

	function makeBounds(?playerY:Float)
	{
		var leftOrRight = Math.floor(utils.Math.randomRange(0, 1));
		var leftBound:Float;
		var rightBound:Float;
		var topBound:Float;
		var bottomBound:Float;

		if (leftOrRight == 0)
		{
			leftBound = 0;
			rightBound = this.medianWidth;
		}
		else
		{
			leftBound = this.backdrop.width - this.medianWidth;
			rightBound = this.backdrop.width;
		}

		if (playerY == null)
		{
			topBound = 0;
			bottomBound = this.backdrop.height;
		}
		else
		{
			topBound = playerY - (this.backdrop.height / 2);
			bottomBound = playerY + (this.backdrop.height / 2);
		}

		return {
			leftBound: leftBound,
			rightBound: rightBound,
			topBound: topBound,
			bottomBound: bottomBound
		};
	}

	public function makeItem(variant:String, leftBound:Float, rightBound:Float, topBound:Float, bottomBound:Float)
	{
		var xStart = Math.floor(utils.Math.randomRange(leftBound, rightBound));
		var yStart = Math.floor(utils.Math.randomRange(topBound, bottomBound));

		var newItem = new env.Sign(xStart, yStart);

		return newItem;
	}

	public function conflicts(newItem:flixel.FlxSprite)
	{
		var conflicts = false;

		if (!newItem.isOnScreen())
		{
			return false;
		}

		for (v in this.envItems.keys())
		{
			var existingItems = this.envItems[v].items;

			for (existingItem in existingItems)
			{
				if (newItem.overlaps(existingItem))
				{
					conflicts = true;
					break;
				}
			}
		}

		return conflicts;
	}

	public function updateEnv(playerY:Float)
	{
		// Strip items that are not on the screen
		for (v in this.envItems.keys())
		{
			for (item in this.envItems[v].items)
			{
				if (!item.isOnScreen())
				{
					this.remove(item);
					this.envItems[v].items.remove(item);
				}
			}
		}

		trace("PlayerY:", playerY);

		// Potentially add new items
		for (v in this.envItems.keys())
		{
			var envItem = this.envItems[v];

			if (envItem.items.length < envItem.maxCount)
			{
				if (Math.random() < envItem.spawnChance)
				{
					if (envItem.splittable)
					{
						var bounds = makeBounds(playerY);
						trace("new bounds:", bounds);
						var newItem = makeItem(v, bounds.leftBound, bounds.rightBound, bounds.topBound, bounds.bottomBound);

						while (conflicts(newItem))
						{
							newItem = makeItem(v, bounds.leftBound, bounds.rightBound, bounds.topBound, bounds.bottomBound);
						}

						this.envItems[v].items.push(newItem);

						trace("Adding new item!", newItem);
						trace("background stats", backdrop.frameHeight);
						this.add(newItem);
					}
				}
			}
		}
	}
}
