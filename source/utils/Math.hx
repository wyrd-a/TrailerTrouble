package utils;

function randRange(min:Int, max:Int):Int
{
	return Math.floor(Math.random() * (1 + max - min)) + min;
}
