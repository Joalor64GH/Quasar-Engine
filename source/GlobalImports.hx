import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.FlxSprite;
import flixel.FlxG;
import Alphabet;
import DiscordClient;
import Conductor;
import parse.Song;
import Paths;
import CoolUtil;
import HighScore;
import PlayerSettings;
import MusicBeatState;
import MusicBeatSubstate;
import states.PlayState;
import Controls;

using CoolUtil;
using StringTools;

#if sys
import sys.io.File;
import sys.FileSystem;
#end