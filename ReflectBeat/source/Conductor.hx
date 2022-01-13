package;

import flixel.FlxG;
import lime.utils.Assets;
import haxe.Json;

using StringTools;

typedef SongData = {
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

    public var isStart:Bool = true;
	public var canMakeNote:Bool = false;

    public var curTime:Float = 0.0;
	public var curSecTime:Float = 0.0;
    public var curBeat:Int;
	
    public function new()
    {
		var rawJson = Assets.getText('assets/data/diavolo/chart.json').trim();

        while(!rawJson.endsWith("}"))
        {
			rawJson = rawJson.substr(0, rawJson.length - 1);
        }
        
		songInfo = cast Json.parse(rawJson);
        secLength = songInfo.sections.length;
    }

    public function playSong()
    {
        
    }

    public function readSection()
    {
		var read:String = "";
        while(true)
        {
			read = songInfo.sections[secIndex++];
            curTime = 0.0;

            if(read.charAt(0) == "-")
            {
                curBeat = Std.parseInt(read.substr(1));
                curSecTime = (60 / songInfo.bpm) * (4 / curBeat);
            }
            else
            {
                break;
            }
		}
        if(secIndex >= secLength) isStart = false;
        return read;
    }
}