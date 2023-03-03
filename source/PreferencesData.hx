package;

import Controls;
import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import openfl.Lib;

class PreferencesData
{
	public static var ghostTapping:Bool = true;
	public static var downScroll:Bool = false;
	public static var centeredNotes:Bool = false;
	public static var noteSplashes:Bool = true;
	public static var overlay:Bool = false;
	public static var framerate:Int = 60;
	public static var safeFrames:Int = 10;
	public static var checkForUpdates:Bool = true;
	public static var antialiasing:Bool = true;
	public static var flashing:Bool = true;
	public static var shaders:Bool = true;

	public static var keyBinds:Map<String, Array<FlxKey>> = [
		'note_left' => [A, LEFT],
		'note_down' => [S, DOWN],
		'note_up' => [W, UP],
		'note_right' => [D, RIGHT],
		'ui_left' => [A, LEFT],
		'ui_down' => [S, DOWN],
		'ui_up' => [W, UP],
		'ui_right' => [D, RIGHT],
		'accept' => [SPACE, ENTER],
		'back' => [BACKSPACE, ESCAPE],
		'pause' => [ENTER, ESCAPE],
		'reset' => [R, NONE],
		'volume_mute' => [ZERO, NONE],
		'volume_up' => [NUMPADPLUS, PLUS],
		'volume_down' => [NUMPADMINUS, MINUS]
	];

	public static final defaultKeys:Map<String, Array<FlxKey>> = [
		'note_left' => [A, LEFT],
		'note_down' => [S, DOWN],
		'note_up' => [W, UP],
		'note_right' => [D, RIGHT],
		'ui_left' => [A, LEFT],
		'ui_down' => [S, DOWN],
		'ui_up' => [W, UP],
		'ui_right' => [D, RIGHT],
		'accept' => [SPACE, ENTER],
		'back' => [BACKSPACE, ESCAPE],
		'pause' => [ENTER, ESCAPE],
		'reset' => [R, NONE],
		'volume_mute' => [ZERO, NONE],
		'volume_up' => [NUMPADPLUS, PLUS],
		'volume_down' => [NUMPADMINUS, MINUS]
	];

	public static function write()
	{
		FlxG.save.data.ghostTapping = ghostTapping;
		FlxG.save.data.downScroll = downScroll;
		FlxG.save.data.centeredNotes = centeredNotes;
		FlxG.save.data.noteSplashes = noteSplashes;
		FlxG.save.data.overlay = overlay;
		FlxG.save.data.framerate = framerate;
		FlxG.save.data.safeFrames = safeFrames;
		FlxG.save.data.checkForUpdates = checkForUpdates;
		FlxG.save.data.antialiasing = antialiasing;
		FlxG.save.data.flashing = flashing;
		FlxG.save.flush();

		var save:FlxSave = new FlxSave();
		save.bind('controls_input', Lib.application.meta.get('company'));
		save.data.keyBinds = keyBinds;
		save.flush();

		Conductor.recalculateTimings();
	}

	public static function load()
	{
		if (FlxG.save.data.ghostTapping != null)
			ghostTapping = FlxG.save.data.ghostTapping;

		if (FlxG.save.data.downScroll != null)
			downScroll = FlxG.save.data.downScroll;

		if (FlxG.save.data.centeredNotes != null)
			centeredNotes = FlxG.save.data.centeredNotes;

		if (FlxG.save.data.noteSplashes != null)
			noteSplashes = FlxG.save.data.noteSplashes;

		if (FlxG.save.data.overlay != null)
		{
			overlay = FlxG.save.data.overlay;
			if (Main.overlay != null)
				Main.overlay.visible = overlay;
		}

		if (FlxG.save.data.framerate != null)
		{
			framerate = FlxG.save.data.framerate;
			FlxG.updateFramerate = framerate;
			FlxG.drawFramerate = framerate;
			FlxG.game.focusLostFramerate = framerate;
			Lib.current.stage.frameRate = framerate;
		}

		if (FlxG.save.data.safeFrames != null)
			safeFrames = FlxG.save.data.safeFrames;

		if (FlxG.save.data.checkForUpdates != null)
			checkForUpdates = FlxG.save.data.checkForUpdates;

		if (FlxG.save.data.antialiasing != null)
			antialiasing = FlxG.save.data.antialiasing;

		if (FlxG.save.data.flashing != null)
			flashing = FlxG.save.data.flashing;

		if (FlxG.save.data.shaders != null)
			shaders = FlxG.save.data.shaders;

		if (FlxG.save.data.volume != null)
			FlxG.sound.volume = FlxG.save.data.volume;

		if (FlxG.save.data.mute != null)
			FlxG.sound.muted = FlxG.save.data.mute;

		var save:FlxSave = new FlxSave();
		save.bind('controls_input', Lib.application.meta.get('company'));
		if (save != null && save.data.keyBinds != null)
		{
			var loadedControls:Map<String, Array<FlxKey>> = save.data.keyBinds;
			for (control => keys in loadedControls)
				keyBinds.set(control, keys);

			reloadControls();
		}

		write();
	}

	public static function reloadControls()
	{
		PlayerSettings.player1.controls.setKeyboardScheme(KeyboardScheme.Solo);

		FlxG.sound.muteKeys = copyKey(keyBinds.get('volume_mute'));
		FlxG.sound.volumeDownKeys = copyKey(keyBinds.get('volume_down'));
		FlxG.sound.volumeUpKeys = copyKey(keyBinds.get('volume_up'));
	}

	public static function copyKey(arrayToCopy:Array<FlxKey>):Array<FlxKey>
	{
		var copiedArray:Array<FlxKey> = arrayToCopy.copy();

		if (copiedArray.contains(NONE))
			copiedArray.remove(NONE);

		return copiedArray;
	}
}
