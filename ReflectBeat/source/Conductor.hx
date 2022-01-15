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

	var songInfo:SongData;
	var secLength:Int;
	var secIndex:Int = 0;

	public var noteNum:Int = 0;

	public var isStart:Bool = false;
	public var canMakeNote:Bool = false;

	public var curTime:Float = 0.0;
	public var curSecTime:Float = 0.0;
	public var curBeat:Int;

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
		if (curSecTime <= curTime && FlxG.sound.music == null)
		{
			//trace(songname.toLowerCase());
			//trace(Paths.music(songname.toLowerCase() + "/song"));
			//FlxG.sound.playMusic("assets/music/" + songname.toLowerCase() + "/song.mp3", 0);
			FlxG.sound.playMusic(Paths.music(songname.toLowerCase() + "/song"), 1);
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
