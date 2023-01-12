import('Paths');
import('CoolUtil');
import('DialogueBox');
import('flixel.FlxG');
import('flixel.FlxSprite');
import('flixel.util.FlxTimer');
import('states.PlayState');

var allowCountdown:Bool = false;

function startCountdown()
{
	if (!allowCountdown && PlayState.isStoryMode && !PlayState.seenCutscene)
	{
		FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
		FlxG.sound.music.fadeIn(1, 0, 0.8);

		var black:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		black.screenCenter();
		black.scrollFactor.set();
		PlayState.instance.add(black);

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
				tmr.reset(0.3);
			else
			{
				PlayState.instance.inCutscene = true;

				var doof:DialogueBox = new DialogueBox(CoolUtil.coolTextFile(Paths.txt('songs/'
					+ Paths.formatName(PlayState.instance.SONG.song.toLowerCase())
					+ '/dialogue')));
				doof.finishThing = PlayState.instance.startCountdown;
				doof.scrollFactor.set();
				doof.cameras = [PlayState.instance.camHUD];
				PlayState.instance.add(doof);
			}
		});

		allowCountdown = true;
		return Function_Stop;
	}
	else
		return Function_Continue;
}
