package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxUISprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import haxe.Timer;

// import js.html.audio.ScriptProcessorNode;
class PlayState extends FlxState
{
	var songname:String;
	var difficulty:Int;
	var noteNum:Int;
	var oneNoteScore:Float;
	var longnote:Array<Int> = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

	public var longnoteCheckFrame:Int = 0;
	public var longnoteChecker:Array<Int> = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

	var score:Float = 0;
	var combo:Int = 0;
	var maxCombo:Int = 0;
	var criticalNum:Int = 0;
	var fastNum:Int = 0;
	var lateNum:Int = 0;
	var missNum:Int = 0;

	var background:FlxSprite;
	var backgroundWidth:Int = 1020;
	var backgroundHeight:Int = 720;

	var hitBox:FlxSprite;
	var hitBoxSize:Int = 20;
	var hitBoxPos:Int = 680;

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
	var criticalBoxSize:Int;
	var criticalBoxPos:Int;

	var fastBox:FlxSprite;
	var fastBoxSize:Int;
	var fastBoxPos:Int;

	var lateBox:FlxSprite;
	var lateBoxSize:Int;
	var lateBoxPos:Int;

	var debugText:FlxText;
	var scoreText:FlxText;
	var maxComboText:FlxText;
	var comboText:FlxText;

	var upperHud:FlxSprite;
	var songInfoText:FlxText;
	var songProgressBar:FlxBar;

	var keyInput:Array<Bool>;

	var startNotePos:Float = 90;
	var conductor:Conductor;

	var tickSound:FlxSound;

	var speed:Float;
	var isAuto:Bool;

	public function new(songname:String, difficulty:Int, speed:Float, isAuto:Bool)
	{
		super();
		this.songname = songname;
		this.difficulty = difficulty;
		this.speed = speed;
		this.isAuto = isAuto;
	}

	override public function create()
	{
		noteWidth = Std.int(backgroundWidth / 12);

		background = new FlxSprite(0, 0).loadGraphic(Paths.image('play_state'), backgroundWidth, backgroundHeight);
		add(background);

		criticalBoxSize = Std.int(speed / 24);
		fastBoxSize = lateBoxSize = Std.int(criticalBoxSize / 2);

		criticalBoxPos = Std.int(hitBoxPos - 3 * (criticalBoxSize / 4));
		criticalBox = new FlxSprite(startNotePos, criticalBoxPos).makeGraphic(backgroundWidth, criticalBoxSize, FlxColor.TRANSPARENT);
		add(criticalBox);

		fastBoxPos = Std.int(criticalBoxPos - fastBoxSize);
		fastBox = new FlxUISprite(startNotePos, fastBoxPos).makeGraphic(backgroundWidth, fastBoxSize, FlxColor.TRANSPARENT);
		add(fastBox);

		lateBoxPos = Std.int(criticalBoxPos + criticalBoxSize);
		lateBox = new FlxUISprite(startNotePos, lateBoxPos).makeGraphic(backgroundWidth, lateBoxSize, FlxColor.TRANSPARENT);
		add(lateBox);

		upperMissBoxPos = Std.int(fastBoxPos - upperMissBoxSize);
		upperMissBox = new FlxUISprite(startNotePos, upperMissBoxPos).makeGraphic(backgroundWidth, upperMissBoxSize, FlxColor.TRANSPARENT);
		add(upperMissBox);

		hitBox = new FlxSprite(startNotePos, hitBoxPos - (hitBoxSize / 2)).loadGraphic("assets/images/JudgeLaser.png", backgroundWidth, hitBoxSize);
		add(hitBox);

		if (!isAuto)
		{
			underLine = new FlxSprite(startNotePos, lateBoxPos + 21).makeGraphic(backgroundWidth, underLineSize, FlxColor.BLACK);
		}
		else
		{
			underLine = new FlxSprite(startNotePos, 680 + 11).makeGraphic(backgroundWidth, underLineSize, FlxColor.BLACK);
		}
		add(underLine);

		noteGroup = new FlxTypedGroup<Note>();
		add(noteGroup);

		judgeGroup = new FlxTypedGroup<FlxSprite>();
		add(judgeGroup);
		for (i in (0...12))
		{
			var xJudgePoint:Int = Std.int(startNotePos + i * noteWidth + (noteWidth / 2) - (120 / 2));
			var yJudgePoint:Int = Std.int(hitBoxPos + (hitBoxSize / 2) - (120 / 2));

			var judgeAnim = new FlxSprite(xJudgePoint, yJudgePoint).loadGraphic("assets/images/judge.png", true, 120, 120);
			judgeAnim.animation.add("crit", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], 24, false);
			judgeGroup.add(judgeAnim);
		}
		
