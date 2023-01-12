import('Paths');
import('flixel.FlxSprite');
import('states.PlayState');

function create()
{
	PlayState.isPixelAssets = false;

	PlayState.instance.add(new FlxSprite(-600, -200).loadGraphic(Paths.image('stages/stage/stageback')));

	var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stages/stage/stagefront'));
	stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
	stageFront.updateHitbox();
	PlayState.instance.add(stageFront);

	var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stages/stage/stagecurtains'));
	stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
	stageCurtains.updateHitbox();
	PlayState.instance.add(stageCurtains);

	if (PlayState.SONG.player2 == 'gf')
	{
		PlayState.instance.dad.setPosition(PlayState.instance.gf.x, PlayState.instance.gf.y);
		PlayState.instance.gf.visible = false;
	}
}
