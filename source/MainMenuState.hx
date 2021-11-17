package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.math.FlxRandom;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
#if GAMEJOLT_ALLOWED
import GameJolt.GameJoltAPI;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.4.2'; 
	public static var familEngineVersion:String = '0.2.2'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	public static var prevCharacter:Int = 99;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<Dynamic> = [
		['story_mode', 0xFFFDE871], 
		['freeplay', 0xFF2599C0],
		#if ACHIEVEMENTS_ALLOWED
		['awards', 0xFF1DD408],
		#end 
		['credits', 0xFFFD7171], 
		#if !switch
		['donate', 0xFF496D44],
		#end
		['discord', 0xFF5865F2],
		['options', 0xFFA0871F],
	];

	var bg:FlxSprite;
	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;

	var character:FlxSprite;

	var intendedColor:Int;
	var colorTween:FlxTween;

	var susEasterEgg:Int = 0;
	var susEasterEggTriggered:Bool = false;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		bg = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		bg.color = optionShit[curSelected][1];
		intendedColor = bg.color;

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		if (ClientPrefs.mainMenuDetails) {
			var random:Int = 0;

			random = FlxG.random.int(0,5);
			random++;
			if (random > 5)
				random = 0;


			switch (random)
			{
				case 0:
					character = new FlxSprite(200, 275);
                    character.frames = Paths.getSparrowAtlas('mainmenucharacters/bf_title', 'shared');
                    character.animation.addByPrefix('idle', 'BF idle dance', 24, true);
					character.flipX = true;
				case 1:
					character = new FlxSprite(100, 75);
                    character.frames = Paths.getSparrowAtlas('mainmenucharacters/gf_title', 'shared');
                    character.animation.addByPrefix('idle', 'GF Dancing Beat', 24, true);
					character.flipX = true;
				case 2:
					character = new FlxSprite(175, 275);
                    character.frames = Paths.getSparrowAtlas('mainmenucharacters/pico_title', 'shared');
                    character.animation.addByPrefix('idle', 'Pico Idle Dance', 24, true);
					character.flipX = true;
				case 3:
					character = new FlxSprite(100, 25);
                    character.frames = Paths.getSparrowAtlas('mainmenucharacters/mom_title', 'shared');
                    character.animation.addByPrefix('idle', 'Mom Idle', 24, true);
				case 4:
					character = new FlxSprite(100, 25);
                    character.frames = Paths.getSparrowAtlas('mainmenucharacters/dad_title', 'shared');
                    character.animation.addByPrefix('idle', 'Dad idle dance', 24, true);
				case 5:
					character = new FlxSprite(100, 150);
                    character.frames = Paths.getSparrowAtlas('mainmenucharacters/spooky_title', 'shared');
                    character.animation.addByPrefix('idle', 'spooky dance idle', 24, true);
			}

			//character.debugMode = true;
			character.scale.set(0.8, 0.8);
			character.scrollFactor.set(0, 0);
			add(character);
			character.animation.play('idle');
			prevCharacter = random;
		}

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i][0]);
			menuItem.animation.addByPrefix('idle', optionShit[i][0] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i][0] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set(0, 0.15);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}

		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Famil Engine v" + familEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				#if GAMEJOLT_ALLOWED
				GameJoltAPI.getTrophy(152033);
				#end
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (FlxG.keys.justPressed.S && !susEasterEggTriggered)
			if (susEasterEgg == 0) susEasterEgg = 1;
			else if (susEasterEgg == 2) susEasterEgg = 3;
			else susEasterEgg == 0;

		if (FlxG.keys.justPressed.U && !susEasterEggTriggered)
			if (susEasterEgg == 1) susEasterEgg = 2;
			else susEasterEgg == 0;

		if (susEasterEgg == 3)
			sussyEasterEgg();
			susEasterEgg = 0;
			susEasterEggTriggered = true;

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 5.6, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				if(colorTween != null) {
					colorTween.cancel();
				}
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected][0] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else if (optionShit[curSelected][0] == 'discord')
				{
					CoolUtil.browserLoad('https://discord.gg/wMzS8PsEXy'); //oh my god it says sEXy
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected][0];

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										MusicBeatState.switchState(new OptionsState());
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.justPressed.SEVEN)
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
			if(ClientPrefs.mainMenuDetails) {
				spr.x += 250;
			}
		});

		var newColor:Int = optionShit[curSelected][1];
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.offset.y = 0;
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
				spr.offset.x = 0.15 * (spr.frameWidth / 2 + 180);
				spr.offset.y = 0.15 * spr.frameHeight;
				FlxG.log.add(spr.frameWidth);
			}
		});
	}

	function sussyEasterEgg()
	{
		character.visible = false;
		character = new FlxSprite(200, 275);
        character.frames = Paths.getSparrowAtlas('mainmenucharacters/dripmog_title', 'shared');
        character.animation.addByPrefix('idle', 'mog', 24, true);
		add(character);
		FlxG.sound.play(Paths.sound('vine-boom', 'shared'));
	}
}