		conductor = new Conductor(songname, difficulty, speed);
		noteNum = conductor.noteNum;
		oneNoteScore = 10000000 / noteNum;

		upperHud = new FlxSprite(0, 0).loadGraphic('assets/images/upper_hud.png', false, 1280, 151);
		add(upperHud);

		songInfoText = new FlxText(229, 15, 822, "", 20);
		// songInfoText.centerOffsets(true);
		songInfoText.alignment = "center";
		songInfoText.text = conductor.songInfo.title + " / " + conductor.songInfo.artist;
		add(songInfoText);

		songProgressBar = new FlxBar(229, 70, LEFT_TO_RIGHT, 822, 5);
		songProgressBar.createFilledBar(0xff1a33ff, 0xff74dfff, false, FlxColor.TRANSPARENT);
		songProgressBar.value = 0;
		add(songProgressBar);

		scoreText = new FlxText(1100, 110, 170, "0", 5);
		scoreText.setFormat(Paths.font("DREAMS.ttf"), 5, FlxColor.WHITE, RIGHT);
		add(scoreText);

		maxComboText = new FlxText(1150, 155, 130, "0", 3);
		maxComboText.setFormat(Paths.font("DREAMS.ttf"), 3, FlxColor.WHITE, RIGHT);
		add(maxComboText);

		debugText = new FlxText(1110, 300, 0, "", 15);
		comboText = new FlxText(1110, 360, 0, "0", 15);

		add(debugText);
		add(comboText);

		tickSound = FlxG.sound.load('assets/sounds/tick.wav', 1, false);

		longnoteCheckFrame = Std.int(30 / (FlxG.elapsed * conductor.songInfo.bpm)) + 1;

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		debugText.text = Std.string(elapsed);

		if (conductor.isStart == 0)
		{
			conductor.playSong();
		}

