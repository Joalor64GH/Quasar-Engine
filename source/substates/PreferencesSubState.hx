package substates;

import flixel.FlxG;
import openfl.Lib;

class PreferencesSubState extends BaseOptionsSubState
{
	public function new()
	{
		discordClientTitle = 'Preferences Menu';

		addOption(new Option('Ghost Tapping', 'If disabled, hitting when theres no note to press will give a miss.', 'ghostTapping', 'bool', true));
		addOption(new Option('Downscroll', 'If enabled, moves the scroll downwards.', 'downScroll', 'bool', false));
		addOption(new Option('Centered Note-Field', 'if enabled, moves the scroll to the middle.', 'centeredNotes', 'bool', false));
		addOption(new Option('Note Splashes', 'If disabled, no splashes will appear on sick note presses.', 'noteSplashes', 'bool', true));

		var option:Option = new Option('Overlay', 'If enabled, shows an overlay with fps and memory info.', 'overlay', 'bool', false);
		option.onChange = function()
		{
			if (Main.overlay != null)
				Main.overlay.visible = PreferencesData.overlay;
		}
		addOption(option);

		#if !html5
		var option:Option = new Option('Framerate', "The framerate the game runs at.", 'framerate', 'int', 60);
		option.minValue = 60;
		option.maxValue = 240;
		option.onChange = function()
		{
			FlxG.updateFramerate = PreferencesData.framerate;
			FlxG.drawFramerate = PreferencesData.framerate;
			FlxG.game.focusLostFramerate = PreferencesData.framerate;
			Lib.current.stage.frameRate = PreferencesData.framerate;
		}
		addOption(option);
		#end

		var option:Option = new Option('Safe Frames', 'The frames you have to press a note.', 'safeFrames', 'int', 10);
		option.minValue = 2;
		option.maxValue = 10;
		addOption(option);

		addOption(new Option('Check For Updates', 'If disabled, stops checking for updates.', 'checkForUpdates', 'bool', true));
		addOption(new Option('Antialiasing', 'If disabled, disables antialiasing, increases perfomance \nat the cost of graphics quality.', 'antialiasing', 'bool', true));
		addOption(new Option('Flashing', 'If disabled, disables all flashing from the engine.', 'flashing', 'bool', true));
		addOption(new Option('Shaders', 'If disabled, turns off all shaders from the engine.', 'shaders', 'bool', true));

		super();
	}
}
