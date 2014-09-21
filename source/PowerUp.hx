package ;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @sruloart
 */

class PowerUp extends FlxSprite
{

	
	public function new(X:Float=0, Y:Float=0, P: Power) 
	{
		super(X, Y);
		
		
		
	}
	
	public function movement():Void
	{
	
	}
	
	public function 
	
}

enum Power 
{
	Life;
	Ammo;
	Bomb;
	Weapon;
}