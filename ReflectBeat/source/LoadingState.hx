package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

// import js.html.AnimationPlaybackEvent;
class LoadingState extends FlxState
{
	var songInfo:SongMetadata;
	var difficulty:Int;
	var loadingTime:Float = 0;
	var speed:Float = 1000;
	var speedText:FlxText;

	public function new(songInfo:SongMetadata, difficulty:Int)
	{
		super();
		this.songInfo = songInfo;
		this.difficulty = difficulty;
	}

	override public function create()
	{
		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('loading_state'));
		add(bg);

		var songName:FlxText = new FlxText(300, 180, songInfo.songname);
		songName.setFormat(Paths.font("DREAMS.ttf"), 10, FlxColor.WHITE);
		add(songName);

		var composer:FlxText = new FlxText(300, 230, songInfo.composer);
		composer.setFormat(Paths.font("DREAMS.ttf"), 10, FlxColor.WHITE);
		add(composer);

		var bpm:FlxText = new FlxText(300, 280, Std.string(songInfo.bpm));
		bpm.setFormat(Paths.font("DREAMS.ttf"), 10, FlxColor.WHITE);
		add(bpm);

		speedText = new FlxText(300, 350, Std.string(speed));
		speedText.setFormat(Paths.font("DREAMS.ttf"), 10, FlxColor.WHITE);
		add(speedText);


		super.create();
	}

	override public function update(elapsed:Float)
	{
		var pressedUpandDown:Bool = FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.UP;
		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;
		if (pressedEnter || loadingTime > 3)
		{
			FlxG.switchState(new PlayState(songInfo.songname, difficulty, speed));
		}

		if(!pressedUpandDown)
		{
			loadingTime += elapsed;
		}
		else
		{
			if (FlxG.keys.justPressed.DOWN) 
			{
				speed = speed - 100;
				if(speed < 500) speed = 500;
			}
			else if (FlxG.keys.justPressed.UP)
			{
				speed = speed + 100;
				if(speed > 1500) speed = 1500;
			}
			speedText.text = Std.string(speed);
		}
		
		super.update(elapsed);
	}
}
