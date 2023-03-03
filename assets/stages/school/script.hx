import('Paths');
import('CoolUtil');
import('flixel.FlxSprite');
import('flixel.addons.display.FlxRuntimeShader');
import('openfl.filters.ShaderFilter');
import('openfl.utils.Assets');
import('states.PlayState');
import('PreferencesData');

var widShit:Int;
var bgGirls:FlxSprite;
var shader:FlxRuntimeShader;
var shader2:FlxRuntimeShader;

function create()
{
	PlayState.isPixelAssets = true;

	var bgSky:FlxSprite = new FlxSprite().loadGraphic(Paths.image('stages/weeb/weebSky'));

	widShit = Std.int(bgSky.width * 6);

	bgSky.scrollFactor.set(0.1, 0.1);
	bgSky.setGraphicSize(widShit);
	bgSky.updateHitbox();
	PlayState.instance.add(bgSky);

	var bgSchool:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image('stages/weeb/weebSchool'));
	bgSchool.scrollFactor.set(0.6, 0.90);
	bgSchool.setGraphicSize(widShit);
	bgSchool.updateHitbox();
	PlayState.instance.add(bgSchool);

	var bgStreet:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image('stages/weeb/weebStreet'));
	bgStreet.scrollFactor.set(0.95, 0.95);
	bgStreet.setGraphicSize(widShit);
	bgStreet.updateHitbox();
	PlayState.instance.add(bgStreet);

	var fgTrees:FlxSprite = new FlxSprite(-50, 130).loadGraphic(Paths.image('stages/weeb/weebTreesBack'));
	fgTrees.scrollFactor.set(0.9, 0.9);
	fgTrees.setGraphicSize(Std.int(widShit * 0.8));
	fgTrees.updateHitbox();
	PlayState.instance.add(fgTrees);

	var bgTrees:FlxSprite = new FlxSprite(-580, -800);
	bgTrees.frames = Paths.getPackerAtlas('stages/weeb/weebTrees');
	bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
	bgTrees.animation.play('treeLoop');
	bgTrees.scrollFactor.set(0.85, 0.85);
	bgTrees.setGraphicSize(Std.int(widShit * 1.4));
	bgTrees.updateHitbox();
	PlayState.instance.add(bgTrees);

	var treeLeaves:FlxSprite = new FlxSprite(-200, -40);
	treeLeaves.frames = Paths.getSparrowAtlas('stages/weeb/petals');
	treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
	treeLeaves.animation.play('leaves');
	treeLeaves.scrollFactor.set(0.85, 0.85);
	treeLeaves.setGraphicSize(widShit);
	treeLeaves.updateHitbox();
	PlayState.instance.add(treeLeaves);

	bgGirls = new FlxSprite(-100, 190);
	bgGirls.frames = Paths.getSparrowAtlas('stages/weeb/bgFreaks');
	if (PlayState.SONG.song.toLowerCase() == 'roses')
	{
		bgGirls.animation.addByIndices('danceLeft', 'BG fangirls dissuaded', CoolUtil.numberArray(14), "", 24, false);
		bgGirls.animation.addByIndices('danceRight', 'BG fangirls dissuaded', CoolUtil.numberArray(30, 15), "", 24, false);
	}
	else
	{
		bgGirls.animation.addByIndices('danceLeft', 'BG girls group', CoolUtil.numberArray(14), "", 24, false);
		bgGirls.animation.addByIndices('danceRight', 'BG girls group', CoolUtil.numberArray(30, 15), "", 24, false);
	}
	bgGirls.animation.play('danceLeft');
	bgGirls.scrollFactor.set(0.9, 0.9);
	bgGirls.setGraphicSize(Std.int(bgGirls.width * 6));
	bgGirls.updateHitbox();
	PlayState.instance.add(bgGirls);

    if (PreferencesData.shaders)
	{
		shader = new FlxRuntimeShader(Paths.frag('shaders/vcr-distortion'), null);
		shader.setFloat('iTime', 0);
		shader.setBool('noise', true);
		shader.setBitmapData('iChannel', Assets.getBitmapData('assets/images/noise.png'));
		PlayState.instance.camGame.setFilters([new ShaderFilter(shader)]);

		shader2 = new FlxRuntimeShader(Paths.frag('shaders/vcr-distortion'), null);
		shader2.setFloat('iTime', 0);
		shader2.setBool('noise', false);
		PlayState.instance.camHUD.setFilters([new ShaderFilter(shader2)]);
	}
}

var shaderTime:Float = 0;

function update(elapsed:Float)
{
	shaderTime += elapsed;
	shader.setFloat('iTime', shaderTime);
	shader2.setFloat('iTime', shaderTime);
}

function gameOver()
{
	PlayState.instance.camGame.setFilters([]);
	PlayState.instance.camHUD.setFilters([]);
}

var danceDir:Bool = false;
function beatHit(curBeat:Int)
{
	danceDir = !danceDir;

	if (danceDir)
		bgGirls.animation.play('danceRight', true);
	else
		bgGirls.animation.play('danceLeft', true);
}
