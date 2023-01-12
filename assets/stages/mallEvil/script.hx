import('Paths');
import('flixel.FlxSprite');
import('states.PlayState');

function create()
{
	PlayState.isPixelAssets = false;

	var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('stages/mallEvil/evilBG'));
	bg.scrollFactor.set(0.2, 0.2);
	bg.setGraphicSize(Std.int(bg.width * 0.8));
	bg.updateHitbox();
	PlayState.instance.add(bg);

	var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('stages/mallEvil/evilTree'));
	evilTree.scrollFactor.set(0.2, 0.2);
	PlayState.instance.add(evilTree);

	PlayState.instance.add(new FlxSprite(-200, 700).loadGraphic(Paths.image('stages/mallEvil/evilSnow')));
}
