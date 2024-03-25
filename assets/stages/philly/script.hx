import('Paths');
import('Conductor');
import('flixel.FlxG');
import('flixel.FlxSprite');
import('flixel.sound.FlxSound');
import('flixel.math.FlxMath');
import('states.PlayState');

var phillyCityLights:Array<FlxSprite>;
var phillyTrain:FlxSprite;
var startedMoving:Bool = false;
var trainMoving:Bool = false;
var trainCars:Int = 8;
var trainFinishing:Bool = false;
var trainCooldown:Int = 0;
var trainFrameTiming:Float = 0;
var trainSound:FlxSound;

function create()
{
	PlayState.isPixelAssets = false;

	var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('stages/philly/sky'));
	bg.scrollFactor.set(0.1, 0.1);
	PlayState.instance.add(bg);

	var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('stages/philly/city'));
	city.scrollFactor.set(0.3, 0.3);
	city.setGraphicSize(Std.int(city.width * 0.85));
	city.updateHitbox();
	PlayState.instance.add(city);

	phillyCityLights = [];
	PlayState.instance.add(phillyCityLights);

	for (i in 0...5)
	{
		var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('stages/philly/win' + i));
		light.setGraphicSize(Std.int(light.width * 0.85));
		light.updateHitbox();
		light.scrollFactor.set(0.3, 0.3);
		light.visible = false;
		PlayState.instance.add(light);
		phillyCityLights.push(light);
	}

	var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('stages/philly/behindTrain'));
	PlayState.instance.add(streetBehind);

	phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('stages/philly/train'));
	PlayState.instance.add(phillyTrain);

	trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
	FlxG.sound.list.add(trainSound);

	var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('stages/philly/street'));
	PlayState.instance.add(street);
}

function updateTrainPos()
{
	if (trainSound.time >= 4700)
	{
		startedMoving = true;
		PlayState.instance.gf.playAnim('hairBlow');
	}

	if (startedMoving)
	{
		phillyTrain.x -= 400;

		if (phillyTrain.x < -2000 && !trainFinishing)
		{
			phillyTrain.x = -1150;
			trainCars -= 1;

			if (trainCars <= 0)
				trainFinishing = true;
		}

		if (phillyTrain.x < -4000 && trainFinishing)
			trainReset();
	}
}

function trainStart()
{
	trainMoving = true;
	if (!trainSound.playing)
		trainSound.play(true);
}

function trainReset()
{
	PlayState.instance.gf.playAnim('hairFall');
	PlayState.instance.gf.specialAnim = true;
	phillyTrain.x = FlxG.width + 200;
	trainMoving = false;
	trainCars = 8;
	trainFinishing = false;
	startedMoving = false;
}

function update(elapsed:Float)
{
	for (light in phillyCityLights)
		light.alpha = FlxMath.lerp(1, 0, ((Conductor.songPosition / Conductor.crochet / 4) % 1));

	if (trainMoving)
	{
		trainFrameTiming += elapsed;

		if (trainFrameTiming >= 1 / 24)
		{
			updateTrainPos();
			trainFrameTiming = 0;
		}
	}
}

function beatHit(curBeat:Int)
{
	if (!trainMoving)
		trainCooldown += 1;

	if (curBeat % 4 == 0)
	{
		for (light in phillyCityLights)
		{
			light.alpha = 1;
			light.visible = false;
		}

		phillyCityLights[FlxG.random.int(0, phillyCityLights.length - 1)].visible = true;
	}

	if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
	{
		trainCooldown = FlxG.random.int(-4, 0);
		trainStart();
	}
}
