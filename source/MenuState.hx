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
import ice.entity.*;



/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		FlxG.camera.bgColor = FlxColor.BLUE;
		//Stops flixel from pausing the game when it loses focus, makes live-scripting 
		//much nicer
		FlxG.autoPause = false;
		
		//Adds the global entity manager to your PlayState
		add(EntityManager.instance);
		
		//Builds a scene from an XML entity declaration
		EntityManager.instance.BuildFromXML("assets/data/xmls/menustate/setup.xml");
		EntityManager.instance.BuildFromXML("assets/data/xmls/menustate/objects.xml");
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
		//FlxG.switchState(new PlayState());	
	}	
}