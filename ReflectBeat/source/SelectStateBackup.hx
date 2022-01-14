package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import lime.utils.Assets;

class SelectStateBackup extends FlxState
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

	// private var grpSongs:FlxTypedGroup<Alphabet>;
	private var grpSongs:FlxTypedGroup<SongLayout>;

	private var songNameList:FlxTypedGroup<FlxText>;
	private var songInfoList:FlxTypedGroup<FlxText>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<SongIcon> = [];

	function clickPlay()
	{
		FlxG.switchState(new SelectState());
	}

	override public function create()
	{
		songs = CoolUtil.initSonglist(Paths.txt('songlist'));

		// TODO
		// Change BackGround Image
		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('menuBGBlue'));
		add(bg);

		// grpSongs = new FlxTypedGroup<Alphabet>();
		// grpSongs = new FlxTypedGroup<SongLayout>();
		// add(grpSongs);

		songNameList = new FlxTypedGroup<FlxText>();
		songInfoList = new FlxTypedGroup<FlxText>();
		add(songNameList);
		add(songInfoList);

		// for check - erase this later
		var playButton:FlxButton = new FlxButton(0, 0, songs[songs.length - 1].songname, clickPlay);
		playButton.screenCenter();
		add(playButton);

		for (i in 0...songs.length)
		{
			var songName:FlxText = new FlxText(0, (70 * i) + 30, songs[i].songname);
			songNameList.add(songName);
			var songInfo:FlxText = new FlxText(songName.x, songName.y + 30, songs[i].composer + " " + Std.string(songs[i].bpm));
			songInfoList.add(songInfo);

			/*
				var songText:SongLayout = new SongLayout(0, (70 * i) + 30, songs[i].songname, songs[i].composer, songs[i].bpm, true, false);
				songText.isMenuItem = true;
				songText.targetY = i;
				grpSongs.add(songText);

				var icon = new SongIcon(songs[i].composer, songs[i].bpm);
				icon.sprTracker = songText;

				iconArray.push(icon);
				add(icon);
			 */ /*
				var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
				songText.isMenuItem = true;
				songText.targetY = i;
				grpSongs.add(songText);

				var icon:HealthIcon = new HealthIcon();
				icon.sprTracker = songText;

				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
			 */

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
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

		scoreText.text = "PERSONAL BEST:" + lerpScore;

		var up:Bool = FlxG.keys.anyPressed([UP]);
		var down:Bool = FlxG.keys.anyPressed([DOWN]);
		var left:Bool = FlxG.keys.anyPressed([LEFT]);
		var right:Bool = FlxG.keys.anyPressed([RIGHT]);
		var back:Bool = FlxG.keys.anyPressed([ESCAPE, BACKSPACE]);
		var accepted:Bool = FlxG.keys.anyPressed([ENTER]);

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
		/*
			var bullShit:Int = 0;

			for (i in 0...iconArray.length)
			{
				// iconArray[i].alpha = 0.6;
			}

			// iconArray[curSelected].alpha = 1;

			for (item in grpSongs.members)
			{
				//item.targetY = bullShit - curSelected;
				bullShit++;

				// item.alpha = 0.6;
				// item.setGraphicSize(Std.int(item.width * 0.8));

				if (item.targetY == 0)
				{
					// item.alpha = 1;
					// item.setGraphicSize(Std.int(item.width));
				}
			}
		 */
	}
}
