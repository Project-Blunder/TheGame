package;

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
		
		//Stops flixel from pausing the game when it loses focus, makes live-scripting 
		//much nicer
		FlxG.autoPause = false;
		
		//Adds the global entity manager to your PlayState
		add(EntityManager.instance);
		
		//Builds a scene from an XML entity declaration
		EntityManager.switchScene(["assets/data/xmls/playstate/setup.xml","assets/data/xmls/playstate/objects.xml"]);
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