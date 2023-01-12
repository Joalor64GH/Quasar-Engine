package;

#if mobile
import mobile.MobileControls;
import mobile.flixel.FlxVirtualPad;
import flixel.input.actions.FlxActionInput;
import flixel.util.FlxDestroyUtil;
#end
import flixel.util.FlxColor;
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxState;
import flixel.addons.ui.FlxUIState;
import flixel.addons.transition.FlxTransitionableState;

class MusicBeatState extends FlxUIState
{
	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	#if mobile
	var mobileControls:MobileControls;
	var virtualPad:FlxVirtualPad;
	var trackedinputsUI:Array<FlxActionInput> = [];
	var trackedinputsNOTES:Array<FlxActionInput> = [];

	public function addVirtualPad(DPad:FlxDPadMode, Action:FlxActionMode)
	{
		virtualPad = new FlxVirtualPad(DPad, Action);
		add(virtualPad);

		controls.setVirtualPadUI(virtualPad, DPad, Action);
		trackedinputsUI = controls.trackedinputsUI;
		controls.trackedinputsUI = [];
	}

	public function removeVirtualPad()
	{
		if (trackedinputsUI != [])
			controls.removeAControlsInput(trackedinputsUI);

		if (virtualPad != null)
			remove(virtualPad);
	}

	public function addMobileControls(DefaultDrawTarget:Bool = true)
	{
		mobileControls = new MobileControls();

		switch (MobileControls.getMode())
		{
			case 'Pad-Right' | 'Pad-Left' | 'Pad-Custom':
				controls.setVirtualPadNOTES(mobileControls.virtualPad, RIGHT_FULL, NONE);
			case 'Pad-Duo':
				controls.setVirtualPadNOTES(mobileControls.virtualPad, BOTH_FULL, NONE);
			case 'Hitbox':
				controls.setHitBox(mobileControls.hitbox);
			case 'Keyboard': // do nothing
		}

		trackedinputsNOTES = controls.trackedinputsNOTES;
		controls.trackedinputsNOTES = [];

		var camControls:FlxCamera = new FlxCamera();
		FlxG.cameras.add(camControls, DefaultDrawTarget);
		camControls.bgColor.alpha = 0;

		mobileControls.cameras = [camControls];
		mobileControls.visible = false;
		add(mobileControls);
	}

	public function removeMobileControls()
	{
		if (trackedinputsNOTES != [])
			controls.removeAControlsInput(trackedinputsNOTES);

		if (mobileControls != null)
			remove(mobileControls);
	}

	public function addPadCamera(DefaultDrawTarget:Bool = true)
	{
		if (virtualPad != null)
		{
			var camControls:FlxCamera = new FlxCamera();
			FlxG.cameras.add(camControls, DefaultDrawTarget);
			camControls.bgColor.alpha = 0;
			virtualPad.cameras = [camControls];
		}
	}
	#end

	override function destroy()
	{
		#if mobile
		if (trackedinputsNOTES != [])
			controls.removeAControlsInput(trackedinputsNOTES);

		if (trackedinputsUI != [])
			controls.removeAControlsInput(trackedinputsUI);
		#end

		super.destroy();

		#if mobile
		if (virtualPad != null)
		{
			virtualPad = FlxDestroyUtil.destroy(virtualPad);
			virtualPad = null;
		}

		if (mobileControls != null)
		{
			mobileControls = FlxDestroyUtil.destroy(mobileControls);
			mobileControls = null;
		}
		#end
	}

	override function create()
	{
		super.create();

		if (!FlxTransitionableState.skipNextTransOut)
		{
			var cam:FlxCamera = new FlxCamera();
			cam.bgColor.alpha = 0;
			FlxG.cameras.add(cam, false);
			cam.fade(FlxColor.BLACK, 0.7, true, function()
			{
				FlxTransitionableState.skipNextTransOut = false;
			});
		}
		else
		{
			FlxTransitionableState.skipNextTransOut = false;
		}
	}

	override function update(elapsed:Float)
	{
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep > 0)
			stepHit();

		if (FlxG.save.data != null)
			FlxG.save.data.fullscreen = FlxG.fullscreen;

		super.update(elapsed);
	}

	private function updateBeat():Void
		curBeat = Math.floor(curStep / 4);

	public static var currentColor = 0;

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
	}

	#if !mobile
	public function onDropFile(path:String)
	{
	}
	#end

	public static function switchState(nextState:FlxState)
	{
		if (!FlxTransitionableState.skipNextTransIn)
		{
			var cam:FlxCamera = new FlxCamera();
			cam.bgColor.alpha = 0;
			FlxG.cameras.add(cam, false);
			cam.fade(FlxColor.BLACK, 0.7, false, function()
			{
				FlxG.switchState(nextState);
				FlxTransitionableState.skipNextTransIn = false;
			});
		}
		else
		{
			FlxG.switchState(nextState);
			FlxTransitionableState.skipNextTransIn = false;
		}
	}
}
