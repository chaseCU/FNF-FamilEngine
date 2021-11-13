package;

//stole this from Hypno's Lullaby mod because i suck at coding

import flixel.graphics.FlxGraphic;
import sys.thread.Thread;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;

enum PreloadType {
    atlas;
    image;
}

class PreloadState extends MusicBeatState {

    var globalRescale:Float = 2/3;
    var preloadStart:Bool = false;

    var bg:FlxBackdrop;
	var bgBg:FlxBackdrop;
    var logoBl:FlxSprite;

    var loadText:FlxText;
    var assetStack:Map<String, PreloadType> = [
        'speech_bubble' => PreloadType.image, 
        'noteSplashes' => PreloadType.image,
        'characters' => PreloadType.atlas,
        'mainmenucharacters' => PreloadType.atlas,
        'dialogue' => PreloadType.atlas,
    ];
    var maxCount:Int;

    public static var preloadedAssets:Map<String, FlxGraphic>;
    var backgroundGroup:FlxTypedGroup<FlxSprite>;

    public static var unlockedSongs:Array<Bool> = [false, false];

    override public function create() {
        super.create();

        FlxG.camera.alpha = 0;

        maxCount = Lambda.count(assetStack);
        trace(maxCount);
        // create funny assets
        backgroundGroup = new FlxTypedGroup<FlxSprite>();
        FlxG.mouse.visible = false;

        preloadedAssets = new Map<String, FlxGraphic>();

        bgBg = new FlxBackdrop(null, 1, 1, true, true);
		bgBg.x += 20;
		bgBg.loadGraphic(Paths.image('menuGrid'));
		bgBg.alpha = 0.5;
        backgroundGroup.add(bgBg);

        bg = new FlxBackdrop(null, 1, 1, true, true);
		bg.loadGraphic(Paths.image('menuGrid'));
        backgroundGroup.add(bg);

        logoBl = new FlxSprite();
		if (ClientPrefs.feWatermarks) {
			logoBl.frames = Paths.getSparrowAtlas('FamilEngineLogoBumpin');
		}
		else {
			logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		}
        logoBl.antialiasing = ClientPrefs.globalAntialiasing;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
        logoBl.screenCenter();
        backgroundGroup.add(logoBl);

        add(backgroundGroup);
        FlxTween.tween(FlxG.camera, {alpha: 1}, 0.5, {
            onComplete: function(tween:FlxTween){
                Thread.create(function(){
                    assetGenerate();
                });
            }
        });

        // save bullshit
        FlxG.save.bind('funkin', 'ninjamuffin99');
        if(FlxG.save.data != null) {
            if (FlxG.save.data.silverUnlock != null)
                unlockedSongs[0] = FlxG.save.data.silverUnlock;
            if (FlxG.save.data.missingnoUnlock != null)
                unlockedSongs[1] = FlxG.save.data.missingnoUnlock;
        }

        loadText = new FlxText(5, FlxG.height - (32 + 5), 0, 'Loading...', 32);
		loadText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(loadText);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        bg.x += 0.4;
		bg.y += 0.2;

		bgBg.x -= 0.25;
		bgBg.y -= 0.15;
    }

    var storedPercentage:Float = 0;

    function assetGenerate() {
        //
        var countUp:Int = 0;
        for (i in assetStack.keys()) {
            trace('calling asset $i');

            FlxGraphic.defaultPersist = true;
            switch(assetStack[i]) {
                case PreloadType.image:
                    var savedGraphic:FlxGraphic = FlxG.bitmap.add(Paths.image(i, 'shared'));
                    preloadedAssets.set(i, savedGraphic);
                    trace(savedGraphic + ', yeah its working');
                case PreloadType.atlas:
                    var preloadedCharacter:Character = new Character(FlxG.width / 2, FlxG.height / 2, i);
                    preloadedCharacter.visible = false;
                    add(preloadedCharacter);
                    trace('character loaded ${preloadedCharacter.frames}');
            }
            FlxGraphic.defaultPersist = false;
        
            countUp++;
            storedPercentage = countUp/maxCount;
            loadText.text = 'Loading... Progress at ${Math.floor(storedPercentage * 100)}%';
        }

        ///*
        FlxTween.tween(FlxG.camera, {alpha: 0}, 0.5, {
            onComplete: function(tween:FlxTween){
                //FlxG.sound.play(Paths.sound('confirmMenu'));
                MusicBeatState.switchState(new TitleState());
            }
        });
        //*/

    }
}