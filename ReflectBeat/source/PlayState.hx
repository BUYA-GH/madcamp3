package;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	var tempLine:FlxSprite;
	var tempHitBox:FlxSprite;
	var tempJudgeBox:FlxSprite;
	var tempNote:FlxTypedGroup<Note>;

	var debugText:FlxText;

	var startNotePos:Float = 90;
	var conductor:Conductor;

	override public function create()
	{
		tempLine = new FlxSprite(startNotePos, 0).makeGraphic(1020, 720, FlxColor.WHITE);
		add(tempLine);

		tempJudgeBox = new FlxSprite(startNotePos, 670).makeGraphic(1020, 20, FlxColor.YELLOW);
		add(tempJudgeBox);

		tempHitBox = new FlxSprite(startNotePos, 700).makeGraphic(1020, 20, FlxColor.LIME);
		add(tempHitBox);

		tempNote = new FlxTypedGroup<Note>();
		add(tempNote);
		
		debugText = new FlxText(1110, 300, 0, "", 15);
		add(debugText);

		conductor = new Conductor();
		

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		debugText.text = Std.string(elapsed);
		
		if (!conductor.isStart)
		{
			conductor.playSong();
		} 
		else
		{
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
		//conductor.prevTime = conductor.curTime;
		conductor.curTime += elapsed;
		FlxG.overlap(tempHitBox, tempNote, noteDestroy);
	}

	function noteDestroy(hitbox:FlxSprite, note:Note)
	{
		note.kill();
	}
}
