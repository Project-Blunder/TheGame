package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.group.FlxGroup; //If we don't import this, scripts wont be able to access it
import flixel.FlxSprite; //Same here
import flixel.math.FlxRandom; //^
import flixel.util.FlxColor;
import ice.entity.EntityManager;
import ice.entity.*;
import openfl.geom.Point;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	var init:Bool = false;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		//Music theme (very partial first draft!) - the idea is that the tempo can get faster and faster
		//with the level of intensity
		#if web
		FlxG.sound.playMusic("assets/music/graveytheme.wav", 1, true); //wav doesn't work properly on native (yet)
		#end
		
		#if native
		//FlxG.sound.playMusic("assets/music/graveytheme.ogg", 1, true); //Stutters on neko, weird on Windows
		#end
		
		//Stops flixel from pausing the game when it loses focus, makes live-scripting 
		//much nicer
		FlxG.autoPause = false;
		
		//Adds the global entity manager to your PlayState
		add(EntityManager.instance);
		
		//Builds a scene from an XML entity declaration
		EntityManager.switchScene(["assets/data/xmls/playstate/setup.xml"]);
		
		FlxG.camera.height = Std.int(FlxG.height / 2.5);
		FlxG.camera.y = (FlxG.height / 2 - FlxG.camera.height / 2) * FlxG.camera.zoom;
		
		Reg.start = FlxG.camera.y / FlxG.camera.zoom;
		//OOOOOHHH AHHHHH
		/*||||MAGIC||||*/Reg.height = FlxG.camera.y / FlxG.camera.zoom + FlxG.camera.height / FlxG.camera.zoom - 5;
		//IT NEEDS CHANGES ALL THE TIMMMMEEEEEE
		FlxG.log.add(Reg.height);
		
		//FlxG.camera.follow(EntityManager.instance.GetEntityByTag("player"));//Just thinking about taking the player to an adventure
		
		
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}	
}