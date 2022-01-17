package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Note extends FlxSprite
{
	public var noteSpeed:Float = 1000;
	public var longFrameChecker:Int = 0;

	public var startKey:Int;
	public var type:Int;

	public var isLong:Bool;
	public var isLongMiddle:Bool;
	public var longKilled:Bool = false;
	public var isCounted:Bool = false;

	public function new(x:Float, y:Float, startKey:Int, type:Int, speed:Float, isLong:Bool, isLongMiddle:Bool)
	{
		// super(x, y);
		super(x + 85 * ((type - 1) / 2), y);

		this.startKey = startKey;
		this.type = type;
		this.noteSpeed = speed;
		this.isLong = isLong;
		this.isLongMiddle = isLongMiddle;

		if (!isLong)
		{
			if (type > 4)
			{
				loadGraphic('assets/images/white_yellow_note.png', false, 85, 20);
			}
			else
			{
				loadGraphic('assets/images/white_green_note.png', false, 85, 20);
			}
			setGraphicSize(85 * type, 20);
		}
		else
		{
			if (type > 4)
			{
				loadGraphic('assets/images/yellow_long.png', false, 85, 20);
			}
			else
			{
				loadGraphic('assets/images/yellow_long.png', false, 85, 20);
			}
			setGraphicSize(85 * type, Std.int((speed * FlxG.elapsed) + 1));
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		velocity.set(noteSpeed, 0);
		velocity.rotate(FlxPoint.weak(), 90);
	}
}
