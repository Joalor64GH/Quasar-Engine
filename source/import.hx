#if !macro
#if sys
import sys.io.File;
import sys.FileSystem;
#end

import haxe.Json;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxSubState;
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

import parse.Character;
import parse.Stage;
import parse.Week;
import parse.StoryCharacter;

using CoolUtil;
using StringTools;
#end