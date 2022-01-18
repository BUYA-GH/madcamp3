package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxe.display.JsonModuleTypes.JsonTypeParameters;
import lime.utils.Assets;

class SelectState extends FlxState
{
	var playButton:FlxButton;
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var songNameList:FlxTypedGroup<FlxText>;
	private var songInfoList:FlxTypedGroup<FlxText>;

	private var curPlaying:Bool = false;

	function clickPlay()
	{
		FlxG.switchState(new SelectState());
	}

	override public function create()
	{
		songs = CoolUtil.initSonglist(Paths.txt('songlist'));

		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('select_state'));
		add(bg);

		songNameList = new FlxTypedGroup<FlxText>();
		songInfoList = new FlxTypedGroup<FlxText>();
		add(songNameList);

		for (i in 0...songs.length)
		{
			var songName:FlxText = new FlxText(100, 0, songs[i].songname, 20);
			songNameList.add(songName);
		}

		diffText = new FlxText();
		diffText.setFormat(32, FlxColor.WHITE);
		diffText.setPosition(1100, 50);
		add(diffText);

		changeSelection();
		changeDiff();

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		var up:Bool = FlxG.keys.justPressed.UP;
		var down:Bool = FlxG.keys.justPressed.DOWN;
		var left:Bool = FlxG.keys.justPressed.LEFT;
		var right:Bool = FlxG.keys.justPressed.RIGHT;
		var back:Bool = FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSLASH;
		var accepted:Bool = FlxG.keys.justPressed.ENTER;
		var autoAccepted:Bool = FlxG.keys.justPressed.A;

		if (up)
		{
			changeSelection(-1);
		}
		if (down)
		{
			changeSelection(1);
		}

		if (left)
		{
			changeDiff(-1);
		}
		if (right)
		{
			changeDiff(1);
		}

		if (back)
			FlxG.switchState(new TitleState());
		if (accepted)
		{
			FlxG.switchState(new LoadingState(songs[curSelected], curDifficulty, false));
		}
		if (autoAccepted)
		{
			FlxG.switchState(new LoadingState(songs[curSelected], curDifficulty, true));
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 0;
		if (curDifficulty > 1)
			curDifficulty = 1;

		switch (curDifficulty)
		{
			case 0:
				diffText.text = "EASY";
			case 1:
				diffText.text = "HARD";
		}
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		var index:Int = 0;
		for (item in songNameList.members)
		{
			item.alpha = 0.6;

			var targetY:Int = index - curSelected;

			item.y = 350 + 70 * targetY;
			item.setFormat(28);
			index++;

			if (targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}
}
