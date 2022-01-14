package;

import flixel.FlxSprite;
import flixel.text.FlxText;

class SongIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public var songInfo:FlxText;

	public function new(composer:String, bpm:Int)
	{
		super();
		new FlxText(composer + " " + Std.string(bpm));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
