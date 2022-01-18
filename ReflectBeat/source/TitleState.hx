package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

class TitleState extends FlxState
{
	var playButton:FlxButton;
	var fullscreenButton:FlxButton;
	var titleText:FlxText;

	override public function create()
	{
		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('title_state'));
		add(bg);

		titleText = new FlxText(0, 330, "Title");
		titleText.setFormat(Paths.font("DREAMS.ttf"), 25, FlxColor.WHITE);
		titleText.screenCenter(FlxAxes.X);
		add(titleText);

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

	function clickFullscreen()
	{
		FlxG.fullscreen = !FlxG.fullscreen;
		fullscreenButton.text = FlxG.fullscreen ? "FULLSCREEN" : "WINDOWED";
	}
}
