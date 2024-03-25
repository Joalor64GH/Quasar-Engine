#if !macro
#if sys
import sys.io.File;
import sys.FileSystem;
#end

import haxe.Json;

import flixel.*;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;

import Conductor;
import DiscordClient;
import PlayerSettings;
import MusicBeatState;
import MusicBeatSubstate;
import Conductor.BPMChangeEvent;
import states.PlayState;
import parse.Song;
import HighScore;
import Alphabet;
import CoolUtil;
import Controls;
import Paths;

using CoolUtil;
using StringTools;
#end