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

	var songname:String;
	var difficulty:Int;

	var scorePath:String;

	public var songInfo:SongData;
	public var secLength:Int;
	public var secIndex:Int = 0;

	public var noteNum:Int = 0;

	public var isStart:Int = 0;
	public var canMakeNote:Bool = false;

	public var curTime:Float = 0.0;
	public var curSecTime:Float = 0.0;
	public var curBeat:Int;
	public var minusSecTime:Float;

	var tickTock:Bool = false;

	var notespeed:Float;

	public function new(songname:String, difficulty:Int, speed:Float)
	{
		this.songname = songname;
		this.difficulty = difficulty;
		this.notespeed = speed;

		if (difficulty == 0)
		{
			scorePath = Paths.json(songname.toLowerCase() + "/easy");
		}
		else if (difficulty == 1)
		{
			scorePath = Paths.json(songname.toLowerCase() + "/hard");
		}

		var rawJson = Assets.getText(scorePath).trim();

		while (!rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
		}

		songInfo = cast Json.parse(rawJson);
		secLength = songInfo.sections.length;
		curSecTime = (songInfo.sync / 1000) - (670 / notespeed);
		if (curSecTime < 0.0)
			minusSecTime = curSecTime;
		// trace(curSecTime);

		var read:String = "";
		var readIndex:Int = 0;
		while (true)
		{
			read = songInfo.sections[readIndex++];
			if (read.charAt(0) == "-")
				continue;
			else if (read == "E")
				break;

			for (i in 0...12)
			{
				if (read.charAt(i) != "0")
				{
					noteNum++;
				}
			}
		}
	}

	public function playSong()
	{
		// trace(curSecTime);
		// trace(curTime);


		if (FlxG.sound.music == null && curSecTime >= 0.0)
		{
			if (FlxG.sound.music == null)
			{
				FlxG.sound.playMusic(Paths.music(songname.toLowerCase() + "/song"), 1, false);
			}

			if (curSecTime <= curTime)
			{
				curTime = 0.0;
				curSecTime = 0.0;

				isStart = 1;
			}
		}

		else if (curSecTime <= curTime)
		{
			curTime = 0.0;
			curSecTime = 0.0;

			isStart = 1;
		}
	}

	public function playMinusSong()
	{
		// trace(curSecTime);
		// trace(curTime);

		if (FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(Paths.music(songname.toLowerCase() + "/song"), 1, false);
		}
	}

	public function readSection()
	{
		var read:String = "";

		while (true)
		{
			read = songInfo.sections[secIndex++];

			if (read.charAt(0) == "-")
			{
				curBeat = Std.parseInt(read.substr(1));
			}
			else
			{
				break;
			}
		}
		if (secIndex >= secLength)
			isStart = 2;

		curSecTime += ((60 / songInfo.bpm) * (4 / curBeat));
		return read;
	}
}
