package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxe.macro.Compiler.IncludePosition;

// import js.lib.Intl;
class ScoreState extends FlxState
{
	var score:Int;
	var critical:Int;
	var fast:Int;
	var late:Int;
	var miss:Int;
	var maxCombo:Int;

	var displayScore:Int = 0;
	var increasing:Int = 0;
	var frameCount:Int = 0;
	var scoreDisplayed:Bool = false;

	var scoreText:FlxText;
	var criticalText:FlxText;
	var fastText:FlxText;
	var lateText:FlxText;
	var missText:FlxText;
	var maxComboText:FlxText;

	public function new(score:Int, critical:Int, fast:Int, late:Int, miss:Int, maxCombo:Int)
	{
		super();
		this.score = score;
		this.critical = critical;
		this.fast = fast;
		this.late = late;
		this.miss = miss;
		this.maxCombo = maxCombo;
	}

	override public function create()
	{

		FlxG.sound.pause();
		FlxG.sound.music = null;

		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('score_state'));
		add(bg);

		scoreText = new FlxText(500, 100, "0");
		scoreText.setFormat(Paths.font("DREAMS.ttf"), 10, FlxColor.WHITE);
		add(scoreText);

		criticalText = new FlxText(500, 150, Std.string(critical));
		criticalText.setFormat(Paths.font("DREAMS.ttf"), 10, FlxColor.WHITE);
		add(criticalText);

		fastText = new FlxText(500, 200, Std.string(fast));
		fastText.setFormat(Paths.font("DREAMS.ttf"), 10, FlxColor.WHITE);
		add(fastText);

		lateText = new FlxText(500, 250, Std.string(late));
		lateText.setFormat(Paths.font("DREAMS.ttf"), 10, FlxColor.WHITE);
		add(lateText);

		missText = new FlxText(500, 300, Std.string(miss));
		missText.setFormat(Paths.font("DREAMS.ttf"), 10, FlxColor.WHITE);
		add(missText);

		maxComboText = new FlxText(500, 350, Std.string(maxCombo));
		maxComboText.setFormat(Paths.font("DREAMS.ttf"), 10, FlxColor.WHITE);
		add(maxComboText);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;
		if (scoreDisplayed)
		{
			if (pressedEnter)
				FlxG.switchState(new SelectState());
		}
		else
		{
			if (pressedEnter)
			{
				scoreText.text = Std.string(score);
				scoreDisplayed = true;
			}
			else
			{
				displayScore += Std.int(score / 60);
				scoreText.text = Std.string(displayScore);
				frameCount++;
				if (frameCount == 60)
				{
					scoreDisplayed = true;
				}
			}
		}
		super.update(elapsed);
	}
}
