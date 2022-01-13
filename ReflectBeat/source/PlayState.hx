package;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	var tempLine:FlxSprite;
	var tempHitBox:FlxSprite;
	var tempNote:FlxTypedGroup<Note>;

	var startNotePos:Float = 90;
	var conductor:Conductor;

	override public function create()
	{
		tempLine = new FlxSprite(startNotePos, 0).makeGraphic(1020, 720, FlxColor.WHITE);
		add(tempLine);

		tempHitBox = new FlxSprite(startNotePos, 700).makeGraphic(1020, 20, FlxColor.LIME);
		add(tempHitBox);

		tempNote = new FlxTypedGroup<Note>();
		add(tempNote);
		
		conductor = new Conductor();

		FlxG.sound.music = null;
		if(FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(AssetPaths.song__mp3, 1, false);
		}

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if(conductor.isStart)
		{
			conductor.curTime += elapsed;
			if (conductor.curSecTime <= conductor.curTime)
			{
				var notes = conductor.readSection();

				for (i in 0...12)
				{
					if (notes.charAt(i) != "0")
					{
						tempNote.add(new Note(startNotePos + (85 * i), 0, Std.parseInt(notes.charAt(i))));
					}
				}
			}
		}

		FlxG.overlap(tempHitBox, tempNote, noteDestroy);
	}

	function noteDestroy(hitbox:FlxSprite, note:Note)
	{
		note.kill();
	}
}