		if( conductor.isStart == 1)
		{
			if (conductor.curSecTime <= conductor.curTime)
			{				
				var notes = conductor.readSection();
				songProgressBar.value = (conductor.secIndex / conductor.secLength) * 100;

				if (notes.charAt(0) == "E")
				{
					songProgressBar.value = 100;
					Timer.delay(function()
					{
						gotoScoreState();
					}, 3000);
				}
				else
				{
					for (i in 0...12)
					{
						var noteInput:String = notes.charAt(i);

						if (noteInput != "0")
						{
							switch (noteInput)
							{
								case "!":
									if (longnote[i] == 0)
									{
										noteGroup.add(new Note(startNotePos + (85 * i), 0, i, 1, speed, true, false));
										longnote[i] = 1;
									}
									else
										longnote[i] = 0;

								case "@":
									if (longnote[i] == 0)
									{
										noteGroup.add(new Note(startNotePos + (85 * i), 0, i, 2, speed, true, false));
										longnote[i] = 2;
									}
									else
										longnote[i] = 0;

								case "#":
									if (longnote[i] == 0)
									{
										noteGroup.add(new Note(startNotePos + (85 * i), 0, i, 3, speed, true, false));
										longnote[i] = 3;
									}
									else
										longnote[i] = 0;

								case "$":
									if (longnote[i] == 0)
									{
										noteGroup.add(new Note(startNotePos + (85 * i), 0, i, 4, speed, true, false));
										longnote[i] = 4;
									}
									else
										longnote[i] = 0;

								case "%":
									if (longnote[i] == 0)
									{
										noteGroup.add(new Note(startNotePos + (85 * i), 0, i, 5, speed, true, false));
										longnote[i] = 5;
									}
									else
										longnote[i] = 0;

								case "^":
									if (longnote[i] == 0)
									{
										noteGroup.add(new Note(startNotePos + (85 * i), 0, i, 6, speed, true, false));
										longnote[i] = 6;
									}
									else
										longnote[i] = 0;

								case "&":
									if (longnote[i] == 0)
									{
										noteGroup.add(new Note(startNotePos + (85 * i), 0, i, 7, speed, true, false));
										longnote[i] = 7;
									}
									else
										longnote[i] = 0;

								case "*":
									if (longnote[i] == 0)
									{
										noteGroup.add(new Note(startNotePos + (85 * i), 0, i, 8, speed, true, false));
										longnote[i] = 8;
									}
									else
										longnote[i] = 0;

								case "(":
									if (longnote[i] == 0)
									{
										noteGroup.add(new Note(startNotePos + (85 * i), 0, i, 9, speed, true, false));
										longnote[i] = 9;
									}
									else
										longnote[i] = 0;

								default:
									noteGroup.add(new Note(startNotePos + (85 * i), 0, i, Std.parseInt(noteInput), speed, false, false));
							}
						}
					}
				}
			}
			for (i in 0...12)
			{
				if (longnote[i] != 0)
				{
					noteGroup.add(new Note(startNotePos + (85 * i), 0, i, longnote[i], speed, true, true));
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

		var long0:Bool = FlxG.keys.pressed.Q;
		var long1:Bool = FlxG.keys.pressed.W;
		var long2:Bool = FlxG.keys.pressed.E;
		var long3:Bool = FlxG.keys.pressed.R;
		var long4:Bool = FlxG.keys.pressed.T;
		var long5:Bool = FlxG.keys.pressed.Y;
		var long6:Bool = FlxG.keys.pressed.U;
		var long7:Bool = FlxG.keys.pressed.I;
		var long8:Bool = FlxG.keys.pressed.O;
		var long9:Bool = FlxG.keys.pressed.P;
		var long10:Bool = FlxG.keys.pressed.LBRACKET;
		var long11:Bool = FlxG.keys.pressed.RBRACKET;
		keyInput = [
			 key0,  key1,  key2,  key3,  key4,  key5,  key6,  key7,  key8,  key9,  key10, key11,
			long0, long1, long2, long3, long4, long5, long6, long7, long8, long9, long10, long11
		];
		// var back:Bool = FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSLASH;
		// conductor.prevTime = conductor.curTime;
		conductor.curTime += elapsed;

		// for short notes & start of long notes
		// FlxG.overlap(upperMissBox, noteGroup, checkMiss);
		FlxG.overlap(fastBox, noteGroup, checkFast);
		FlxG.overlap(criticalBox, noteGroup, checkCritical);
		FlxG.overlap(hitBox, noteGroup, destroyLong);
		FlxG.overlap(lateBox, noteGroup, checkLate);
		FlxG.overlap(underLine, noteGroup, missDestroy);

		// for middle part of long notes
	}

	function checkMiss(missBox:FlxSprite, note:Note)
	{
		var startKey:Int = note.startKey;
		var size:Int = note.type;

		for (i in startKey...(startKey + size))
		{
			if (!note.isLongMiddle)
			{
				if (keyInput[i])
				{
					updateScore("Miss");
					if (note.isLong)
					{
						longnoteChecker[startKey] = 0;
					}
					note.kill();
					noteGroup.remove(note);
					break;
				}
			}
		}
	}

	function checkFast(fastBox:FlxSprite, note:Note)
	{
		var startKey:Int = note.startKey;
		var size:Int = note.type;
		var longPressed:Bool = false;

		if (!note.isLongMiddle)
		{
			for (i in startKey...(startKey + size))
			{
				if (keyInput[i])
				{
					if (note.isLong)
					{
						longnoteChecker[startKey] = 0;
					}

					score += oneNoteScore / 2;
					combo++;
					fastNum++;
					tickSound.play(true);
          
          judgeGroup.members[i].setGraphicSize(120 * size, 120);
					judgeGroup.members[i].animation.stop();
					judgeGroup.members[i].animation.play("crit");
          
          updateScore("Fast");
					note.kill();
					noteGroup.remove(note);
          break;
        }
			}
		}
	}

	function checkCritical(criticalBox:FlxSprite, note:Note)
	{
		var startKey:Int = note.startKey;
		var size:Int = note.type;
		var longPressed:Bool = false;

		if (!note.isLongMiddle)
		{
			for (i in startKey...(startKey + size))
			{
				if (keyInput[i])
				{
					if (note.isLong)
					{
						longnoteChecker[startKey] = 0;
					}

					score += oneNoteScore;
					combo++;
					criticalNum++;
					tickSound.play(true);

					judgeGroup.members[i].setGraphicSize(120 * size, 120);
					judgeGroup.members[i].animation.stop();
					judgeGroup.members[i].animation.play("crit");

					updateScore("Critical");
					note.kill();
					noteGroup.remove(note);
					break;
				}
			}
		}
		else
		{
			if (!note.isCounted)
			{
				if (longnoteChecker[startKey] < longnoteCheckFrame)
				{
					longnoteChecker[startKey]++;
				}
				else
				{
					longnoteChecker[startKey] = 0;
				}
				for (i in startKey...(startKey + size))
				{
					if (keyInput[i + 12])
					{
						note.longKilled = true;
						longPressed = true;
						break;
					}
				}

				if (longnoteChecker[startKey] == 0 && longPressed)
				{
					updateScore("Critical");
					score += oneNoteScore;
					combo++;
					criticalNum++;
				}

				note.isCounted = true;
			}
		}
	}

	function destroyLong(criticalBox:FlxSprite, note:Note)
	{
		if (note.isLongMiddle && note.longKilled)
		{
			note.kill();
			noteGroup.remove(note);
		}
	}

	function checkLate(lateBox:FlxSprite, note:Note)
	{
		var startKey:Int = note.startKey;
		var size:Int = note.type;

		if (!note.isLongMiddle)
		{
			for (i in startKey...(startKey + size))
			{
				if (keyInput[i])
				{
					if (note.isLong)
					{
						longnoteChecker[startKey] = 0;
					}

					score += oneNoteScore / 2;
					combo++;
					lateNum++;
					tickSound.play(true);
					judgeGroup.members[i].setGraphicSize(120 * size, 120);
					judgeGroup.members[i].animation.stop();
					judgeGroup.members[i].animation.play("crit");

					updateScore("Late");
					note.kill();
					noteGroup.remove(note);
					break;
				}
			}
		}
	}

	function missDestroy(underLine:FlxSprite, note:Note)
	{
		if (!note.isLongMiddle)
		{
			if (isAuto)
			{
				tickSound.play(true);

				judgeGroup.members[Std.int(note.startKey + (note.type / 2))].animation.stop();
				judgeGroup.members[Std.int(note.startKey + (note.type / 2))].animation.play("crit");
				score += oneNoteScore;
				combo++;
				criticalNum++;

				updateScore("Critical");
			}
			else
			{
				if (combo > maxCombo)
				{
					maxCombo = combo;
				}
				combo = 0;
				missNum++;
				updateScore("Miss");
			}
		}
		else
		{
			if (longnoteChecker[note.startKey] == 0)
			{
				if (isAuto)
				{
					score += oneNoteScore;
					combo++;
					criticalNum++;

					updateScore("Critical");
				}
				else
				{
					if (combo > maxCombo)
					{
						maxCombo = combo;
					}
					combo = 0;
					missNum++;

					updateScore("Miss");
				}
			}
		}
		note.kill();
		noteGroup.remove(note);
	}

	function updateScore(result:String)
	{
		//debugText.text = result;
		if (noteNum == criticalNum)
			score = 10000000;
		scoreText.text = Std.string(Std.int(score));
		comboText.text = Std.string(combo);
	}

	function gotoScoreState()
	{
		FlxG.switchState(new ScoreState(Std.int(score), criticalNum, fastNum, lateNum, missNum, maxCombo));
	}
}
