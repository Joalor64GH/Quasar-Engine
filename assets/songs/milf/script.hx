import('flixel.FlxG');
import('states.PlayState');

function beatHit(curBeat:Int)
{
	if (PlayState.instance.camZooming && curBeat >= 168 && curBeat < 200 && FlxG.camera.zoom < 1.35)
	{
		FlxG.camera.zoom += 0.015;
		PlayState.instance.camHUD.zoom += 0.03;
	}
}
