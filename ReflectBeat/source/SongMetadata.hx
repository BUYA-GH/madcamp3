package;

class SongMetadata
{
	public var songname:String = "";
	public var composer:String = "";
	public var bpm:Int = 0;

	public function new(songname:String, composer:String, bpm:Int)
	{
		this.songname = songname;
		this.composer = composer;
		this.bpm = bpm;
	}
}
