package ;

import flixel.FlxG;
import flixel.math.FlxRandom;
import ice.entity.Entity;
import ice.entity.EntityManager;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.math.FlxPoint;
import Reg;
import Std;
import Math;

class setup
{
	public function init() 
	{	
		FlxG.camera.bgColor = 0xffffffff;
		FlxG.mouse.visible = false;
		
		//Music theme (very partial first draft!) - the idea is that the tempo can get faster and faster
		//with the level of intensity
		if (Reg.flash)
		{
		var music = FlxG.sound.load("assets/music/3bztheme.mp3",1,true,false,true);	
		}
		
		if (!Reg.flash)
		{
		var music = FlxG.sound.load("assets/music/3bztheme.ogg", 1, true, false, true);	
		}
		//FlxG.sound.playMusic("assets/music/graveytheme.wav", 1, true); //wav doesn't work properly on native (yet)
		
		
		
		
		if(!Reg.html)
		FlxG.scaleMode = new RatioScaleMode(true);
		
		FlxG.camera.height = Math.floor(FlxG.height / 2.5);
		FlxG.camera.y = (FlxG.height / 2 - FlxG.camera.height / 2) * FlxG.camera.zoom;
		
		Reg.start = FlxG.camera.y / FlxG.camera.zoom;
		//OOOOOHHH AHHHHH
		/*||||MAGIC||||*/Reg.height = FlxG.camera.y / FlxG.camera.zoom + FlxG.camera.height / FlxG.camera.zoom - 5;
		//IT NEEDS CHANGES ALL THE TIMMMMEEEEEE
		
		if(Reg.html)
		Reg.height = FlxG.camera.y / FlxG.camera.zoom + FlxG.camera.height / FlxG.camera.zoom + 5;
		
		FlxG.camera.follow(EntityManager.instance.GetEntityByTag("player"), null, FlxPoint.get(0, Reg.start + 100));
		FlxG.camera.setScrollBoundsRect( -FlxG.width, 0, FlxG.width * 3, FlxG.height);
		
		
		for (e in EntityManager.instance.bg.members )
		{
			e.scrollFactor.x = 0.5;
			e.alpha = 0.1;	
		}
		
		//Random Spattering Test
		/*for (i in 0...20)
		{
			var r = Math.floor(new FlxRandom().float(0, 5));
			var s = "assets/scenes/play/images/Monument.png";
			switch(r)
			{
				case 0: 
					s = "assets/scenes/play/images/Monument.png";
				case 1: 
					s = "assets/scenes/play/images/Bonsai.png";
				case 2: 
					s = "assets/scenes/play/images/Grass01.png";
				case 3: 
					s = "assets/scenes/play/images/Grass02.png";
				case 4: 
					s = "assets/scenes/play/images/rock.png";
				case 5: 
					s = "assets/scenes/play/images/rock1.png";
			}
			var p:Entity = new Entity();
			p.loadGraphic(s);
			p.scrollFactor.x = 0.5;
			p.y = Reg.height - p.height;
			p.x = i * p.width + 2;
			p.alpha = 0.1;	
			EntityManager.instance.AddEntity(p, 0);
		}*/
	}
}