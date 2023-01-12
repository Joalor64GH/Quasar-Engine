package;

import flixel.FlxG;
import flixel.FlxSprite;
import states.PlayState;

using StringTools;

/**
 * Class based originaly from Psych Engine.
 * Credits: Shadow Mario.
 */
class StrumNote extends FlxSprite
{
	private var player:Int = 0;
	private var noteID:Int = 0;

	public var texture(default, set):Dynamic = null;
	public var downScroll:Bool = false;
	public var resetAnim:Float = 0;

	public function new(x:Float, y:Float, noteID:Int = 0, player:Int = 0)
	{
		super(x, y);

		this.player = player;
		this.noteID = noteID;

		if (PlayState.isPixelAssets)
			texture = Paths.image('ui/pixel/arrows');
		else
			texture = Paths.getSparrowAtlas('ui/default/NOTE_assets');

		scrollFactor.set();
	}

	private function reloadAssets():Void
	{
		var lastAnim:String = null;
		if (animation.curAnim != null)
			lastAnim = animation.curAnim.name;

		if (PlayState.isPixelAssets)
		{
			loadGraphic(Paths.image('ui/pixel/arrows'), true, 17, 17);
			animation.add('green', [6]);
			animation.add('red', [7]);
			animation.add('blue', [5]);
			animation.add('purplel', [4]);

			switch (Math.abs(noteID) % 4)
			{
				case 0:
					animation.add('static', [0]);
					animation.add('pressed', [4, 8], 12, false);
					animation.add('confirm', [12, 16], 12, false);
				case 1:
					animation.add('static', [1]);
					animation.add('pressed', [5, 9], 12, false);
					animation.add('confirm', [13, 17], 12, false);
				case 2:
					animation.add('static', [2]);
					animation.add('pressed', [6, 10], 12, false);
					animation.add('confirm', [14, 18], 12, false);
				case 3:
					animation.add('static', [3]);
					animation.add('pressed', [7, 11], 12, false);
					animation.add('confirm', [15, 19], 12, false);
			}

			antialiasing = false;
			setGraphicSize(Std.int(width * 6));
		}
		else
		{
			frames = Paths.getSparrowAtlas('ui/default/NOTE_assets');
			animation.addByPrefix('green', 'arrowUP');
			animation.addByPrefix('blue', 'arrowDOWN');
			animation.addByPrefix('purple', 'arrowLEFT');
			animation.addByPrefix('red', 'arrowRIGHT');

			switch (Math.abs(noteID) % 4)
			{
				case 0:
					animation.addByPrefix('static', 'arrowLEFT');
					animation.addByPrefix('pressed', 'left press', 24, false);
					animation.addByPrefix('confirm', 'left confirm', 24, false);
				case 1:
					animation.addByPrefix('static', 'arrowDOWN');
					animation.addByPrefix('pressed', 'down press', 24, false);
					animation.addByPrefix('confirm', 'down confirm', 24, false);
				case 2:
					animation.addByPrefix('static', 'arrowUP');
					animation.addByPrefix('pressed', 'up press', 24, false);
					animation.addByPrefix('confirm', 'up confirm', 24, false);
				case 3:
					animation.addByPrefix('static', 'arrowRIGHT');
					animation.addByPrefix('pressed', 'right press', 24, false);
					animation.addByPrefix('confirm', 'right confirm', 24, false);
			}

			antialiasing = PreferencesData.antialiasing;
			setGraphicSize(Std.int(width * 0.7));
		}

		updateHitbox();

		if (lastAnim != null)
			playAnim(lastAnim, true);
	}

	public function postAddedToGroup():Void
	{
		ID = noteID;
		playAnim('static');
		x += Note.swagWidth * noteID;
		x += 50;
		x += ((FlxG.width / 2) * player);
	}

	override function update(elapsed:Float)
	{
		if (resetAnim > 0)
		{
			resetAnim -= elapsed;
			if (resetAnim <= 0)
			{
				playAnim('static', true);
				resetAnim = 0;
			}
		}

		if ((animation.curAnim != null && animation.curAnim.name == 'confirm') && !PlayState.isPixelAssets)
			centerOrigin();

		super.update(elapsed);
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);
		centerOffsets();
		centerOrigin();

		if ((animation.curAnim != null && animation.curAnim.name == 'confirm') && !PlayState.isPixelAssets)
			centerOrigin();
	}

	private function set_texture(value:Dynamic):Dynamic
	{
		if (texture != value)
		{
			texture = value;
			reloadAssets();
		}

		return value;
	}
}
