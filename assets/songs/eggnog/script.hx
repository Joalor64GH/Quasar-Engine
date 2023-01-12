import('Paths');
import('flixel.FlxG');
import('flixel.FlxSprite');
import('states.PlayState');

function endSong()
{
	if (PlayState.SONG.song.toLowerCase() == 'eggnog')
	{
		var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
			-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, 0xFF000000);
		blackShit.scrollFactor.set();
		PlayState.instance.add(blackShit);
		PlayState.instance.camHUD.visible = false;
		FlxG.sound.play(Paths.sound('Lights_Shut_off'));
	}
}
