package states;

import Controls.KeyboardScheme;
import core.ModCore;
import core.ToastCore;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;

import states.*;

class MainMenuState extends MusicBeatState
{
	public static var nightly:String = #if nightly '-nightly' #else '' #end;
	public static var gameVer:String = '0.2.7.1';

	private final optionShit:Array<String> = [
		'story mode',
		'freeplay',
		#if FUTURE_POLYMOD
		'mods',
		#end
		'credits',
		'options'
	];
	private var menuItems:FlxTypedGroup<FlxSprite>;
	private var curSelected:Int = 0;
	private var camFollow:FlxObject;
	private var magenta:FlxSprite;

	public static var firstStart:Bool = true;
	public static var finishedFunnyMove:Bool = false;

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		#if FUTURE_DISCORD_RCP
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing #if FUTURE_POLYMOD || ModsMenuState.mustResetMusic #end)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			#if FUTURE_POLYMOD
			ModsMenuState.mustResetMusic = false;
			#end
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBG'));
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.10;
		bg.screenCenter();
		bg.antialiasing = PreferencesData.antialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.10;
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = PreferencesData.antialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140) + (108 - (Math.max(optionShit.length, 4) - 4) * 80));
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/' + optionShit[i] + '/spritesheet');
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.screenCenter(X);
			menuItem.scrollFactor.set(0, 1);
			menuItem.antialiasing = PreferencesData.antialiasing;
			menuItem.ID = i;
			menuItems.add(menuItem);
			if (firstStart)
				FlxTween.tween(menuItem,{y: 60 + (i * 160)},1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
					{
						finishedFunnyMove = true; 
						changeItem();
					}
				});
			else
				menuItem.y = 60 + (i * 160);
		}

		FlxG.camera.follow(camFollow, null, 0.60);

		var versionShit:FlxText = new FlxText(5, FlxG.height
			- 23, 0,
			"Friday Night Funkin': "
			+ gameVer
			+ "\n"
			+ 'ChainSaw Engine: '
			+ Application.current.meta.get('version')
			+ nightly, 12);
		versionShit.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionShit.scrollFactor.set();
		add(versionShit);

		changeItem();

		super.create();
	}

	private var selectedSomething:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume += 0.5 * elapsed;

		if (!selectedSomething)
		{
			if (controls.UI_UP_P)
				changeItem(-1);
			else if (controls.UI_DOWN_P)
				changeItem(1);
			else if (FlxG.mouse.wheel != 0)
				changeItem(-FlxG.mouse.wheel);

			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}
			else if (controls.ACCEPT)
			{
				selectedSomething = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				if (PreferencesData.flashing)
					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						FlxTween.tween(spr, {alpha: 0}, 1.3, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
					else
					{
						if (PreferencesData.flashing)
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								goToState();
							});
						}
						else
						{
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								goToState();
							});
						}
					}
				});
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	private function goToState()
	{
		final daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story mode':
				MusicBeatState.switchState(new StoryMenuState());
			case 'freeplay':
				MusicBeatState.switchState(new FreeplayState());
			#if FUTURE_POLYMOD
			case 'mods':
				if (ModCore.trackedMods != [])
					MusicBeatState.switchState(new ModsMenuState());
				else
					Main.toast.create('No Mods Installed!', 0xFFFFFF00, 'Please add mods to be able to access the menu!');
			#end
			case 'credits':
				MusicBeatState.switchState(new CreditsState());
			case 'options':
				MusicBeatState.switchState(new OptionsState());
		}
	}

	private function changeItem(huh:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));

		curSelected += huh;
		if (curSelected >= menuItems.length)
			curSelected = 0;
		else if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				spr.centerOffsets();
				spr.centerOrigin();
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}
		});
	}
}
