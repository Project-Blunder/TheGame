package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;
import flixel.group.FlxGroup; //If we don't import this, scripts wont be able to access it
import flixel.FlxSprite; //Same here
import flixel.math.FlxRandom;//^
import ice.entity.EntityManager;
import ice.entity.*;
import ice.group.EntityGroup;
import ice.wrappers.FlxKeyWrap;
import ice.wrappers.FlxColorWrap;
import Reg;

/**
 * A FlxState which can be used for the game's menu.
 */
class SceneLoader extends FlxState
{
	
	public static var debug:Debug;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		//Stops flixel from pausing the game when it loses focus, makes live-scripting 
		//much nicer
		FlxG.autoPause = false;
		
		//Adds the global entity manager to your play
		add(EntityManager.instance);
		
		debug = new Debug();
		add(debug);
		
		//Builds a scene from an XML entity declaration
		EntityManager.instance.BuildFromXML("assets/scenes/menu/setup.xml");
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
		if (FlxG.keys.justPressed.TAB)
		{
			Reg.showDebug = !Reg.showDebug;
			if (!Reg.showDebug)
			{
				SceneLoader.debug.clear();
			}
		}
		if (Reg.showDebug)
		{
			SceneLoader.debug.clear();
		}
		
		super.update(elapsed);
	}	
}