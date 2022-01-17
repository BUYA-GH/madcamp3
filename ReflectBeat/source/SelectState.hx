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

		// TODO
		// Change BackGround Image
		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('select_state'));
		add(bg);

		songNameList = new FlxTypedGroup<FlxText>();
		songInfoList = new FlxTypedGroup<FlxText>();
		add(songNameList);
		// add(songInfoList);

		// for check - erase this later
		var playButton:FlxButton = new FlxButton(0, 0, songs[songs.length - 1].songname, clickPlay);
		playButton.screenCenter();
		add(playButton);

		for (i in 0...songs.length)
		{
			var songName:FlxText = new FlxText(0, 100 * i, songs[i].songname);
			songNameList.add(songName);
			var songInfo:FlxText = new FlxText(songName.x, songName.y + 60, songs[i].composer + " " + Std.string(songs[i].bpm), 20);
			songInfoList.add(songInfo);
		}

		// scoreText = new FlxText(FlxG.width * 0.7, "", 32);
		// scoreText.autoSize = false;
		// scoreText.setFormat(Paths.font("DREAMS.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		diffText = new FlxText(600, 0, "", 24);
		diffText.setFormat(Paths.font("DREAMS.ttf"), FlxColor.WHITE, RIGHT);
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);

		// selector = new FlxText();
		// selector.size = 40;
		// selector.text = ">";
		// add(selector);

		// var swag:Alphabet = new Alphabet(1, 0, "swag");
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		/*
			if (FlxG.sound.music.volume < 0.7)
			{
				FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			}
		 */

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		// scoreText.text = "PERSONAL BEST:" + lerpScore;
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
			// var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

			// trace(poop);

			// PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			// trace('CUR WEEK' + PlayState.storyWeek);
			// LoadingState.loadAndSwitchState(new PlayState());
			FlxG.switchState(new LoadingState(songs[curSelected], curDifficulty, false));
		}
		if(autoAccepted)
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

		#if !switch
		// intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end

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
		#if !switch
		// NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');
		// FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		// intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		// lerpScore = 0;
		#end

		#if PRELOAD_ALL
		// FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end

		var index:Int = 0;
		for (item in songNameList.members)
		{
			item.alpha = 0.6;

			var targetY:Int = index - curSelected;
			index++;

			item.y = (70 * index) + 30 - 30 * targetY;

			if (targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}

		index = 0;

		for (item in songInfoList.members)
		{
			item.alpha = 0.6;

			var targetY:Int = index - curSelected;
			index++;

			item.y = (100 * index) + 100 * targetY;

			if (targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
