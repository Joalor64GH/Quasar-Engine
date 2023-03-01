package states;

import core.ModCore;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.Lib;
import openfl.utils.Assets;

import states.*;

class TitleState extends MusicBeatState
{
	private static var initialized:Bool = false;

	private var blackScreen:FlxSprite;
	private var credGroup:FlxGroup;
	private var textGroup:FlxGroup;
	private var ngSpr:FlxSprite;
	private var curWacky:Array<String> = [];
	private var gameName:Array<String> = [];
	private var wackyImage:FlxSprite;

	override public function create():Void
	{
		FlxG.keys.preventDefaultKeys = [TAB];

		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		ModCore.reload();

		PlayerSettings.init();
		PreferencesData.load();
		HighScore.load();

		if (PreferencesData.checkForUpdates && !OutdatedState.leftState)
			OutdatedState.checkForUpdates();

		curWacky = FlxG.random.getObject(getIntroTextShit());
		gameName = getName();

		#if FUTURE_DISCORD_RCP
		DiscordClient.initialize();

		Lib.application.onExit.add(function(exitCode:Int)
		{
			DiscordClient.shutdown();
		});
		#end

		if(!initialized)
		{
			if(FlxG.save.data != null && FlxG.save.data.fullscreen)
				FlxG.fullscreen = FlxG.save.data.fullscreen;

			if (FlxG.save.data.weekCompleted != null)
					StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;

			persistentUpdate = true;
			persistentDraw = true;
		}

		super.create();

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			if (initialized)
				startIntro();
			else
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					startIntro();
				});
			}
		});
	}

	private var logoBl:FlxSprite;
	private var gfDance:FlxSprite;
	private var danceLeft:Bool = false;
	private var titleText:FlxSprite;

	private function startIntro()
	{
		if (!initialized)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			FlxG.sound.music.fadeIn(4, 0, 0.7);
			Conductor.changeBPM(102);
		}

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		logoBl = new FlxSprite(-150, -100);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = PreferencesData.antialiasing;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();

		gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = PreferencesData.antialiasing;
		add(gfDance);
		add(logoBl);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = PreferencesData.antialiasing;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		add(titleText);

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = PreferencesData.antialiasing;

		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else
			initialized = true;
	}

	private function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
			swagGoodArray.push(i.split('--'));

		return swagGoodArray;
	}

	private function getName():Array<String>
	{
		var fullText:String = Assets.getText(Paths.txt('gameName'));

		var firstArray:Array<String> = fullText.split('--');
		return firstArray;
	}

	private var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		var pressedEnter:Bool = controls.ACCEPT;

		if (pressedEnter && !transitioning && skippedIntro)
		{
			if (PreferencesData.flashing)
			{
				titleText.animation.play('press');
				titleText.centerOrigin();
			}

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				if (OutdatedState.mustUpdate && !OutdatedState.leftState)
					MusicBeatState.switchState(new OutdatedState());
				else
					MusicBeatState.switchState(new MainMenuState());
			});
		}

		if (pressedEnter && !skippedIntro && initialized)
			skipIntro();

		super.update(elapsed);
	}

	private function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	private function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	private function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	var lastBeat:Int = 0;
	
	override function beatHit()
	{
		super.beatHit();

		logoBl.animation.play('bump');
		danceLeft = !danceLeft;

		if (danceLeft)
			gfDance.animation.play('danceRight');
		else
			gfDance.animation.play('danceLeft');

		if (curBeat > lastBeat)
		{
			for (i in lastBeat...curBeat)
			{
				switch (i + 1)
				{
					case 1:
						var teamStuff = Assets.getText(Paths.txt('team')).split('--');
						createCoolText(teamStuff);
					case 3:
						addMoreText('present');
					case 4:
						deleteCoolText();
					case 5:
						createCoolText(['In association', 'with']);
					case 7:
						addMoreText('newgrounds');
						ngSpr.visible = true;
					case 8:
						deleteCoolText();
						ngSpr.visible = false;
					case 9:
						createCoolText([curWacky[0]]);
					case 11:
						addMoreText(curWacky[1]);
					case 12:
						deleteCoolText();
					case 13:
						addMoreText(gameName[0]);
					case 14:
						addMoreText(gameName[1]);
					case 15:
						addMoreText(gameName[2]);
					case 16:
						skipIntro();
				}
			}
		}
		
		lastBeat = curBeat;
	}

	private var skippedIntro:Bool = false;

	private function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			skippedIntro = true;
		}
	}
}
