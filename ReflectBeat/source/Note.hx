package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Note extends FlxSprite
{
	var noteSpeed:Float = 1000;
	var canPress:Bool;

	public var startKey:Int;
	public var type:Int;

	public function new(x:Float, y:Float, startKey:Int, type:Int)
	{
		super(x, y);
		this.startKey = startKey;
		this.type = type;

		makeGraphic(85 * type, 20, FlxColor.BLACK);

		width = 85;
		height = 20;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		velocity.set(noteSpeed, 0);
		velocity.rotate(FlxPoint.weak(), 90);
	}
}
