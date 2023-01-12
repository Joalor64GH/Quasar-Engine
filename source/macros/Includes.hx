package macros;

import haxe.macro.Compiler;
import haxe.macro.Expr;

class Includes
{
	public static macro function run():Expr
	{
		#if !display
		#if android
		Compiler.include('android');
		#end
		#if cpp
		Compiler.include('cpp.RawPointer');
		Compiler.include('cpp.Pointer');
		#end
		Compiler.include('haxe.crypto');
		Compiler.include('flixel');
		Compiler.include('spine');
		#if sys
		Compiler.include('sys');
		#end
		#end
		return macro $v{null};
	}
}
