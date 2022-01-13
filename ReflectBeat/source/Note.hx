package;

import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Note extends FlxSprite
{
    var noteSpeed:Float = 1000;
    var canPress:Bool;

    public function new(x:Float, y:Float, type:Int)
    {
        super(x, y);
		makeGraphic(85*type, 20, FlxColor.GRAY);
        
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