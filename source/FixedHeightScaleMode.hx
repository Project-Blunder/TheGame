package;
 
import flixel.FlxG;
import flixel.system.scaleModes.BaseScaleMode;
 
class FixedHeightScaleMode extends BaseScaleMode
{
	override private function updateGameSize(Width:Int, Height:Int):Void
	{
		var oldWidth:Int = FlxG.camera.width;
		var newWidth:Int = Math.ceil(FlxG.stage.stageWidth / FlxG.camera.zoom);
	   
		gameSize.x = newWidth;
		gameSize.y = FlxG.height;
	   
		FlxG.camera.width = newWidth;
		FlxG.camera.scroll.x += 0.5 * (oldWidth - newWidth);
	}
   
	override function updateScaleOffset():Void
	{
		scale.set(1, 1);
	   
		offset.x = 0;
		offset.y = 0.5 * (FlxG.stage.stageHeight - FlxG.camera.height * FlxG.camera.zoom);
	}
}