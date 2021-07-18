package utils;

function calcAccel(up:Bool, down:Bool, left:Bool, right:Bool, velocity:Float, angVelocity:Float, jerk:Float, angJerk:Float, cD:Float, angcD:Float)
{
	// cD represents combined area, air density

	var upDownConflict = !(up != down);
	var leftRightConflict = !(left != right);
	var accel:Float = 0;
	var angularAccel:Float = 0;
	if (!upDownConflict)
	{
		if (up)
		{
			accel += jerk;
		}
		else
		{
			accel -= jerk;
		}
	}
	if (!leftRightConflict)
	{
		if (right)
		{
			angularAccel += angJerk;
		}
		else
		{
			angularAccel -= angJerk;
		}
	}

	accel -= cD * velocity ^ 2;
	angularAccel -= angcD * angVelocity ^ 2;
}
