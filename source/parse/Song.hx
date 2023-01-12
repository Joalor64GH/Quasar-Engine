package parse;

import openfl.utils.Assets;
import haxe.Json;

using StringTools;

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var bpm:Float;
	var needsVoices:Bool;
	var speed:Float;
	var player1:String;
	var player2:String;
	var gfVersion:String;
	var stage:String;
	var validScore:Bool;
}

typedef SwagSection =
{
	var sectionNotes:Array<Dynamic>;
	var lengthInSteps:Int;
	var typeOfSection:Int;
	var mustHitSection:Bool;
	var bpm:Float;
	var changeBPM:Bool;
	var altAnim:Bool;
}

class Song
{
	public static function loadJson(jsonInput:String, ?folder:String):SwagSong
		return parseJson(Paths.json('songs/' + folder.toLowerCase() + '/' + jsonInput.toLowerCase()).trim());

	public static function parseJson(path:String):SwagSong
	{
		var rawJson:String = null;

		if (Assets.exists(path))
			rawJson = Assets.getText(path);

		var swagShit:SwagSong = Json.parse(rawJson).song;
		swagShit.validScore = true;
		return swagShit;
	}
}
