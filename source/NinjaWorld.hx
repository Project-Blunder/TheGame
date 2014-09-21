package ;

import flixel.addons.ui.FlxButtonPlus;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.system.scaleModes.FillScaleMode;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.FlxCamera;
import flixel.util.FlxColor;

import flixel.text.FlxBitmapTextField;

using flixel.util.FlxSpriteUtil;



/**
 * ...
 * @sruloart
 */

class NinjaWorld extends FlxState
{

	public var gameCamera: FlxCamera;
	public var HUDCamera: FlxCamera;
	
	var player: Player;
	var pauseToggle: FlxSprite;
	var mutte: FlxSprite;
	
	var timee: FlxText;

	
	override public function create():Void
	{
	
		//FlxG.scaleMode = new StageSizeScaleMode();

		gameCamera = new FlxCamera(0, 146, 0, 192);
		gameCamera.bgColor = FlxColor.WHITE;
	
		HUDCamera = new FlxCamera(0, 80, 0, 66);
		HUDCamera.bgColor = FlxColor.TRANSPARENT;
		
		
		FlxG.cameras.add(gameCamera);
		FlxG.cameras.add(HUDCamera);
		FlxCamera.defaultCameras = [gameCamera, HUDCamera]; //if you don't add it, it would be replicated on FlxG.camera as well
		
		
		super.create();
		
		
		player = new Player(FlxG.width / 2 - 40, 146);
		player._cameras = [gameCamera];
		
		add(player);
		
		
		pauseToggle = new FlxSprite(600, 20);
		pauseToggle._cameras = [HUDCamera];
		pauseToggle.scale.set(1.5, 1.5);
		pauseToggle.loadGraphic("assets/NinjaWorld/pauseToggle.png", true, 32, 32);
		pauseToggle.animation.add("play", [3, 4, 5], 6, true);
		pauseToggle.animation.play("play");
		add(pauseToggle);
		
		
		mutte = new FlxSprite(20, 20);
		mutte._cameras = [HUDCamera];
		mutte.scale.set(2, 2);
		mutte.loadGraphic("assets/NinjaWorld/mutte.png", true, 32, 32);
		mutte.animation.add("music", [0, 1, 2], 6, true);
		mutte.animation.play("music");
		add(mutte);
		
		
		timee = new FlxText(0, 20, 0, "0:00", 32, true);
		timee.font = "assets/fonts/PixAntiqua.ttf";
		timee._cameras = [HUDCamera];
		timee.screenCenter(true,false);
		add(timee);
	}
	
	
	override public function destroy():Void
	{
		super.destroy();
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
	}
	
}