package  {
	
	import flash.display.MovieClip;
	
	
	public class SpearHolder extends Wearable {
		
		
		override protected function processWithDude(dude:Dude):void {			
			visible = dude.usingItem=="spear";
		}
	}
	
}
