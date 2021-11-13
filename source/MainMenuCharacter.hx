package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class MainMenuCharacter extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curTitleCharacter:String = 'bf';

	public var holdTimer:Float = 0;
	public function new(x:Float, y:Float, ?titleCharacter:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curTitleCharacter = titleCharacter;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curTitleCharacter)
		{
			case 'bf-title':
				var tex = Paths.getSparrowAtlas('mainmenucharacters/BOYFRIEND');
				frames = tex;
	
				trace(tex.frames.length);

				animation.addByPrefix('idle', 'BF idle dance', 24);
				
				loadOffsetFile(curTitleCharacter);
	
				playAnim('idle');
	
				flipX = true;
			case 'gf-title':
				tex = Paths.getSparrowAtlas('mainmenucharacters/GFtitle_assets');
				frames = tex;
				animation.addByPrefix('idle', 'GF Dancing Beat', 24);
	
				loadOffsetFile(curTitleCharacter);
	
				playAnim('idle');

			case 'pico-title':
				tex = Paths.getSparrowAtlas('mainmenucharacters/Pico_FNF_assetss');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);

				loadOffsetFile(curTitleCharacter);

				playAnim('idle');

				flipX = true;

			case 'dad-title':
				tex = Paths.getSparrowAtlas('mainmenucharacters/DADDY_DEAREST');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
	
				loadOffsetFile(curTitleCharacter);
	
				playAnim('idle');

			case 'mom-title':
				tex = Paths.getSparrowAtlas('mainmenucharacters/Mom_Assets');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24);

				loadOffsetFile(curTitleCharacter);

				playAnim('idle');

			case 'spooky-title':
				tex = Paths.getSparrowAtlas('mainmenucharacters/spookytitle_kids_assets');
				frames = tex;
				animation.addByPrefix('idle', 'spooky dance idle', 24);

				loadOffsetFile(curTitleCharacter);

				playAnim('idle');
		}

		dance();
	}

	public function loadOffsetFile(titleCharacter:String)
	{
		var offset:Array<String> = CoolUtil.coolTextFile(Paths.imageTxt('mainmenucharacters/' + titleCharacter + "Offsets"));
	
		for (i in 0...offset.length)
		{
			var data:Array<String> = offset[i].split(' ');
			addOffset(data[0], Std.parseInt(data[1]), Std.parseInt(data[2]));
		}
	}

	override function update(elapsed:Float)
	{
		if (!curTitleCharacter.startsWith('bf'))
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curTitleCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				trace('dance');
				dance();
				holdTimer = 0;
			}
		}

		switch (curTitleCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode)
		{
			switch (curTitleCharacter)
			{
				case 'gf':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-christmas':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-car':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-pixel':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				default:
					playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}