package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.Http;
import haxe.Json;
import openfl.Lib;

import states.*;

class OutdatedState extends MusicBeatState
{
	public static var leftState:Bool = false;
	public static var mustUpdate:Bool = false;
	public static var daJson:Dynamic;

	override function create()
	{
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Hello!\n"
			+ "You're running an outdated version of the engine!\n"
			+ "The current version is "
			+ Lib.application.meta.get('version')
			+ " while the most recent version is "
			+ daJson.version
			+ "!\n"
			+ "What's new:\n"
			+ daJson.description
			+ "\n"
			+ "Press ENTER to go to the GitHub page, or ESC to ignore this!",
			32);
		txt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);

		super.create();
	}

	public static function checkForUpdates()
	{
		var http:Http = new Http('https://raw.githubusercontent.com/Joalor64GH/Quasar-Engine/develop/version.json');
		http.onData = function(data:String)
		{
			var daRawJson:Dynamic = Json.parse(data);
			if (daRawJson.version != Lib.application.meta.get('version'))
			{
				daJson = daRawJson;
				mustUpdate = true;
			}
			else
				mustUpdate = false;
		}
		http.onError = function(msg:String)
		{
			trace('Updates Check Error: $msg');
		}
		http.request();
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
			FlxG.openURL("https://github.com/Joalor64GH/ChainSaw-Engine-Personalized");
		else if (controls.BACK)
		{
			leftState = true;
			MusicBeatState.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}
}
