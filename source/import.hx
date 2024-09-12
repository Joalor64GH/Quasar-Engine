#if !macro
#if sys
import sys.io.File;
import sys.FileSystem;
#end

import haxe.Json;
import flixel.*;
import flixel.util.*;
import flixel.math.*;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.keyboard.FlxKey;
import flixel.sound.FlxSound;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import states.PlayState;

import core.*;
import states.*;
import substates.*;

import Conductor;
import Conductor.BPMChangeEvent;
import DiscordClient;
import PlayerSettings;

import HighScore;
import Paths;

import parse.Character;
import parse.Stage;
import parse.Week;
import parse.StoryCharacter;

using CoolUtil;
using StringTools;
#if !debug
@:noDebug
#end
#end