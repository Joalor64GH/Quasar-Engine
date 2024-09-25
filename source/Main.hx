package;

import core.ToastCore;
import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;
import states.*;

class Main extends Sprite
{
	private var gameWidth:Int = 1280;
	private var gameHeight:Int = 720;

	public static var game:FlxGame;
	public static var overlay:Overlay;
	public static var toast:ToastCore;

	public function new()
	{
		super();

		game = new FlxGame(gameWidth, gameHeight, TitleState, 60, 60, true, false);
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