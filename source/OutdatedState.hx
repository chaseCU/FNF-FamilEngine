package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;

class OutdatedState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var bg:FlxBackdrop;
	var bgBg:FlxBackdrop;

	var warnText:FlxText;
	override function create()
	{
		super.create();

		bg = new FlxBackdrop(null, 1, 1, true, true);
		bg.loadGraphic(Paths.image('menuGrid'));

		bgBg = new FlxBackdrop(null, 1, 1, true, true);
		bgBg.x += 20;
		bgBg.loadGraphic(Paths.image('menuGrid'));
		bgBg.alpha = 0.5;

		add(bgBg);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"Sup bro, looks like you're running an   \n
			outdated version of Famil Engine (" + MainMenuState.familEngineVersion + "),\n
			please update to " + TitleState.updateVersion + "!\n
			\n
			Thank you for using the Engine!",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		bg.x += 0.4;
		bg.y += 0.2;

		bgBg.x -= 0.25;
		bgBg.y -= 0.15;
		
		if(!leftState) {
			if (controls.ACCEPT || controls.BACK) {
				leftState = true;
				CoolUtil.browserLoad("https://github.com/family1242/FNF-FamilEngine/releases/");
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTween.tween(warnText, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
						MusicBeatState.switchState(new MainMenuState());
					}
				});
			}
		}
		super.update(elapsed);
	}
}
