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
		FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
		FlxG.sound.music.fadeIn(1, 0, 0.8);

		var red:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFFff1b31);
		red.screenCenter();
		red.scrollFactor.set();
		PlayState.instance.add(red);

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('stages/weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.updateHitbox();
		senpaiEvil.scrollFactor.set();
		senpaiEvil.screenCenter();

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			PlayState.instance.inCutscene = true;
			PlayState.instance.add(senpaiEvil);
			senpaiEvil.alpha = 0;
			new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
			{
				senpaiEvil.alpha += 0.15;
				if (senpaiEvil.alpha < 1)
					swagTimer.reset();
				else
				{
					senpaiEvil.animation.play('idle');
					FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
					{
						PlayState.instance.remove(senpaiEvil);
						PlayState.instance.remove(red);
						FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
						{
							var doof:DialogueBox = new DialogueBox(CoolUtil.coolTextFile(Paths.txt('songs/'
								+ Paths.formatName(PlayState.instance.SONG.song.toLowerCase())
								+ '/dialogue')));
							doof.finishThing = PlayState.instance.startCountdown;
							doof.scrollFactor.set();
							doof.cameras = [PlayState.instance.camHUD];
							PlayState.instance.add(doof);
							PlayState.instance.camHUD.visible = true;
						}, true);
					});
					new FlxTimer().start(3.2, function(deadTime:FlxTimer)
					{
						FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
					});
				}
			});
		});

		allowCountdown = true;
		return Function_Stop;
	}
	else
		return Function_Continue;
}
