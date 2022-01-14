package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxUISprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	var background:FlxSprite;
	var backgroundWidth:Int = 1020;
	var backgroundHeight:Int = 720;

	var hitBox:FlxSprite;
	var hitBoxSize:Int = 20;
	var hitBoxPos:Int = 670;

	var underLine:FlxSprite;
	var underLineSize:Int = 1;

	var noteGroup:FlxTypedGroup<Note>;
	var noteWidth:Int;
	var noteHeight:Int = 20;

	var judgeGroup:FlxTypedGroup<FlxSprite>;

	var upperMissBox:FlxSprite;
	var upperMissBoxSize:Int = 40;
	var upperMissBoxPos:Int;

	var criticalBox:FlxSprite;
	var criticalBoxSize:Int = 40;
	var criticalBoxPos:Int;

	var fastBox:FlxSprite;
	var fastBoxSize:Int = 20;
	var fastBoxPos:Int;

	var lateBox:FlxSprite;
	var lateBoxSize:Int = 20;
	var lateBoxPos:Int;

	var score:String;
	var combo:Int = 0;

	var debugText:FlxText;
	var comboText:FlxText;

	var keyInput:Array<Bool>;

	var startNotePos:Float = 90;
	var conductor:Conductor;

	override public function create()
	{
		noteWidth = Std.int(backgroundWidth / 12);

		background = new FlxSprite(startNotePos, 0).makeGraphic(backgroundWidth, backgroundHeight, FlxColor.GRAY);
		add(background);

		criticalBoxPos = Std.int(hitBoxPos + (hitBoxSize / 2) - (criticalBoxSize / 2) - (noteHeight / 2));
		criticalBox = new FlxUISprite(startNotePos, criticalBoxPos).makeGraphic(backgroundWidth, criticalBoxSize, FlxColor.TRANSPARENT);
		// makeGraphic(backgroundWidth, criticalBoxSize, FlxColor.GREEN);
		// loadGraphic("assets/images/JudgeLaser.png"
		// criticalBox = new FlxUISprite(startNotePos, criticalBoxPos).makeGraphic(backgroundWidth, criticalBoxSize, FlxColor.TRANSPARENT);
		add(criticalBox);

		fastBoxPos = Std.int(criticalBoxPos - fastBoxSize);
		fastBox = new FlxUISprite(startNotePos, fastBoxPos).makeGraphic(backgroundWidth, fastBoxSize, FlxColor.TRANSPARENT);
		// fastBox = new FlxUISprite(startNotePos, fastBoxPos).makeGraphic(backgroundWidth, fastBoxSize,oFlxColor.TRANSPARENT);
		add(fastBox);

		lateBoxPos = Std.int(criticalBoxPos + criticalBoxSize);
		lateBox = new FlxUISprite(startNotePos, lateBoxPos).makeGraphic(backgroundWidth, lateBoxSize, FlxColor.TRANSPARENT);
		// lateBox = new FlxUISprite(startNotePos, lateBoxPos).makeGraphic(backgroundWidth, lateBoxSize, FlxColor.TRANSPARENT);
		add(lateBox);

		upperMissBoxPos = Std.int(fastBoxPos - upperMissBoxSize);
		// upperMissBox = new FlxUISprite(startNotePos, upperMissBoxPos).makeGraphic(backgroundWidth, upperMissBoxSize, FlxColor.GRAY);
		upperMissBox = new FlxUISprite(startNotePos, upperMissBoxPos).makeGraphic(backgroundWidth, upperMissBoxSize, FlxColor.TRANSPARENT);
		add(upperMissBox);

		hitBox = new FlxSprite(startNotePos, hitBoxPos).loadGraphic("assets/images/JudgeLaser.png", backgroundWidth, hitBoxSize);
		add(hitBox);

		underLine = new FlxSprite(startNotePos, backgroundHeight - underLineSize).makeGraphic(backgroundWidth, underLineSize, FlxColor.BLACK);
		//underLine = new FlxSprite(startNotePos, 680).makeGraphic(backgroundWidth, underLineSize, FlxColor.BLACK);
		add(underLine);

		noteGroup = new FlxTypedGroup<Note>();
		add(noteGroup);

		judgeGroup = new FlxTypedGroup<FlxSprite>();
		add(judgeGroup);
		for (i in (0...12))
		{
			var xJudgePoint:Int = Std.int(startNotePos + i*noteWidth + (noteWidth/2) - (120/2));
			var yJudgePoint:Int = Std.int(hitBoxPos + (hitBoxSize/2) - (120/2));
			var judgeAnim = new FlxSprite(xJudgePoint, yJudgePoint).loadGraphic("assets/images/judge.png", true, 120, 120);
			judgeAnim.animation.add("crit", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], 24, false);
			// judgeAnim.animation.add("near", [7, 8, 9, 10, 11, 12, 13], 30, false);
			judgeGroup.add(judgeAnim);
		}

		conductor = new Conductor();
		debugText = new FlxText(1110, 300, 0, "", 15);
		comboText = new FlxText(1110, 330, 0, "0", 15);

		add(debugText);
		add(comboText);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

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
						noteGroup.add(new Note(startNotePos + (85 * i), 0, i, Std.parseInt(notes.charAt(i))));
					}
				}
			}
		}

		// set keys
		var key0:Bool = FlxG.keys.justPressed.Q;
		var key1:Bool = FlxG.keys.justPressed.W;
		var key2:Bool = FlxG.keys.justPressed.E;
		var key3:Bool = FlxG.keys.justPressed.R;
		var key4:Bool = FlxG.keys.justPressed.T;
		var key5:Bool = FlxG.keys.justPressed.Y;
		var key6:Bool = FlxG.keys.justPressed.U;
		var key7:Bool = FlxG.keys.justPressed.I;
		var key8:Bool = FlxG.keys.justPressed.O;
		var key9:Bool = FlxG.keys.justPressed.P;
		var key10:Bool = FlxG.keys.justPressed.LBRACKET;
		var key11:Bool = FlxG.keys.justPressed.RBRACKET;
		keyInput = [key0, key1, key2, key3, key4, key5, key6, key7, key8, key9, key10, key11];
		// var back:Bool = FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSLASH;

		// conductor.prevTime = conductor.curTime;
		conductor.curTime += elapsed;
		//FlxG.overlap(upperMissBox, noteGroup, checkMiss);
		FlxG.overlap(fastBox, noteGroup, checkFast);
		FlxG.overlap(criticalBox, noteGroup, checkCritical);
		FlxG.overlap(lateBox, noteGroup, checkLate);
		FlxG.overlap(underLine, noteGroup, missDestroy);
		/*
			if (back)
			{
				remove(this);
		}*/
	}

	function checkMiss(missBox:FlxSprite, note:Note)
	{
		var startKey:Int = note.startKey;
		var size:Int = note.type;

		var pressed:Bool = false;
		for (i in startKey...(startKey + size))
		{
			if (keyInput[i])
			{
				pressed = true;
				break;
			}
		}

		if (pressed)
		{
			updateScore("Miss");
			note.kill();
			noteGroup.remove(note);
		}
	}

	function checkFast(fastBox:FlxSprite, note:Note)
	{
		var startKey:Int = note.startKey;
		var size:Int = note.type;

		var pressed:Bool = false;
		for (i in startKey...(startKey + size))
		{
			if (keyInput[i])
			{
				pressed = true;
				judgeGroup.members[i].animation.stop();
				judgeGroup.members[i].animation.play("crit");
				break;
			}
		}

		if (pressed)
		{
			updateScore("Fast");
			combo++;
			note.kill();
			noteGroup.remove(note);
		}
	}

	function checkCritical(criticalBox:FlxSprite, note:Note)
	{
		var startKey:Int = note.startKey;
		var size:Int = note.type;

		var pressed:Bool = false;
		for (i in startKey...(startKey + size))
		{
			if (keyInput[i])
			{
				pressed = true;
				judgeGroup.members[i].animation.stop();
				judgeGroup.members[i].animation.play("crit");
				break;
			}
		}

		if (pressed)
		{
			updateScore("Critical");
			combo++;
			note.kill();
			noteGroup.remove(note);
		}
	}

	function checkLate(lateBox:FlxSprite, note:Note)
	{
		var startKey:Int = note.startKey;
		var size:Int = note.type;

		var pressed:Bool = false;
		for (i in startKey...(startKey + size))
		{
			if (keyInput[i])
			{
				pressed = true;
				judgeGroup.members[i].animation.stop();
				judgeGroup.members[i].animation.play("crit");
				break;
			}
		}

		if (pressed)
		{
			updateScore("Late");
			combo++;
			note.kill();
			noteGroup.remove(note);
		}
	}

	function missDestroy(underLine:FlxSprite, note:Note)
	{
		//judgeGroup.members[Std.int(note.startKey + (note.type / 2))].animation.stop();
		//judgeGroup.members[Std.int(note.startKey + (note.type/2))].animation.play("crit");
		note.kill();
		updateScore("Miss");
		noteGroup.remove(note);
	}

	function updateScore(result:String)
	{
		debugText.text = result;
		comboText.text = Std.string(combo);
	}
}
