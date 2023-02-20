package substates;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import Controls;

using StringTools;

class ControlsSubState extends MusicBeatSubstate
{
	private static var curSelected:Int = 1;
	private static var curAlt:Bool = false;

	private static var defaultKey:String = 'Reset to Default Keys';

	private var bindLength:Int = 0;

	private final optionShit:Array<Dynamic> = [
		['NOTES'], ['Left', 'note_left'], ['Down', 'note_down'], ['Up', 'note_up'], ['Right', 'note_right'], [''], ['UI'], ['Left', 'ui_left'],
		['Down', 'ui_down'], ['Up', 'ui_up'], ['Right', 'ui_right'], [''], ['Reset', 'reset'], ['Accept', 'accept'], ['Back', 'back'], ['Pause', 'pause'],
		[''], ['VOLUME'], ['Mute', 'volume_mute'], ['Up', 'volume_up'], ['Down', 'volume_down']];

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var grpInputs:Array<AttachedAlphabet> = [];
	private var grpInputsAlt:Array<AttachedAlphabet> = [];
	private var rebindingKey:Bool = false;
	private var nextAccept:Int = 5;

	public function new()
	{
		super();

		#if FUTURE_DISCORD_RCP
		DiscordClient.changePresence("Controls Menu", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFea71fd;
		bg.screenCenter();
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		optionShit.push(['']);
		optionShit.push([defaultKey]);

		for (i in 0...optionShit.length)
		{
			var isCentered:Bool = false;
			if (unselectableCheck(i, true))
				isCentered = true;

			var optionText:Alphabet = new Alphabet(0, (10 * i), optionShit[i][0], (!isCentered || (optionShit[i] == defaultKey)), false);
			optionText.isMenuItem = true;
			if (isCentered)
			{
				optionText.screenCenter(X);
				optionText.forceX = optionText.x;
				optionText.yAdd = -55;
			}
			else
			{
				optionText.forceX = 200;
			}
			optionText.yMult = 60;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if (!isCentered)
				addBindTexts(optionText, i);
		}

		changeSelection();
	}

	private var leaving:Bool = false;
	private var bindingTime:Float = 0;

	override function update(elapsed:Float)
	{
		if (!rebindingKey)
		{
			if (controls.UI_UP_P)
				changeSelection(-1);
			else if (controls.UI_DOWN_P)
				changeSelection(1);
			else if (FlxG.mouse.wheel != 0)
				changeSelection(-FlxG.mouse.wheel);

			if (controls.UI_LEFT_P || controls.UI_RIGHT_P)
				changeAlt();

			if (controls.BACK)
			{
				PreferencesData.reloadControls();
				PreferencesData.write();

				flixel.addons.transition.FlxTransitionableState.skipNextTransOut = true;
				FlxG.resetState();

				FlxG.sound.play(Paths.sound('cancelMenu'));
			}
			else if (controls.ACCEPT && nextAccept <= 0)
			{
				if (optionShit[curSelected][0] == defaultKey)
				{
					PreferencesData.keyBinds = PreferencesData.defaultKeys.copy();
					reloadKeys();
					changeSelection();
					FlxG.sound.play(Paths.sound('confirmMenu'));
				}
				else if (!unselectableCheck(curSelected))
				{
					bindingTime = 0;
					rebindingKey = true;
					if (curAlt)
						grpInputsAlt[getInputTextNum()].alpha = 0;
					else
						grpInputs[getInputTextNum()].alpha = 0;
					FlxG.sound.play(Paths.sound('scrollMenu'));
				}
			}
		}
		else
		{
			var keyPressed:Int = FlxG.keys.firstJustPressed();
			if (keyPressed > -1)
			{
				var keysArray:Array<FlxKey> = PreferencesData.keyBinds.get(optionShit[curSelected][1]);
				keysArray[curAlt ? 1 : 0] = keyPressed;

				var opposite:Int = (curAlt ? 0 : 1);
				if (keysArray[opposite] == keysArray[1 - opposite])
					keysArray[opposite] = NONE;
				PreferencesData.keyBinds.set(optionShit[curSelected][1], keysArray);

				reloadKeys();
				FlxG.sound.play(Paths.sound('confirmMenu'));
				rebindingKey = false;
			}

			bindingTime += elapsed;
			if (bindingTime > 5)
			{
				if (curAlt)
					grpInputsAlt[curSelected].alpha = 1;
				else
					grpInputs[curSelected].alpha = 1;

				FlxG.sound.play(Paths.sound('scrollMenu'));
				rebindingKey = false;
				bindingTime = 0;
			}
		}

		if (nextAccept > 0)
			nextAccept -= 1;

		super.update(elapsed);
	}

	private function getInputTextNum()
	{
		var num:Int = 0;
		for (i in 0...curSelected)
			if (optionShit[i].length > 1)
				num++;

		return num;
	}

	private function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));

		do
		{
			curSelected += change;
			if (curSelected < 0)
				curSelected = optionShit.length - 1;
			else if (curSelected >= optionShit.length)
				curSelected = 0;
		}
		while (unselectableCheck(curSelected));

		for (i in 0...grpInputs.length)
			grpInputs[i].alpha = 0.6;

		for (i in 0...grpInputsAlt.length)
			grpInputsAlt[i].alpha = 0.6;

		var bullShit:Int = 0;
		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if (!unselectableCheck(bullShit - 1))
			{
				item.alpha = 0.6;
				if (item.targetY == 0)
				{
					item.alpha = 1;
					if (curAlt)
					{
						for (i in 0...grpInputsAlt.length)
						{
							if (grpInputsAlt[i].sprTracker == item)
							{
								grpInputsAlt[i].alpha = 1;
								break;
							}
						}
					}
					else
					{
						for (i in 0...grpInputs.length)
						{
							if (grpInputs[i].sprTracker == item)
							{
								grpInputs[i].alpha = 1;
								break;
							}
						}
					}
				}
			}
		}
	}

	private function changeAlt()
	{
		curAlt = !curAlt;
		for (i in 0...grpInputs.length)
		{
			if (grpInputs[i].sprTracker == grpOptions.members[curSelected])
			{
				grpInputs[i].alpha = 0.6;
				if (!curAlt)
					grpInputs[i].alpha = 1;
				break;
			}
		}

		for (i in 0...grpInputsAlt.length)
		{
			if (grpInputsAlt[i].sprTracker == grpOptions.members[curSelected])
			{
				grpInputsAlt[i].alpha = 0.6;
				if (curAlt)
					grpInputsAlt[i].alpha = 1;
				break;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	private function unselectableCheck(num:Int, ?checkDefaultKey:Bool = false):Bool
	{
		if (optionShit[num][0] == defaultKey)
			return checkDefaultKey;

		return optionShit[num].length < 2 && optionShit[num][0] != defaultKey;
	}

	private function addBindTexts(optionText:Alphabet, num:Int)
	{
		var keys:Array<Dynamic> = PreferencesData.keyBinds.get(optionShit[num][1]);

		var text1 = new AttachedAlphabet(getKeyName(keys[0]), 400, -55);
		text1.setPosition(optionText.x + 400, optionText.y - 55);
		text1.sprTracker = optionText;
		grpInputs.push(text1);
		add(text1);

		var text2 = new AttachedAlphabet(getKeyName(keys[1]), 650, -55);
		text2.setPosition(optionText.x + 650, optionText.y - 55);
		text2.sprTracker = optionText;
		grpInputsAlt.push(text2);
		add(text2);
	}

	private function reloadKeys()
	{
		while (grpInputs.length > 0)
		{
			var item:AttachedAlphabet = grpInputs[0];
			item.kill();
			grpInputs.remove(item);
			item.destroy();
		}

		while (grpInputsAlt.length > 0)
		{
			var item:AttachedAlphabet = grpInputsAlt[0];
			item.kill();
			grpInputsAlt.remove(item);
			item.destroy();
		}

		for (i in 0...grpOptions.length)
			if (!unselectableCheck(i, true))
				addBindTexts(grpOptions.members[i], i);

		var bullShit:Int = 0;
		for (i in 0...grpInputs.length)
			grpInputs[i].alpha = 0.6;

		for (i in 0...grpInputsAlt.length)
			grpInputsAlt[i].alpha = 0.6;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if (!unselectableCheck(bullShit - 1))
			{
				item.alpha = 0.6;
				if (item.targetY == 0)
				{
					item.alpha = 1;
					if (curAlt)
					{
						for (i in 0...grpInputsAlt.length)
							if (grpInputsAlt[i].sprTracker == item)
								grpInputsAlt[i].alpha = 1;
					}
					else
					{
						for (i in 0...grpInputs.length)
							if (grpInputs[i].sprTracker == item)
								grpInputs[i].alpha = 1;
					}
				}
			}
		}
	}

	private function getKeyName(key:FlxKey):String
	{
		switch (key)
		{
			case BACKSPACE:
				return "BckSpc";
			case CONTROL:
				return "Ctrl";
			case ALT:
				return "Alt";
			case CAPSLOCK:
				return "Caps";
			case PAGEUP:
				return "PgUp";
			case PAGEDOWN:
				return "PgDown";
			case ZERO:
				return "0";
			case ONE:
				return "1";
			case TWO:
				return "2";
			case THREE:
				return "3";
			case FOUR:
				return "4";
			case FIVE:
				return "5";
			case SIX:
				return "6";
			case SEVEN:
				return "7";
			case EIGHT:
				return "8";
			case NINE:
				return "9";
			case NUMPADZERO:
				return "#0";
			case NUMPADONE:
				return "#1";
			case NUMPADTWO:
				return "#2";
			case NUMPADTHREE:
				return "#3";
			case NUMPADFOUR:
				return "#4";
			case NUMPADFIVE:
				return "#5";
			case NUMPADSIX:
				return "#6";
			case NUMPADSEVEN:
				return "#7";
			case NUMPADEIGHT:
				return "#8";
			case NUMPADNINE:
				return "#9";
			case NUMPADMULTIPLY:
				return "#*";
			case NUMPADPLUS:
				return "#+";
			case NUMPADMINUS:
				return "#-";
			case NUMPADPERIOD:
				return "#.";
			case SEMICOLON:
				return ";";
			case COMMA:
				return ",";
			case PERIOD:
				return ".";
			case GRAVEACCENT:
				return "`";
			case LBRACKET:
				return "[";
			case RBRACKET:
				return "]";
			case QUOTE:
				return "'";
			case PRINTSCREEN:
				return "PrtScrn";
			case NONE:
				return '---';
			default:
				var label:String = '' + key;
				if (label.toLowerCase() == 'null')
					return '---';
				return Std.string(label.charAt(0).toUpperCase() + label.substr(1).toLowerCase());
		}
	}
}
