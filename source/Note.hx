package;

import flixel.FlxSprite;
import flixel.math.FlxMath;
import states.PlayState;

using StringTools;

class Note extends FlxSprite
{
	public var texture(default, set):Dynamic = null;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public var offsetX:Float = 0;
	public var offsetY:Float = 0;
	public var offsetAngle:Float = 0;
	public var multAlpha:Float = 1;

	public var strumTime:Float = 0;
	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	public var sustainLength:Float = 0;
	public var sustainNote:Bool = false;
	public var altNote:Bool = false;

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false)
	{
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		this.sustainNote = sustainNote;
		this.strumTime = strumTime;
		this.noteData = noteData;

		if (this.strumTime < 0)
			this.strumTime = 0;

		x += 50;
		y -= 2000;

		if (PlayState.isPixelAssets)
		{
			if (sustainNote)
				texture = Paths.image('ui/pixel/arrowEnds');
			else
				texture = Paths.image('ui/pixel/arrows');
		}
		else
			texture = Paths.getSparrowAtlas('ui/default/NOTE_assets');

		x += swagWidth * (noteData % 4);
		switch (noteData % 4)
		{
			case 0:
				animation.play('purpleScroll');
			case 1:
				animation.play('blueScroll');
			case 2:
				animation.play('greenScroll');
			case 3:
				animation.play('redScroll');
		}

		if (sustainNote && prevNote != null)
		{
			alpha = 0.6;
			multAlpha = 0.6;

			offsetX += width / 2;

			switch (noteData % 4)
			{
				case 2:
					animation.play('greenholdend');
				case 3:
					animation.play('redholdend');
				case 1:
					animation.play('blueholdend');
				case 0:
					animation.play('purpleholdend');
			}

			updateHitbox();

			offsetX -= width / 2;

			if (PlayState.isPixelAssets)
				offsetX += 30;

			if (prevNote.sustainNote)
			{
				switch (prevNote.noteData % 4)
				{
					case 0:
						prevNote.animation.play('purplehold');
					case 1:
						prevNote.animation.play('bluehold');
					case 2:
						prevNote.animation.play('greenhold');
					case 3:
						prevNote.animation.play('redhold');
				}

				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
			}
		}

		x += offsetX;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// removes psych engine events
		if (noteData == -1)
			this.kill();

		if (mustPress)
		{
			if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * 1)
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
				canBeHit = true;
			else
				canBeHit = false;

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
			{
				if ((sustainNote && prevNote.wasGoodHit) || strumTime <= Conductor.songPosition)
					wasGoodHit = true;
			}
		}

		if (tooLate && alpha > 0.3)
			alpha = 0.3;
	}

	private function reloadAssets():Void
	{
		var lastAnim:String = null;
		if (animation.curAnim != null)
			lastAnim = animation.curAnim.name;

		if (PlayState.isPixelAssets)
		{
			loadGraphic(texture, true, 17, 17);
			animation.add('greenScroll', [6]);
			animation.add('redScroll', [7]);
			animation.add('blueScroll', [5]);
			animation.add('purpleScroll', [4]);

			if (sustainNote)
			{
				loadGraphic(texture, true, 7, 6);
				animation.add('purpleholdend', [4]);
				animation.add('greenholdend', [6]);
				animation.add('redholdend', [7]);
				animation.add('blueholdend', [5]);
				animation.add('purplehold', [0]);
				animation.add('greenhold', [2]);
				animation.add('redhold', [3]);
				animation.add('bluehold', [1]);
			}

			setGraphicSize(Std.int(width * 6));
			updateHitbox();
		}
		else
		{
			frames = texture;
			animation.addByPrefix('greenScroll', 'green0');
			animation.addByPrefix('redScroll', 'red0');
			animation.addByPrefix('blueScroll', 'blue0');
			animation.addByPrefix('purpleScroll', 'purple0');
			animation.addByPrefix('purpleholdend', 'pruple end hold');
			animation.addByPrefix('greenholdend', 'green hold end');
			animation.addByPrefix('redholdend', 'red hold end');
			animation.addByPrefix('blueholdend', 'blue hold end');
			animation.addByPrefix('purplehold', 'purple hold piece');
			animation.addByPrefix('greenhold', 'green hold piece');
			animation.addByPrefix('redhold', 'red hold piece');
			animation.addByPrefix('bluehold', 'blue hold piece');

			setGraphicSize(Std.int(width * 0.7));
			updateHitbox();
			antialiasing = PreferencesData.antialiasing;
		}

		updateHitbox();

		if (lastAnim != null)
			animation.play(lastAnim, true);
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
