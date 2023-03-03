package;

import flixel.FlxG;
import flixel.math.FlxMath;
import openfl.utils.Assets;

using StringTools;

class CoolUtil
{
	public static var difficultyArray:Array<Dynamic> = [
		['Easy', '-easy'], 
		['Normal', ''], 
		['Hard', '-hard']
	];

	public static inline function difficultyString(curDifficulty:Int):String
		return difficultyArray[curDifficulty][0];

	inline public static function coolTextFile(path:String):Array<String>{
		return (Assets.exists(path)) ? [for (i in Assets.getText(path).trim().split('\n')) i.trim()] : [];
	}

	public static inline function coolerTextFile(path:String, daString:String = ''):String{
		return Assets.exists(path) ? daString = Assets.getText(path).trim() : '';
	}

	public inline static function numberArray(max:Int, ?min = 0):Array<Int>
		return [for (i in min...max) i];

	public static inline function camLerpShit(ratio:Float):Float
		return FlxG.elapsed / (1 / 60) * ratio;

	public static inline function coolLerp(a:Float, b:Float, ratio:Float):Float
		return a + camLerpShit(ratio) * (b - a);
	
	public static function boundTo(value:Float, min:Float, max:Float):Float
	{
		var newValue:Float = value;

		if (newValue < min)
			newValue = min;
		else if (newValue > max)
			newValue = max;

		return newValue;
	}

	public static function getInterval(size:Float):String
	{
		var data:Int = 0;

		final intervalArray:Array<String> = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
		while (size > 1024 && data < intervalArray.length - 1)
		{
			data++;
			size = size / 1024;
		}

		size = Math.round(size * 100) / 100;
		return size + ' ' + intervalArray[data];
	}

	public static inline function truncateFloat(number:Float, precision:Int):Float
		return FlxMath.roundDecimal(number, precision);
}