package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class VisualsUISubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Visuals and UI';
		rpcTitle = 'Visuals & UI Menu'; //for Discord Rich Presence

		//I'd suggest using "Downscroll" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Downscroll', //Name
			'If checked, notes go Down instead of Up, simple enough.', //Description
			'lowQuality', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		var option:Option = new Option('Middlescroll',
			'If checked, your notes get centered.',
			'middleScroll',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Ghost Tapping',
			"If checked, you won't get misses from pressing keys\nwhile there are no notes able to be hit.",
			'ghostTapping',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Note Delay',
			'Changes how late a note is spawned.\nUseful for preventing audio lag from wireless earphones.',
			'noteOffset',
			'int',
			true);
		option.displayFormat = '%vms';
		option.scrollSpeed = 100;
		option.minValue = 0;
		option.maxValue = 500;
		addOption(option);

		var option:Option = new Option('Note Splashes',
			"If unchecked, hitting \"Sick!\" notes won't show particles.",
			'noteSplashes',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Hide HUD',
			'If checked, hides most HUD elements.',
			'hideHud',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Hide Song Length',
			'If unchecked, disables anti-aliasing, increases performance\nat the cost of the graphics not looking as smooth.',
			'hideTime',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Flashing Lights',
			"Uncheck this if you're sensitive to flashing lights!",
			'flashing',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Camera Zooms',
			"If unchecked, the camera won't zoom in on a beat hit.",
			'camZooms',
			'bool',
			true);
		addOption(option);
		
		#if !mobile
		var option:Option = new Option('FPS Counter',
			'If unchecked, hides FPS Counter.',
			'showFPS',
			'bool',
			true);
		addOption(option);
		#end

        var option:Option = new Option('Hitsounds',
			'If checked, a sound will play each time you hit a note. Good for basing your accuracy.',
			'hitSounds',
			'bool',
			false);
		addOption(option);

        var option:Option = new Option('Main Menu Details',
			'If unchecked, characters in the main menu won\'t show up.',
			'mainMenuDetails',
			'bool',
			true);
		addOption(option);

        var option:Option = new Option('Famil Engine Watermarks',
			'If unchecked, watermarks for Famil Engine won\'t show up.',
			'feWatermarks',
			'bool',
			true);
		addOption(option);

        var option:Option = new Option('Instant Respawn',
        'If checked, you will instantly respawn when you die. Simple.',
        'instantRespawn',
        'bool',
        false);
        addOption(option);

        var option:Option = new Option('Reset Key',
        'If unchecked, if you press R (or any keybind), you won\'t die. Turn this off if you accidently keep pressing it.',
        'resetKey',
        'bool',
        false);
        addOption(option);

		super();
	}
}