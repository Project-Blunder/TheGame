package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author sruloart
 */

class Enemy extends FlxSprite
{

	var _jump = false;
	var _sides = false;
	var _crouch = false;
	var _melee = false;
	var _shoot = false;
	var fire_ = false;
	
	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y);
	
		
		loadGraphic("assets/NinjaWorld/gallop.png", true, 32, 32, false);
		animation.add("Gallop", [0, 1, 2], 5, true);
	
		scale.set(3, 3);
		
		
		setFacingFlip(FlxObject.RIGHT, true, false);
		setFacingFlip(FlxObject.LEFT, false, false);
		
	}
	
	
	override public function update (elapsed:Float):Void
	{
		super.update(elapsed);
		
		life();	
		movement();
		attack();
		
	}
	
	public function life():Void
	{
		
	}
	
	public function movement():Void
	{
		
	
		function jump():Void
		{
			
			if (FlxG.keys.anyPressed(["UP", "W"])) 
				{
					
				}
					
		}
		
		function sides():Void
		{

			
		}
		
		function crouch():Void
		{
			
		}
	
	jump();
	sides();
	crouch();
	}
	
	
	public function attack():Void
	{
		
		function melee():Void
		{
			
		}
		
		function shoot():Void
		{
			
		}
		
		function fire():Void
		{
			
		}
	
	melee();
	shoot();
	fire();
		
	}
	
	
	
}