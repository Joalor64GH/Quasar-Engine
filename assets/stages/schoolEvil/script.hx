import('Paths');
import('flixel.FlxSprite');
import('flixel.addons.display.FlxRuntimeShader');
import('flixel.addons.effects.FlxTrail');
import('openfl.filters.ShaderFilter');
import('openfl.utils.Assets');
import('states.PlayState');

var shader:FlxRuntimeShader;
var shader2:FlxRuntimeShader;

function create()
{
	PlayState.isPixelAssets = true;

	var bg:FlxSprite = new FlxSprite(400, 200);
	bg.frames = Paths.getSparrowAtlas('stages/weeb/animatedEvilSchool');
	bg.animation.addByPrefix('idle', 'background 2', 24);
	bg.animation.play('idle');
	bg.scrollFactor.set(0.8, 0.9);
	bg.scale.set(6, 6);
	PlayState.instance.add(bg);

	PlayState.instance.add(new FlxTrail(PlayState.instance.dad, null, 4, 24, 0.3, 0.069));

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
