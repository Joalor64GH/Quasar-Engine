package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.utils.Assets;

import parse.*;
import states.*;

typedef SongMetaData =
{
	var name:String;
	var week:Int;
	var character:String;
	var color:Int;
}

class FreeplayState extends MusicBeatState
{
	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	private var iconArray:Array<HealthIcon> = [];
	private var songs:Array<SongMetaData> = [];
	private var curSelected:Int = 0;
	private var curDifficulty:Int = 1;
	private var scoreText:FlxText;
	private var diffText:FlxText;
	private var rankText:FlxText;

	private var lerpScore:Float = 0;
	private var lerpAccuracy:Float = 0;

	private var intendedScore:Float = 0;
	private var intendedAccuracy:Float = 0;

	private var bg:FlxSprite;
	private var scoreBG:FlxSprite;

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		Week.loadJsons(false);

		for (i in 0...Week.weeksList.length)
		{
			if (!weekIsLocked(Week.weeksList[i]))
			{
				for (song in Week.currentLoadedWeeks.get(Week.weeksList[i]).songs)
				{
					var colors:Array<Int> = song.colors;
					if (colors == null || colors.length < 3)
						colors = [146, 113, 253];

					songs.push({
						name: song.name,
						week: i,
						character: song.character,
						color: FlxColor.fromRGB(colors[0], colors[1], colors[2])
					});
				}
			}
		}

		#if FUTURE_DISCORD_RCP
		// Updating Discord Rich Presence
		DiscordClient.changePresence('In the Freeplay Menu', null);
		#end

		if (!FlxG.sound.music.playing)
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.7);

		persistentUpdate = true;

		bg = new FlxSprite(0, 0).loadGraphic(Paths.image('menuDesat'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].name, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			if (songText.width > 980)
			{
				var textScale:Float = 980 / songText.width;
				songText.scale.x = textScale;
				for (letter in songText.lettersArray)
				{
					letter.x *= textScale;
					letter.offset.x *= textScale;
				}
			}

			var icon:HealthIcon = new HealthIcon(songs[i].character);
			icon.sprTracker = songText;
			iconArray.push(icon);
			add(icon);
		}

		scoreBG = new FlxSprite(FlxG.width * 6.7, 0).makeGraphic(1, 101, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		scoreText = new FlxText(FlxG.width * 0.7, scoreBG.y + 5, 0, '', 32);
		scoreText.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE, RIGHT);
		add(scoreText);

		rankText = new FlxText(scoreText.x, scoreText.y + 36, 0, '', 24);
		rankText.setFormat(Paths.font('vcr.ttf'), 24, FlxColor.WHITE, RIGHT);
		add(rankText);

		diffText = new FlxText(scoreText.x, rankText.y + 28, 0, '', 24);
		diffText.setFormat(Paths.font('vcr.ttf'), 24, FlxColor.WHITE, RIGHT);
		add(diffText);

		changeSelection();
		changeDiff();

		super.create();
	}

	private function weekIsLocked(name:String):Bool
	{
		var daWeek:SwagWeek = Week.currentLoadedWeeks.get(name);
		return (daWeek.locked
			&& daWeek.unlockAfter.length > 0
			&& (!StoryMenuState.weekCompleted.exists(daWeek.unlockAfter) || !StoryMenuState.weekCompleted.get(daWeek.unlockAfter)));
	}

	override function update(elapsed:Float)
	{
		lerpScore = CoolUtil.coolLerp(lerpScore, intendedScore, 0.4);

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		lerpAccuracy = CoolUtil.coolLerp(lerpAccuracy, intendedAccuracy, 0.4);

		if (Math.abs(lerpAccuracy - intendedAccuracy) <= 0.01)
			lerpAccuracy = intendedAccuracy;

		bg.color = FlxColor.interpolate(bg.color, songs[curSelected].color, CoolUtil.camLerpShit(0.045));

		scoreText.text = 'PERSONAL BEST: ' + Math.round(lerpScore);
		rankText.text = 'ACCURACY: ' + Std.string(lerpAccuracy).substr(0, 5) + '% - ' + HighScore.getScore(songs[curSelected].name, curDifficulty).grade;

		positionHighScore();

		if (controls.UI_UP_P)
		{
			changeSelection(-1);
			changeDiff();
		}
		else if (controls.UI_DOWN_P)
		{
			changeSelection(1);
			changeDiff();
		}
		else if (FlxG.mouse.wheel != 0)
		{
			changeSelection(-FlxG.mouse.wheel);
			changeDiff();
		}

		if (controls.UI_LEFT_P)
			changeDiff(-1);
		else if (controls.UI_RIGHT_P)
			changeDiff(1);

		if (controls.ACCEPT)
		{
			PlayState.SONG = Song.loadJson(HighScore.formatSong(songs[curSelected].name, curDifficulty), Paths.formatName(songs[curSelected].name));
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;
			PlayState.storyWeek = songs[curSelected].week;

			if (FlxG.keys.pressed.SHIFT)
				MusicBeatState.switchState(new ChartingState());
			else
				MusicBeatState.switchState(new PlayState());
		}
		else if (controls.BACK)
			MusicBeatState.switchState(new MainMenuState());

		super.update(elapsed);
	}

	private function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficultyArray.length - 1;
		else if (curDifficulty >= CoolUtil.difficultyArray.length)
			curDifficulty = 0;

		intendedScore = HighScore.getScore(songs[curSelected].name, curDifficulty).score;
		intendedAccuracy = HighScore.getScore(songs[curSelected].name, curDifficulty).accuracy;

		diffText.text = 'DIFFICULTY: ' + CoolUtil.difficultyString(curDifficulty).toUpperCase();
	}

	private function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		else if (curSelected >= songs.length)
			curSelected = 0;

		intendedScore = HighScore.getScore(songs[curSelected].name, curDifficulty).score;
		intendedAccuracy = HighScore.getScore(songs[curSelected].name, curDifficulty).accuracy;

		for (i in 0...iconArray.length)
			iconArray[i].alpha = 0.6;

		iconArray[curSelected].alpha = 1;

		var bullShit:Int = 0;
		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0)
				item.alpha = 1;
		}
	}

	private function positionHighScore()
	{
		scoreText.x = rankText.x = diffText.x = FlxG.width - scoreText.width - 6;
		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - scoreBG.scale.x / 2;
	}
}
