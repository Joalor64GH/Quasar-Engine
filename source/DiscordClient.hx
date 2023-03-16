package;

#if FUTURE_DISCORD_RCP
import Sys.sleep;
import discord_rpc.DiscordRpc;
import sys.thread.Thread;

class DiscordClient
{
	public function new()
	{
		trace("Discord Client starting...");
		DiscordRpc.start({
			clientID: "988897056292733049",
			onReady: onReady,
			onError: onError,
			onDisconnected: onDisconnected
		});

		trace("Discord Client started.");

		while (true)
		{
			DiscordRpc.process();
			sleep(2);
		}

		DiscordRpc.shutdown();
	}

	public static function shutdown():Void
		DiscordRpc.shutdown();

	static function onReady():Void
	{
		DiscordRpc.presence({
			details: "In the Menus",
			state: null,
			largeImageKey: 'icon',
			largeImageText: "Quasar Engine"
		});
	}

	static function onError(_code:Int, _message:String):Void
		trace('Error! $_code : $_message');

	static function onDisconnected(_code:Int, _message:String):Void
		trace('Disconnected! $_code : $_message');

	public static function initialize():Void
	{
		Thread.create(() ->
		{
			new DiscordClient();
		});

		trace("Discord Client initialized");
	}

	public static function changePresence(details:String, state:Null<String>, ?smallImageKey:String, ?hasStartTimestamp:Bool, ?endTimestamp:Float):Void
	{
		var startTimestamp:Float = if (hasStartTimestamp) Date.now().getTime() else 0;

		if (endTimestamp > 0)
			endTimestamp = startTimestamp + endTimestamp;

		DiscordRpc.presence({
			details: details,
			state: state,
			largeImageKey: 'icon',
			largeImageText: "Quasar Engine",
			smallImageKey: smallImageKey,
			startTimestamp: Std.int(startTimestamp / 1000),
			endTimestamp: Std.int(endTimestamp / 1000)
		});
	}
}
#end
