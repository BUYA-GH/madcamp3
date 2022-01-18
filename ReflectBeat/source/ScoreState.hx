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

	var scoreSprite:FlxSprite;
	var scoreTextTitle:FlxText;
	var scoreText:FlxText;

	var criticalSprite:FlxSprite;
	var criticalTextTitle:FlxText;
	var criticalText:FlxText;

	var fastSprite:FlxSprite;
	var fastTextTitle:FlxText;
	var fastText:FlxText;

	var lateSprite:FlxSprite;
	var lateTextTitle:FlxText;
	var lateText:FlxText;

	var missSprite:FlxSprite;
	var missTextTitle:FlxText;
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

		var scoreSpriteXPos = 520;
		var scoreSpriteYPos = 100;

		scoreSprite = new FlxSprite(scoreSpriteXPos, scoreSpriteYPos);
		scoreSprite.loadGraphic("assets/images/scoreText.png", false, 760, 120);
		add(scoreSprite);

		scoreTextTitle = new FlxText(scoreSpriteXPos + 40, scoreSpriteYPos + 42, 0, "SCORE", 10);
		scoreTextTitle.setFormat(Paths.font("DREAMS.ttf"), 10, FlxColor.BLACK);
		add(scoreTextTitle);

		scoreText = new FlxText(scoreSpriteXPos + 330, scoreSpriteYPos + 40, 0, "0", 13);
		scoreText.setFormat(Paths.font("DREAMS.ttf"), 13, FlxColor.WHITE, LEFT);
		add(scoreText);

		criticalSprite = new FlxSprite(FlxG.width - 370, scoreSpriteYPos + 130);
		criticalSprite.loadGraphic("assets/images/judgeScore.png", false, 370, 70);
		add(criticalSprite);

		criticalTextTitle = new FlxText(FlxG.width - 330, scoreSpriteYPos + 165, 0, "Critical", 15);
		criticalTextTitle.color = FlxColor.BLACK;
		add(criticalTextTitle);

		criticalText = new FlxText(scoreSpriteXPos + 585, scoreSpriteYPos + 153, 0, "0", 8);
		criticalText.setFormat(Paths.font("DREAMS.ttf"), 8, FlxColor.WHITE, LEFT);
		criticalText.text = Std.string(critical);
		add(criticalText);

		fastSprite = new FlxSprite(FlxG.width - 370, scoreSpriteYPos + 200);
		fastSprite.loadGraphic("assets/images/judgeScore.png", false, 370, 70);
		add(fastSprite);

		fastTextTitle = new FlxText(FlxG.width - 330, scoreSpriteYPos + 235, 0, "Fast", 15);
		fastTextTitle.color = FlxColor.BLACK;
		add(fastTextTitle);

		fastText = new FlxText(scoreSpriteXPos + 585, scoreSpriteYPos + 223, 0, "0", 8);
		fastText.setFormat(Paths.font("DREAMS.ttf"), 8, FlxColor.WHITE, LEFT);
		fastText.text = Std.string(fast);
		add(fastText);

		lateSprite = new FlxSprite(FlxG.width - 370, scoreSpriteYPos + 270);
		lateSprite.loadGraphic("assets/images/judgeScore.png", false, 370, 70);
		add(lateSprite);

		lateTextTitle = new FlxText(FlxG.width - 330, scoreSpriteYPos + 305, 0, "Late", 15);
		lateTextTitle.color = FlxColor.BLACK;
		add(lateTextTitle);

		lateText = new FlxText(scoreSpriteXPos + 585, scoreSpriteYPos + 293, 0, "0", 8);
		lateText.setFormat(Paths.font("DREAMS.ttf"), 8, FlxColor.WHITE, LEFT);
		lateText.text = Std.string(late);
		add(lateText);

		missSprite = new FlxSprite(FlxG.width - 370, scoreSpriteYPos + 340);
		missSprite.loadGraphic("assets/images/judgeScore.png", false, 370, 70);
		add(missSprite);

		missTextTitle = new FlxText(FlxG.width - 330, scoreSpriteYPos + 375, 0, "Miss", 15);
		missTextTitle.color = FlxColor.BLACK;
		add(missTextTitle);

		missText = new FlxText(scoreSpriteXPos + 585, scoreSpriteYPos + 363, 0, "0", 8);
		missText.setFormat(Paths.font("DREAMS.ttf"), 8, FlxColor.WHITE, LEFT);
		missText.text = Std.string(miss);
		add(missText);

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
					scoreText.text = Std.string(score);
					scoreDisplayed = true;
				}
			}
		}
		super.update(elapsed);
	}
}
