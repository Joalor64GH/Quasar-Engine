package;

import core.ToastCore;
import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;
import states.TitleState;

class Main extends Sprite
{
	private var gameWidth:Int = 1280;
	private var gameHeight:Int = 720;
	private var zoom:Float = -1;

	public static var game:FlxGame;
	public static var overlay:Overlay;
	public static var toast:ToastCore;

	public function new()
	{
		super();

		SUtil.uncaughtErrorHandler();

		final stageWidth:Int = Lib.current.stage.stageWidth;
		final stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			final ratioX:Float = stageWidth / gameWidth;
			final ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		SUtil.check();

		game = new FlxGame(gameWidth, gameHeight, TitleState, zoom, 60, 60, true, false);
		addChild(game);

		overlay = new Overlay(10, 10, 0xFFFFFF);
		if (overlay != null)
			overlay.visible = PreferencesData.overlay;
		addChild(overlay);

		toast = new ToastCore();
		addChild(toast);

                #if cpp
		cpp.NativeGc.enable(true);
		cpp.NativeGc.run(true);
		#end
	}
}
