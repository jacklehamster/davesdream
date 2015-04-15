package  {
	
	import flash.display.MovieClip;
	
	
	public class RockHolder extends Wearable {
		
		override protected function processWithDude(dude:Dude):void {			
			visible = dude.usingItem=="rock";
		}
	}
	
}
