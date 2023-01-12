import('Paths');
import('flixel.FlxG');
import('flixel.FlxSprite');
import('flixel.graphics.frames.FlxAtlasFrames');
import('states.PlayState');

var halloweenBG:FlxSprite;
var lightningStrikeBeat:Int = 0;
var lightningOffset:Int = 8;

function create()
{
	PlayState.isPixelAssets = false;

	halloweenBG = new FlxSprite(-200, -100);
	halloweenBG.frames = Paths.getSparrowAtlas('stages/spooky/halloween_bg');
	halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
	halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
	halloweenBG.animation.play('idle');
	PlayState.instance.add(halloweenBG);
}

function lightningStrikeShit(curBeat:Int)
{
	FlxG.sound.play(Paths.sound('thunder_' + FlxG.random.int(1, 2)));
	halloweenBG.animation.play('lightning');

	lightningStrikeBeat = curBeat;
	lightningOffset = FlxG.random.int(8, 24);

	PlayState.instance.boyfriend.playAnim('scared', true);
	PlayState.instance.gf.playAnim('scared', true);
}

function beatHit(curBeat:Int)
{
	if (FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		lightningStrikeShit(curBeat);
}
