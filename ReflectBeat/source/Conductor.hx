package;

import flixel.FlxG;
import haxe.Json;
import lime.utils.Assets;

using StringTools;

typedef SongData =
{
	var title:String;
	var artist:String;
	var difficulty:String;
	var level:Int;
	var bpm:Float;
	var sync:Float;

	var sections:Array<String>;
}

class Conductor
{
	inline public static var SOUND_EXT = "mp3";

	var songInfo:SongData;
	var secLength:Int;
	var secIndex:Int = 0;

	public var isStart:Bool = false;
	public var canMakeNote:Bool = false;

	public var prevTime:Float = 0.0;
	public var curTime:Float = 0.0;
	public var curSecTime:Float = 0.0;
	public var curBeat:Int;

	public function new()
	{
		var rawJson = Assets.getText('assets/data/diavolo/hard.json').trim();

		while (!rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
		}

		songInfo = cast Json.parse(rawJson);
		secLength = songInfo.sections.length;
		curSecTime = songInfo.sync;
	}

	public function playSong()
	{
		if (curSecTime <= curTime && FlxG.sound.music == null)
		{
			FlxG.sound.playMusic("assets/music/diavolo/song.mp3", 1, false);
			isStart = true;
		}
	}

	public function readSection()
	{
		var read:String = "";
		curTime = curTime - curSecTime;
		while (true)
		{
			read = songInfo.sections[secIndex++];

			if (read.charAt(0) == "-")
			{
				curBeat = Std.parseInt(read.substr(1));
				curSecTime = (60 / songInfo.bpm) * (4 / curBeat);
			}
			else
			{
				break;
			}
		}
		if (secIndex >= secLength)
			isStart = false;
		return read;
	}
}
