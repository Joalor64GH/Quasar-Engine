package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

import states.*;
import substates.*;

class OptionsState extends MusicBeatState
{
	public static var fromPause:Bool = false;

	final options:Array<String> = ['Preferences', 'Controls', 'Exit'];

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var curSelected:Int = 0;

	override function create()
	{
		#if FUTURE_DISCORD_RCP
		DiscordClient.changePresence("Options Menu", null);
		#end

		if (!FlxG.sound.music.playing)
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.7);

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFea71fd;
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true, false);
			optionText.screenCenter();
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			optionText.ID = i;
			grpOptions.add(optionText);
		}

		changeSelection();

		super.create();
	}

	private var selectedSomething:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!selectedSomething)
		{
			if (controls.UI_UP_P || controls.UI_DOWN_P)
				changeSelection(controls.UI_UP_P ? -1 : 1);
			else if (FlxG.mouse.wheel != 0)
				changeSelection(-FlxG.mouse.wheel);

			if (controls.ACCEPT)
			{
				selectedSomething = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));
				grpOptions.forEach(function(spr:FlxSprite)
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
	}

	private function goToState()
	{
		switch (options[curSelected])
		{
			case 'Preferences':
				openSubState(new PreferencesSubState());
			case 'Controls':
				openSubState(new ControlsSubState());
			case 'Exit':
				if (fromPause)
				{
					fromPause = false;
					MusicBeatState.switchState(new PlayState());
				}
				else
					MusicBeatState.switchState(new MainMenuState());
		}
	}

	private function changeSelection(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, options.length - 1);

		for (num => item in grpOptions.members)
		{
			item.targetY = num - curSelected;
			item.alpha = (item.targetY == 0) ? 1 : 0.6;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}