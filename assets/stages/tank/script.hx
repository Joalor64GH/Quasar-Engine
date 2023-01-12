import('Paths');
import('flixel.FlxG');
import('flixel.FlxSprite');
import('states.PlayState');

var tankWatchtower:FlxSprite;
var tankGround:FlxSprite;
var tankdude0:FlxSprite;
var tankdude1:FlxSprite;
var tankdude2:FlxSprite;
var tankdude4:FlxSprite;
var tankdude5:FlxSprite;
var tankdude3:FlxSprite;

function create()
{
	PlayState.isPixelAssets = false;

	var sky:FlxSprite = new FlxSprite(-400, -400).loadGraphic(Paths.image('stages/tank/tankSky'));
	sky.scrollFactor.set(0, 0);
	PlayState.instance.add(sky);

	var clouds:FlxSprite = new FlxSprite(FlxG.random.int(-700, -100),
		FlxG.random.int(-20, 20)).loadGraphic(Paths.image('stages/tank/tankClouds'));
	clouds.scrollFactor.set(0.1, 0.1);
	clouds.velocity.x = FlxG.random.float(5, 15);
	PlayState.instance.add(clouds);

	var mountains:FlxSprite = new FlxSprite(-300, -20).loadGraphic(Paths.image('stages/tank/tankMountains'));
	mountains.scrollFactor.set(0.2, 0.2);
	mountains.setGraphicSize(Std.int(mountains.width * 1.2));
	mountains.updateHitbox();
	PlayState.instance.add(mountains);

	var buildings:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image('stages/tank/tankBuildings'));
	buildings.scrollFactor.set(0.3, 0.3);
	buildings.setGraphicSize(Std.int(buildings.width * 1.1));
	buildings.updateHitbox();
	PlayState.instance.add(buildings);

	var ruins:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image('stages/tank/tankRuins'));
	ruins.scrollFactor.set(0.35, 0.35);
	ruins.setGraphicSize(Std.int(ruins.width * 1.1));
	ruins.updateHitbox();
	PlayState.instance.add(ruins);

	var smokeL:FlxSprite = new FlxSprite(-200, -100);
	smokeL.frames = Paths.getSparrowAtlas('stages/tank/smokeLeft');
	smokeL.animation.addByPrefix('SmokeBlurLeft', 'SmokeBlurLeft', 24, true);
	smokeL.animation.play('SmokeBlurLeft');
	smokeL.scrollFactor.set(0.4, 0.4);
	PlayState.instance.add(smokeL);

	var smokeR:FlxSprite = new FlxSprite(1100, -100);
	smokeR.frames = Paths.getSparrowAtlas('stages/tank/smokeRight');
	smokeR.animation.addByPrefix('SmokeRight', 'SmokeRight', 24, true);
	smokeR.animation.play('SmokeRight');
	smokeR.scrollFactor.set(0.4, 0.4);
	PlayState.instance.add(smokeR);

	tankWatchtower = new FlxSprite(100, 50);
	tankWatchtower.frames = Paths.getSparrowAtlas('stages/tank/tankWatchtower');
	tankWatchtower.animation.addByPrefix('watchtower gradient color', 'watchtower gradient color', 24, false);
	tankWatchtower.animation.play('watchtower gradient color');
	tankWatchtower.scrollFactor.set(0.5, 0.5);
	PlayState.instance.add(tankWatchtower);

	tankGround = new FlxSprite(300, 300);
	tankGround.frames = Paths.getSparrowAtlas('stages/tank/tankRolling');
	tankGround.animation.addByPrefix('BG tank w lighting', 'BG tank w lighting', 24, true);
	tankGround.animation.play('BG tank w lighting');
	tankGround.scrollFactor.set(0.5, 0.5);
	PlayState.instance.add(tankGround);

	// tankmanRun = new FlxTypedGroup<TankmenBG>();
	// add(tankmanRun);

	var ground:FlxSprite = new FlxSprite(-420, -150).loadGraphic(Paths.image('stages/tank/tankGround'));
	ground.setGraphicSize(Std.int(ground.width * 1.15));
	ground.updateHitbox();
	PlayState.instance.add(ground);

	moveTank();

	PlayState.instance.add(PlayState.instance.gf);
	PlayState.instance.add(PlayState.instance.dad);
	PlayState.instance.add(PlayState.instance.boyfriend);

	tankdude0 = new FlxSprite(-500, 650);
	tankdude0.frames = Paths.getSparrowAtlas('stages/tank/tank0');
	tankdude0.animation.addByPrefix('fg', 'fg', 24, false);
	tankdude0.animation.play('fg');
	tankdude0.scrollFactor.set(1.7, 1.5);
	PlayState.instance.add(tankdude0);

	tankdude1 = new FlxSprite(-300, 750);
	tankdude1.frames = Paths.getSparrowAtlas('stages/tank/tank1');
	tankdude1.animation.addByPrefix('fg', 'fg', 24, false);
	tankdude1.animation.play('fg');
	tankdude1.scrollFactor.set(2, 0.2);
	PlayState.instance.add(tankdude1);

	tankdude2 = new FlxSprite(450, 940);
	tankdude2.frames = Paths.getSparrowAtlas('stages/tank/tank2');
	tankdude2.animation.addByPrefix('fg', 'foreground', 24, false);
	tankdude2.animation.play('fg');
	tankdude2.scrollFactor.set(1.5, 1.5);
	PlayState.instance.add(tankdude2);

	tankdude4 = new FlxSprite(1300, 900);
	tankdude4.frames = Paths.getSparrowAtlas('stages/tank/tank4');
	tankdude4.animation.addByPrefix('fg', 'fg', 24, false);
	tankdude4.animation.play('fg');
	tankdude4.scrollFactor.set(1.5, 1.5);
	PlayState.instance.add(tankdude4);

	tankdude5 = new FlxSprite(1620, 700);
	tankdude5.frames = Paths.getSparrowAtlas('stages/tank/tank5');
	tankdude5.animation.addByPrefix('fg', 'fg', 24, false);
	tankdude5.animation.play('fg');
	tankdude5.scrollFactor.set(1.5, 1.5);
	PlayState.instance.add(tankdude5);

	tankdude3 = new FlxSprite(1300, 1200);
	tankdude3.frames = Paths.getSparrowAtlas('stages/tank/tank3');
	tankdude3.animation.addByPrefix('fg', 'fg', 24, false);
	tankdude3.animation.play('fg');
	tankdude3.scrollFactor.set(3.5, 2.5);
	PlayState.instance.add(tankdude3);
}

function update(elapsed:Float)
{
	if (!PlayState.instance.inCutscene)
		moveTank();
}

var tankAngle:Float = FlxG.random.int(-90, 45);
var tankSpeed:Float = FlxG.random.float(5, 7);
var tankX:Float = 400;

function moveTank()
{
	tankAngle += tankSpeed * FlxG.elapsed;
	tankGround.angle = (tankAngle - 90 + 15);
	tankGround.x = tankX + 1500 * Math.cos(Math.PI / 180 * (1 * tankAngle + 180));
	tankGround.y = 1300 + 1100 * Math.sin(Math.PI / 180 * (1 * tankAngle + 180));
}

function beatHit(curBeat:Int)
{
	tankWatchtower.animation.play('watchtower gradient color');
	tankdude0.animation.play('fg');
	tankdude1.animation.play('fg');
	tankdude2.animation.play('fg');
	tankdude4.animation.play('fg');
	tankdude5.animation.play('fg');
	tankdude3.animation.play('fg');
}
