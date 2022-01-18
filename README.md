# CS496 Imersive Camp (Winter 2021)

# Project #3: Rhythm Game

## Team

송성민([https://github.com/reverg](https://github.com/reverg))

전승윤([https://github.com/BUYA-GH](https://github.com/BUYA-GH))

## Introduction

 HaxeFlixel game engine을 사용한 12키 리듬게임이다. 1280*720 해상도로 제작되었다.

## Build Instruction

WARNING : THIS GAME HAS FATAL BUG RELATED TO SYNC.

WE DO NOT RECOMMEND YOU PLAYING THIS GAME.

### Installing the Required Programs

 HaxeFlixel 기반으로 만들어진 게임이어서 [Haxe](https://haxe.org/)와 [HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/)을 설치해야 한다. 추가적으로 게임 구동에 필요한 아래의 라이브러리들을 설치해야 한다.

flixel
flixel-addons
flixel-ui
hscript
newgrounds

CMD에 `haxelib install [library]` 형식으로 입력하면 설치할 수 있다. 예를 들면, `haxelib install newgrounds`를 입력하면 마지막 라이브러리가 설치된다.

### Copyright Issues

 저작권 문제로 인해 작업에 사용된 곡들은 파일에 포함되어 있지 않다. 아래에 JSON을 이용한 채보 작성에 대해 설명하니 참고하고 직접 채보를 짜는 것을 권장한다.

### Compiling Game

 HaxeFlixel은 HTML5, Neko, Flash로 컴파일을 지원한다. CMD에  `lime test html5` 를 입력하면 HTML5에 게임을 실행할 수 있다. 다른 플랫폼은 소리 재생과 실행에 관련한 문제가 있어 권장하지 않는다.

## State Overview

Title, Select, Loading, Play, Score의 5가지 State로 구성되어 있다.

### Title State

  `Enter` 를 눌러 다음 State로 넘어가면 된다.

### Select State

 플레이 가능한 곡들의 간단한 정보를 확인할 수 있다. `Up` / `Down` 키로 곡을,  `Left` / `Right` 키로 난이도를 선택 가능하다. Easy와 Hard 총 2가지 난이도를 지원하며 `Enter` 를 누르면 Loading State로 넘어간다.

### Loading State

 `Up` / `Down` 키로 노트가 내려오는 속도를 조정할 수 있다. 기본 속도 1000에서 100 단위로 변경할 수 있고 500부터 1500까지 지원한다. 3초 동안 머물러 있다 Play State로 넘어가게 된다. Skip을 원할 시  `Enter` 를 누르면 된다.

 1000은 초당 1000픽셀을 이동한다는 의미이다. 노트가 생성되어 판정선에 떨어질 때까지 걸리는 시간이 1초 정도라고 생각하면 편하다.

### Play State

 일반 노트와 롱 노트가 있다. 일반 노트는 최초 1회 입력만을 판정하고 롱 노트는 최초 입력 후 8분음표 단위로 키가 입력되어 있는지를 확인한다. 일반 노트와 롱 노트의 최초 입력은 Critical, Fast, Late 3가지 판정이 있고 롱 노트의 2번째 이후 판정은 Critical 판정만 존재한다. Fast와 Late는 Combo를 끊지는 않지만 Critical 점수의 절반만 얻는다. 판정 범위는 Critical이 40ms(24 frame), Fast와 Late가 Critical 전후로 20ms(12 frame)이다.

### Score State

 플레이 결과를 확인하는 창이다. 최종 점수, Critical / Fast / Late / Miss 개수, Max Combo를 보여준다.

## Mechanism

 노트를 출력하고 판정하는  `PlayState.hx` 파일과 JSON 파일을 읽고 음악 재생 시점을 조절하는  `Conductor.hx` 파일로 나뉘어져 있다.

### Initial Sync

  `Conductor` 클래스에서 JSON 파일에 적힌 `sync` 값을 읽고 그에 맞춰 노트 / 곡을 출력한다.  `PlayState.hx` 내부의  `update` 함수에서 싱크가 맞을 때까지 시간을 업데이트 하다가 싱크가 맞으면 출력을 시작하는 방식으로 되어있다. `update` 함수는 Frame 단위로 실행되므로 매 프레임마다 곡이 시작할지를 판별하게 된다.

### Note Print

 매 프레임마다 JSON 파일을 1줄씩 읽어서 노트를 출력한다. JSON 파일에는 음표의 길이와 BPM이 기록되어 있어 각 노트가 나올 시간을 계산 가능하다.  `PlayState.hx` 내부의  `update` 함수에서 업데이트 중인 플레이 시간이 노트가 나와야 될 시간보다 커지는 순간 노트를 출력하게 된다. 약간의 딜레이가 생기게 되지만 오차가 최대 1/60초까지만 발생해 판정에 큰 영향을 주지 않는다.
```
if (conductor.curSecTime <= conductor.curTime)
	{
		var notes = conductor.readSection();
		songProgressBar.value = (conductor.secIndex / conductor.secLength) * 100;

  if (notes.charAt(0) == "E")
			{
		 	songProgressBar.value = 100;
			 Timer.delay(function()
				{
					gotoScoreState();
				}, 3000);
			}
   ...
```

### Judge System

 Hitbox 개념을 사용했다. 설정한 노트 속도에 맞는 크기의 보이지 않는 박스를 판정선 주변에 생성하고 매 프레임마다 충돌 판정을 확인한다. 충돌이 발생한 상태에서 노트의 위치에 맞는 키를 누르면 충돌한 판정 박스에 따라 점수를 계산하고 노트를 소멸시킨다.
 ```
criticalBoxSize = Std.int(speed / 24);
fastBoxSize = lateBoxSize = Std.int(criticalBoxSize / 2);

criticalBoxPos = Std.int(hitBoxPos - 3 * (criticalBoxSize / 4));
criticalBox = new FlxSprite(startNotePos, criticalBoxPos).makeGraphic(backgroundWidth, criticalBoxSize, FlxColor.TRANSPARENT);
add(criticalBox);

fastBoxPos = Std.int(criticalBoxPos - fastBoxSize);
fastBox = new FlxUISprite(startNotePos, fastBoxPos).makeGraphic(backgroundWidth, fastBoxSize, FlxColor.TRANSPARENT);
add(fastBox);

lateBoxPos = Std.int(criticalBoxPos + criticalBoxSize);
lateBox = new FlxUISprite(startNotePos, lateBoxPos).makeGraphic(backgroundWidth, lateBoxSize, FlxColor.TRANSPARENT);
add(lateBox);
```
```
FlxG.overlap(fastBox, noteGroup, checkFast);
FlxG.overlap(criticalBox, noteGroup, checkCritical);
FlxG.overlap(hitBox, noteGroup, destroyLong);
FlxG.overlap(lateBox, noteGroup, checkLate);
FlxG.overlap(underLine, noteGroup, missDestroy);
```
## Add Your Own Song

### Add in Songlist

 `assets/data/songlist.txt` 파일에  `<songName> <composer> <BPM>` 형식으로 곡 정보를 입력해준다. 이 정보는 Select State에서 사용된다.

### Add MP3 File

 `assets/music` 디렉토리에 폴더를 만들어  `<songName>`을 소문자로 바꾸고 공백을 제거한 문자열을 이름으로 설정한다. 해당 폴더에  `song.mp3`를 이름으로 한 음원 파일을 넣어준다.

### Make New Score

 JSON 파일을 사용한다. 먼저  `assets/data/<songName>` 폴더에  `<difficulty>.json` 파일을 만들고 곡 제목, 작곡가, 난이도 등의 정보를 기록한다. 
```
{
 "title": "Absolute Zero Point",
 "artist": "Kaneko Chiharu",
 "difficulty": "Hard",
 "level": 12,
 "bpm": 209,
 "sync": 2300,
```
 `sync`는 채보와 곡이 같은 타이밍에 나오도록 맞추기 위해 지정해주는 값이다. 노트가 떨어지는데 걸리는 시간이 코드에 반영되어 있기 때문에 대부분의 경우 양수 값이 들어가게 된다.
```
 "sections": [
  "-4",
  "000000^00000",
  "000000^00000",
  "-8",
  "300000000000",
  "000000300000",
  "600000000000",
  "000000600000",
  ...
  "E"
 ]
}
```

 `sections`에는 노트의 직접적인 출력 정보가 들어간다.  `"-4"`는 4분음표, `"-8"`은 8분음표를 의미하고 아래쪽의  `"300000000000"`은 노트의 가로 크기와 출력 위치를 표시한다. 숫자가 적힌 위치로부터 숫자 크기만큼의 일반 노트가 나오게 된다. 특수문자가 적힌 곳은 롱 노트가 나온다.   `Shift + (1 ~ 9)`에 해당하는 특수문자를 롱 노트의 시작점과 끝점에 기입해서 길이를 조절하는 방식이다.  `...` 이전까지의 노트는 화면에 아래와 같이 출력된다.
<div align=center> <img src = "https://user-images.githubusercontent.com/48681924/149878112-752131ef-160c-4f1d-94b9-74f2e9720566.png" width="80%" height="80%"></div>
 `"E"`는 채보의 끝을 의미한다. 이 행이 출력되고 3초 후에 자동으로 Score State로 넘어간다.

## REPORTED BUGS

### Sync

 상술했듯이 이 게임은 프레임 단위로 시간을 계산해 출력하는 방식을 사용한다. 이 때문에 플레이로 인해 프레임이 떨어지게 되면 노트 출력이 지연되는 문제가 생기고 곡의 후반부에 가면 크게 체감될 수준까지 싱크가 어긋나는 때가 매우 잦다. 사양이 높은 처리 장치를 사용하면 해결 될 문제로 보인다.

 싱크 문제를 해결하기 위해 프레임 단위가 아닌 시간 단위로 노트를 출력하도록 일일이 지정해주는 방식을 고려해 볼 수 있다. 이를 위해선 코드의 상당 부분을 통째로 교체해야 하는데, 개발 시간의 한계로 실행할 수 없었다.

### Freeze & Shutdown

 종종 곡의 중간에 게임이 멈춰버리는 버그가 존재한다. 정지 위치가 일관적이지 않은 것으로 보아 컴퓨터 처리 능력에 과한 부담이 걸려 생기는 문제로 추정된다.
 
### Late / Miss Judge

 Hitbox를 노트 속도에 따라 늘리는 방식을 사용했더니 속도가 빠르면 Late와 Miss 판정의 범위가 게임의 최하단 픽셀을 넘어가 인식되지 않는 문제가 발생했다. 판정을 Hitbox 개념이 아니라 노트의 y좌표 값에 따라 일일이 계산하는 방식으로 바꿔서 짜야 될 것으로 보인다.

---

[https://github.com/BUYA-GH/madcamp3](https://github.com/BUYA-GH/madcamp3)
