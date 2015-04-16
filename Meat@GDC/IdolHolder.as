package  {
	
	import flash.display.MovieClip;
	
	
	public class IdolHolder extends Wearable {
		
		
		override protected function processWithDude(dude:Dude):void {			
			visible = dude.usingItem=="idol";
		}
	}
	
}
