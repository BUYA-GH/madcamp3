package;

import haxe.rtti.CType.Abstractdef;
import lime.utils.Assets;

using StringTools;

class CoolUtil
{
	public static var difficultyArray:Array<String> = ['EASY', 'NORMAL', "HARD"];

	public static function initSonglist(path:String):Array<SongMetadata>
	{
		var songinfo:Array<String> = Assets.getText(path).trim().split('\n');
		var songs:Array<SongMetadata> = [];
		for (i in 0...songinfo.length)
		{
			var parsedInfo:Array<String> = songinfo[i].split(' ');
			songs.push(new SongMetadata(parsedInfo[0], parsedInfo[1], Std.parseInt(parsedInfo[2])));
		}
		return songs;
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}
}
