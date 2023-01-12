import('Paths');
import('Conductor');
import('flixel.FlxG');
import('flixel.tweens.FlxEase');
import('flixel.tweens.FlxTween');
import('states.PlayState');

function camearaFollow(character:String)
{
	if (character == 'dad')
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	else
		FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
}

function opponentNoteHit(daNote:Note)
	PlayState.instance.camZooming = false;

function beatHit(curBeat:Int)
{
	if (curBeat % 16 == 15 && PlayState.instance.dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
	{
		PlayState.instance.boyfriend.playAnim('hey', true);
		PlayState.instance.boyfriend.specialAnim = true;
		PlayState.instance.dad.playAnim('cheer', true);
		PlayState.instance.dad.specialAnim = true;
	}
}
