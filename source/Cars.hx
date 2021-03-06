package;

import flixel.FlxSprite;

class Cars extends FlxSprite
{
	// Yes, every single car shall be stored in this singular array
	static public var vehicles:Array<String> = ["truck1", "car1", "playerModel", "blueprius", "beetle"];

	var chooseVehicle:Int;

	// Define the car's size and look
	public function new(x:Float = 0, y:Float = 0)
	{
		// Choose random vehicle
		chooseVehicle = Std.random(vehicles.length);

		// Make the vehicle
		super(x, y);
		loadGraphic("assets/images/" + vehicles[chooseVehicle] + ".png");
	}

	// What changes with the car every frame
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		driveCar();
	}

	// Move the car up
	function driveCar()
	{
		velocity.set(0, -800);
	}
}
