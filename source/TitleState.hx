package;

import lime.system.System;
#if sys
import smTools.SMFile;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
#if ng
import io.newgrounds.NG;
#end
import lime.app.Application;
import openfl.Assets;

#if windows
import Discord.DiscordClient;
#end

#if cpp
import sys.thread.Thread;
#end

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;
	var idotSprite:FlxSprite;
	var idotSprite2:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	override public function create():Void
	{
		#if android
		FlxG.android.preventDefaultKeys = [BACK];
		#end

		@:privateAccess
		{
			trace("Loaded " + openfl.Assets.getLibrary("default").assetsLoaded + " assets (DEFAULT)");
		}
		
		PlayerSettings.init();

		#if windows
		DiscordClient.initialize();

		Application.current.onExit.add (function (exitCode) {
			DiscordClient.shutdown();
		 });
		 
		#end

		curWacky = FlxG.random.getObject(getIntroTextShit());

		trace('hello');

		// DEBUG BULLSHIT

		super.create();

		// NGio.noLogin(APIStuff.API);

		#if ng
		var ng:NGio = new NGio(APIStuff.API, APIStuff.EncKey);
		trace('NEWGROUNDS LOL');
		#end

		FlxG.save.bind('funkin', 'ninjamuffin99');

		KadeEngineData.initSave();

		// var file:SMFile = SMFile.loadFile("file.sm");
		// this was testing things
		
		Highscore.load();

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		#else
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});
		#end
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	//var bgthing:FlxSprite;
	var bf:FlxSprite;
	var beepie:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

		Conductor.changeBPM(102);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		// bg.antialiasing = true;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);

		if(Main.watermarks) {
			logoBl = new FlxSprite(-50, 2000);
			logoBl.frames = Paths.getSparrowAtlas('KadeEngineLogoBumpin');
			logoBl.setGraphicSize(Std.int(logoBl.width * 0.8));
			logoBl.antialiasing = true;
			logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
			logoBl.animation.play('bump');
			logoBl.updateHitbox();
			// logoBl.screenCenter();
			// logoBl.color = FlxColor.BLACK;
		} else {
			logoBl = new FlxSprite(-50, 2000);
			logoBl.frames = Paths.getSparrowAtlas('KadeEngineLogoBumpin');
			logoBl.antialiasing = true;
			logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
			logoBl.animation.play('bump');
			logoBl.updateHitbox();
			// logoBl.screenCenter();
			// logoBl.color = FlxColor.BLACK;
		}

		gfDance = new FlxSprite(FlxG.width * 0.2, FlxG.height * 0.18);
		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = true;
		//add(gfDance);

		/*bgthing = new FlxSprite(-100, -660);
		bgthing.frames = Paths.getSparrowAtlas('banner'); this shit brokes the game
		bgthing.animation.addByPrefix('idle', 'Símbolo 3 instancia 1', 24);
		bgthing.animation.play('idle');
		bgthing.flipX = true;
		bgthing.antialiasing = true;*/
		
		bf = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.28);
		bf.frames = Paths.getSparrowAtlas('bfbanner');
		bf.animation.addByPrefix('idle', 'bf iiidle', 24);
		bf.animation.play('idle');
		bf.setGraphicSize(Std.int(bf.width * 0.8));
		bf.updateHitbox();
		bf.antialiasing = true;

		beepie = new FlxSprite(FlxG.width * 0.6, FlxG.height * 0.17);
		beepie.frames = Paths.getSparrowAtlas('beepiebanner');
		beepie.animation.addByPrefix('idle', 'beeppii', 24);
		beepie.animation.play('idle');
		beepie.setGraphicSize(Std.int(beepie.width * 0.8));
		beepie.antialiasing = true;
		beepie.updateHitbox();
		//add(bgthing);
		add(bf);
		add(beepie);
		add(logoBl);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = true;
		// add(logo);

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		//idotSprite = new FlxSprite(400, FlxG.height * 0.25).loadGraphic(Paths.image('idiots'));
		idotSprite = new FlxSprite(350, FlxG.height * 0.23).loadGraphic(Paths.image('idiots'));
		add(idotSprite);
		idotSprite.visible = false;
		idotSprite.setGraphicSize(Std.int(idotSprite.width * 0.8));
		idotSprite.updateHitbox();
		//idotSprite.screenCenter(X);
		idotSprite.antialiasing = true;

		idotSprite2 = new FlxSprite(-50, FlxG.height * 0.19).loadGraphic(Paths.image('idiots 2'));
		add(idotSprite2);
		idotSprite2.visible = false;
		idotSprite2.setGraphicSize(Std.int(idotSprite2.width * 0.8));
		idotSprite2.updateHitbox();
		//idotSprite2.screenCenter(X);
		idotSprite2.antialiasing = true;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = controls.ACCEPT;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		if (pressedEnter && !transitioning && skippedIntro)
		{
			#if (!switch && ng)
			NGio.unlockMedal(60960);

			// If it's Friday according to da clock
			if (Date.now().getDay() == 5)
				NGio.unlockMedal(61034);
			#end

			if (FlxG.save.data.flashing)
				titleText.animation.play('press');

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;
			// FlxG.sound.music.stop();

			MainMenuState.firstStart = true;

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				// Get current version of Kade Engine
				
				var http = new haxe.Http("https://raw.githubusercontent.com/KadeDev/Kade-Engine/master/version.downloadMe");
				var returnedData:Array<String> = [];
				
				http.onData = function (data:String)
				{
					returnedData[0] = data.substring(0, data.indexOf(';'));
					returnedData[1] = data.substring(data.indexOf('-'), data.length);
				  	if (!MainMenuState.kadeEngineVer.contains(returnedData[0].trim()) && !OutdatedSubState.leftState && MainMenuState.nightly == "")
					{
						FlxG.switchState(new MainMenuState());
					}
					else
					{
						FlxG.switchState(new MainMenuState());
					}
				}
				
				http.onError = function (error) {
				  trace('error: $error');
				  FlxG.switchState(new MainMenuState()); // fail but we go anyway
				}
				
				http.request();
			});
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
		}

		if (pressedEnter && !skippedIntro && initialized)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{
		super.beatHit();

		logoBl.animation.play('bump');
		danceLeft = !danceLeft;

		//if (danceLeft)
			//gfDance.animation.play('danceRight');
		//else
			//gfDance.animation.play('danceLeft');

		FlxG.log.add(curBeat);

		switch (curBeat)  //it took me a day i wanna kill myself (BRN)
		{
			case 0:
				deleteCoolText();
			case 3:
				createCoolText(['valengarfy']);
			case 4:
				addMoreText('brn');
			case 5:
				addMoreText('blueby');
			case 6:
				addMoreText('stickman');
			case 7:
				idotSprite.visible = true;
			case 8:
				deleteCoolText();
				idotSprite.visible = false;
			case 9:
				createCoolText(['koichis']);
			case 10:
				addMoreText('springy teze');
			case 11:
				addMoreText('kimakurus');
			case 12:
				addMoreText('sickaric');
			case 13:
				idotSprite2.visible = true;
			case 14:
				deleteCoolText();
				idotSprite2.visible = false;
			case 15:
				if (Main.watermarks)
					createCoolText(['Kade Engine', 'by']);
				else
					createCoolText(['In Partnership', 'with']);
			case 17:
				if (Main.watermarks)
					addMoreText('KadeDeveloper');
				else
				{
					addMoreText('Newgrounds');
					ngSpr.visible = true;
				}
			case 18:
				deleteCoolText();
				ngSpr.visible = false;
			case 19:
				createCoolText(['thanks bbpanzu']);
			case 20:
				addMoreText('for all the support');
			case 21:
				deleteCoolText();
			case 22:
				createCoolText(['dont skip']);
			case 23:
				addMoreText('the tutorial');
			case 24:
				addMoreText('go to play it');
			case 25:
				deleteCoolText();
			case 26:
				createCoolText([curWacky[0]]);
			case 27:
				addMoreText(curWacky[1]);
			case 28:
				deleteCoolText();
			case 29:
				createCoolText(['Finally']);

			case 30:
				addMoreText('Beepie');

			case 31:
				addMoreText('Full Mod');

			case 32:
				skipIntro();
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);
			remove(idotSprite);
			remove(idotSprite2);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);

			FlxTween.tween(logoBl,{y: 0}, 1.4, {ease: FlxEase.expoInOut}); //-100

			logoBl.angle = -4;

			new FlxTimer().start(0.01, function(tmr:FlxTimer)
				{
					if(logoBl.angle == -4) 
						FlxTween.angle(logoBl, logoBl.angle, 4, 4, {ease: FlxEase.quartInOut});
					if (logoBl.angle == 4) 
						FlxTween.angle(logoBl, logoBl.angle, -4, 4, {ease: FlxEase.quartInOut});
				}, 0);
		
			skippedIntro = true;
		}
	}
}
