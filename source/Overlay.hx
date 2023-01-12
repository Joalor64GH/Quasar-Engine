package;

import haxe.Timer;
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
		this.defaultTextFormat = new TextFormat('_sans', 14, 0xFFFFFF);

		addEventListener(Event.ENTER_FRAME, function(e:Event)
		{
			var now = Timer.stamp();
			times.push(now);
			while (times[0] < now - 1)
				times.shift();

			var currentFrames:Int = times.length;
			if (currentFrames > PreferencesData.framerate)
				currentFrames = PreferencesData.framerate;

			if (currentFrames <= PreferencesData.framerate / 4)
				textColor = 0xFFFF0000;
			else if (currentFrames <= PreferencesData.framerate / 2)
				textColor = 0xFFFFFF00;
			else
				textColor = 0xFFFFFFFF;

			var totalMemory:Float = System.totalMemory;
			if (totalMemory > totalMemoryPeak)
				totalMemoryPeak = totalMemory;

			if (visible)
				text = currentFrames + ' FPS\n' + CoolUtil.getInterval(totalMemory) + ' / ' + CoolUtil.getInterval(totalMemoryPeak) + '\n';
		});
	}
}
