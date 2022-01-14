package;

import flixel.util.FlxAxes;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;

class TitleState extends FlxState
{
	var playButton:FlxButton;
	var fullscreenButton:FlxButton;

	override public function create()
	{
		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('menuBG'));
		add(bg);

		playButton = new FlxButton(0, 0, "Press Enter", clickPlay);
		playButton.screenCenter();
		add(playButton);

		fullscreenButton = new FlxButton(0, 200, FlxG.fullscreen ? "FULLSCREEN" : "WINDOWED", clickFullscreen);
		fullscreenButton.screenCenter(FlxAxes.X);
		add(fullscreenButton);

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
