package  {
	
	import flash.display.MovieClip;
	
	
	public class EmptyHolder extends Wearable {
		
		
		override protected function processWithDude(dude:Dude):void {			
			visible = !dude.usingItem;
		}
	}
	
}
