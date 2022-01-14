package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;

class TitleState extends FlxState
{
	var playButton:FlxButton;

	override public function create()
	{
		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('menuBG'));
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
}
