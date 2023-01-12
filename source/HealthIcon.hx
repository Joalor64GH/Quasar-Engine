package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public var curCharacter:String = 'bf';
	public var isPlayer:Bool = false;

	public function new(curCharacter:String = 'bf', isPlayer:Bool = false)
	{
		super();

		this.curCharacter = curCharacter;
		this.isPlayer = isPlayer;

		changeIcon(this.curCharacter);

		switch (this.curCharacter)
		{
			case 'bf-pixel' | 'senpai' | 'senpai-angry' | 'spirit' | 'gf-pixel':
				antialiasing = false;
			default:
				antialiasing = PreferencesData.antialiasing;
		}

		scrollFactor.set();
	}

	public function changeIcon(char:String)
	{
		if (Paths.returnGraphic('characters/' + char + '/icon') != null)
		{
			loadGraphic(Paths.returnGraphic('characters/' + char + '/icon'), true, 150, 150);
			animation.add(char, [0, 1], 0, false, isPlayer);
			animation.play(char);
		}
		else
		{
			loadGraphic(Paths.returnGraphic('characters/bf/icon'), true, 150, 150);
			animation.add('bf', [0, 1], 0, false, isPlayer);
			animation.play('bf');
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
