package substates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using StringTools;

/**
 * Class based from Psych Engine.
 * Credits: Shadow Mario.
 */
class BaseOptionsSubState extends MusicBeatSubstate
{
	private var discordClientTitle:String = 'In the Menus';
	private var curSelected:Int = 0;
	private var curOption:Option = null;
	private var options:Array<Option>;
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var grpTexts:FlxTypedGroup<Alphabet>;
	private var description:FlxText;

	public function new()
	{
		super();

		#if FUTURE_DISCORD_RCP
		DiscordClient.changePresence(discordClientTitle, null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFea71fd;
		bg.screenCenter();
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		grpTexts = new FlxTypedGroup<Alphabet>();
		add(grpTexts);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 70 * i, options[i].name, false, false);
			optionText.isMenuItem = true;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if (options[i].type == 'bool')
			{
				var valueText:AttachedAlphabet = new AttachedAlphabet(options[i].getValue() == true ? 'On' : 'Off', optionText.width + 50, 50, true);
				valueText.sprTracker = optionText;
				valueText.ID = i;
				options[i].setChild(valueText);
				grpTexts.add(valueText);
			}
			else
			{
				var valueText:AttachedAlphabet = new AttachedAlphabet(options[i].getValue(), optionText.width + 50, 50, true);
				valueText.sprTracker = optionText;
				valueText.ID = i;
				options[i].setChild(valueText);
				grpTexts.add(valueText);
			}

			updateTextFrom(options[i], options[i].type == 'bool');
		}

		description = new FlxText(0, FlxG.height * 0.1, FlxG.width * 0.9, '', 28);
		description.setFormat(Paths.font("vcr.ttf"), 28, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		description.screenCenter(X);
		description.scrollFactor.set();
		description.borderSize = 3;
		add(description);

		changeSelection();

		#if android
		addVirtualPad(LEFT_FULL, A_B_C);
		addPadCamera(false);
		#end
	}

	var holdTime:Float = 0;
	var holdValue:Float = 0;

	override function update(elapsed:Float)
	{
		if (controls.UI_UP_P)
			changeSelection(-1);
		else if (controls.UI_DOWN_P)
			changeSelection(1);
		else if (FlxG.mouse.wheel != 0)
			changeSelection(-FlxG.mouse.wheel);

		if (controls.BACK)
		{
			PreferencesData.write();
			flixel.addons.transition.FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		if (curOption.type == 'bool')
		{
			if (controls.ACCEPT)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				curOption.setValue((curOption.getValue() == true) ? false : true);
				curOption.change();
				updateTextFrom(curOption, true);
			}
		}
		else
		{
			if (controls.UI_LEFT || controls.UI_RIGHT)
			{
				var justPressed:Bool = (controls.UI_LEFT_P || controls.UI_RIGHT_P);
				if (holdTime > 0.5 || justPressed)
				{
					if (justPressed)
					{
						var add:Dynamic = null;
						if (curOption.type != 'string')
							add = controls.UI_LEFT ? -curOption.changeValue : curOption.changeValue;

						switch (curOption.type)
						{
							case 'int' | 'float' | 'percent':
								holdValue = curOption.getValue() + add;

								if (holdValue < curOption.minValue)
									holdValue = curOption.minValue;
								else if (holdValue > curOption.maxValue)
									holdValue = curOption.maxValue;

								switch (curOption.type)
								{
									case 'int':
										holdValue = Math.round(holdValue);
										curOption.setValue(holdValue);
									case 'float' | 'percent':
										holdValue = FlxMath.roundDecimal(holdValue, curOption.decimals);
										curOption.setValue(holdValue);
								}

							case 'string':
								var num:Int = curOption.curOption;
								if (controls.UI_LEFT_P)
									--num;
								else
									num++;

								if (num < 0)
									num = curOption.options.length - 1;
								else if (num >= curOption.options.length)
									num = 0;

								curOption.curOption = num;
								curOption.setValue(curOption.options[num]);
						}

						updateTextFrom(curOption, false);
						curOption.change();
						FlxG.sound.play(Paths.sound('scrollMenu'));
					}
					else if (curOption.type != 'string')
					{
						holdValue += curOption.scrollSpeed * elapsed * (controls.UI_LEFT ? -1 : 1);

						if (holdValue < curOption.minValue)
							holdValue = curOption.minValue;
						else if (holdValue > curOption.maxValue)
							holdValue = curOption.maxValue;

						switch (curOption.type)
						{
							case 'int':
								curOption.setValue(Math.round(holdValue));
							case 'float' | 'percent':
								curOption.setValue(FlxMath.roundDecimal(holdValue, curOption.decimals));
						}

						updateTextFrom(curOption, false);
						curOption.change();
					}
				}

				if (curOption.type != 'string')
					holdTime += elapsed;
			}
			else if (controls.UI_LEFT_R || controls.UI_RIGHT_R)
				clearHold();
		}

		if (controls.RESET #if android || virtualPad.buttonC.justPressed #end)
		{
			for (i in 0...options.length)
			{
				var leOption:Option = options[i];
				leOption.setValue(leOption.defaultValue);
				if (leOption.type != 'bool')
				{
					if (leOption.type == 'string')
						leOption.curOption = leOption.options.indexOf(leOption.getValue());
					updateTextFrom(leOption, false);
				}
				leOption.change();
			}

			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		super.update(elapsed);
	}

	private function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));

		curSelected += change;

		if (curSelected < 0)
			curSelected = options.length - 1;
		else if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;
		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			item.xAdd = 0;
			if (item.targetY == 0)
			{
				item.alpha = 1;
				item.xAdd = 110;
			}
		}

		for (text in grpTexts.members)
		{
			text.alpha = 0.6;
			if (text.ID == curSelected)
				text.alpha = 1;
		}

		curOption = options[curSelected];

		if (curOption.description != null)
		{
			description.text = curOption.description;
			description.screenCenter(X);
		}
	}

	private function addOption(daOption:Option)
	{
		if (options == null || options.length < 1)
			options = [];

		options.push(daOption);
	}

	private function updateTextFrom(option:Option, isBool:Bool = false)
	{
		if (isBool)
			option.text = option.getValue() == true ? 'On' : 'Off';
		else
		{
			var text:String = option.displayFormat;
			var val:Dynamic = option.getValue();

			if (option.type == 'percent')
				val *= 100;

			var def:Dynamic = option.defaultValue;
			option.text = text.replace('%v', val).replace('%d', option.defaultValue);
		}
	}

	private function clearHold()
	{
		if (holdTime > 0.5)
			FlxG.sound.play(Paths.sound('scrollMenu'));
		holdTime = 0;
	}
}
