package utils;

function randomRange(min:Float, max:Float):Float
{
	return Math.floor(Math.random() * (1 + max - min)) + min;
}
