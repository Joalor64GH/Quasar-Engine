package;

import flixel.FlxG;
import haxe.Json;

typedef SwagInfo =
{
	var score:Int;
	var accuracy:Float;
	var grade:String;
}

class HighScore
{
	public static var songScores:Map<String, SwagInfo> = [];
	public static var weekScores:Map<String, SwagInfo> = [];

	public static function saveScore(song:String, diff:Int = 0, info:SwagInfo):Void
	{
		var daSong:String = formatSong(song, diff);
		if (songScores.exists(daSong))
		{
			if (songScores.get(daSong).score < info.score)
				setScore(daSong, info);
		}
		else
			setScore(daSong, info);
	}

	public static function saveWeekScore(week:String, diff:Int = 0, info:SwagInfo):Void
	{
		var daWeek:String = formatSong(week, diff);
		if (weekScores.exists(daWeek))
		{
			if (weekScores.get(daWeek).score < info.score)
				setWeekScore(daWeek, info);
		}
		else
			setWeekScore(daWeek, info);
	}

	public static function formatSong(song:String, diff:Int):String
		return Paths.formatName(song) + CoolUtil.difficultyArray[diff][1];

	public static function getScore(song:String, diff:Int):SwagInfo
	{
		if (!songScores.exists(formatSong(song, diff)))
		{
			setScore(formatSong(song, diff), {
				score: 0,
				accuracy: 0,
				grade: Rank.unknownGrade
			});
		}

		return songScores.get(formatSong(song, diff));
	}

	static function setScore(song:String, info:SwagInfo):Void
	{
		songScores.set(song, info);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}

	public static function getWeekScore(week:String, diff:Int):SwagInfo
	{
		if (!weekScores.exists(formatSong(week, diff)))
		{
			setWeekScore(formatSong(week, diff), {
				score: 0,
				accuracy: 0,
				grade: Rank.unknownGrade
			});
		}

		return weekScores.get(formatSong(week, diff));
	}

	static function setWeekScore(week:String, info:SwagInfo):Void
	{
		weekScores.set(week, info);
		FlxG.save.data.weekScores = weekScores;
		FlxG.save.flush();
	}

	public static function load():Void
	{
		if (FlxG.save.data.songScores != null)
			songScores = FlxG.save.data.songScores;

		if (FlxG.save.data.weekScores != null)
			weekScores = FlxG.save.data.weekScores;
	}
}
