package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;

class ScoreState extends FlxState
{
	var playButton:FlxButton;
	var stopMusic = false;

	override public function create()
	{
		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('menuBGMagenta'));
		add(bg);

		playButton = new FlxButton(0, 0, "Press Enter", clickPlay);
		playButton.screenCenter();
		add(playButton);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;
		if (pressedEnter)
			FlxG.switchState(new SelectState());
		super.update(elapsed);
	}

	function clickPlay()
	{
		FlxG.switchState(new SelectState());
	}

	inline static public function loadAndSwitchState(target:FlxState, stopMusic = false)
	{
		// FlxG.switchState(getNextState(target, stopMusic));
	}
}
