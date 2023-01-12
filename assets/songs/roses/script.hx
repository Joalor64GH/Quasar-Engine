import('Paths');
import('CoolUtil');
import('DialogueBox');
import('flixel.FlxG');
import('flixel.util.FlxTimer');
import('states.PlayState');

var allowCountdown:Bool = false;

function startCountdown()
{
	if (!allowCountdown && PlayState.isStoryMode && !PlayState.seenCutscene)
	{
		FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
            PlayState.instance.inCutscene = true;

            var doof:DialogueBox = new DialogueBox(CoolUtil.coolTextFile(Paths.txt('songs/'
                + Paths.formatName(PlayState.instance.SONG.song.toLowerCase())
                + '/dialogue')));
            doof.finishThing = PlayState.instance.startCountdown;
            doof.scrollFactor.set();
            doof.cameras = [PlayState.instance.camHUD];
            PlayState.instance.add(doof);
		});

		allowCountdown = true;
		return Function_Stop;
	}
	else
		return Function_Continue;
}
