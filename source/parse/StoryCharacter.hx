package parse;

import haxe.Json;
import openfl.utils.Assets;

typedef SwagStoryCharacter =
{
	var animations:Array<SwagStoryAnimation>;
	var danceAnimation:Array<String>;
	var scale:Float;
	var antialiasing:Bool;
	var flipX:Bool;
	var flipY:Bool;
}

typedef SwagStoryAnimation =
{
	var animation:String;
	var prefix:String;
	var framerate:Int;
	var looped:Bool;
	var indices:Array<Int>;
	var flipX:Bool;
	var flipY:Bool;
	var offset:Array<Float>;
}

class StoryCharacter
{
	public static function loadJson(file:String):SwagStoryCharacter
		return parseJson(Paths.json('images/menucharacters/' + file));

	public static function parseJson(path:String):SwagStoryCharacter
	{
		var rawJson:String = '';

		if (Assets.exists(path))
			rawJson = Assets.getText(path);

		return Json.parse(rawJson);
	}
}
