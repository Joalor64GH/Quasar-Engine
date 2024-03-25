package;

import openfl.Lib;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

class Overlay extends TextField
{
	private var times:Array<Float> = [];
	private var totalMemoryPeak:Float = 0;

	public function new(x:Float, y:Float, color:Int)
	{
		super();

		this.x = x;
		this.y = x;
		this.autoSize = LEFT;
		this.selectable = false;
		this.mouseEnabled = false;
		this.defaultTextFormat = new TextFormat(Paths.font('vcr.ttf'), 16, 0xFFFFFF);
		addEventListener(Event.ENTER_FRAME, (e:Event) ->
		{
			final now = haxe.Timer.stamp();
			times.push(now);
			while (times[0] < now - 1) times.shift();

			var currentFrames:Int = times.length;
			if (currentFrames > PreferencesData.framerate)
				currentFrames = PreferencesData.framerate;

			textColor = (currentFrames <= PreferencesData.framerate / 4) ?
				0xFFFF0000 : (currentFrames <= PreferencesData.framerate / 2) ?
					0xFFFFFF00 : 0xFFFFFFFF;

			var totalMemory:Float = System.totalMemory;
			if (totalMemory > totalMemoryPeak)
				totalMemoryPeak = totalMemory;

			text = (visible) ? 
				currentFrames + ' FPS\n' + CoolUtil.getInterval(totalMemory) + ' / ' + CoolUtil.getInterval(totalMemoryPeak) + '\n' : '';
		});
	}
}