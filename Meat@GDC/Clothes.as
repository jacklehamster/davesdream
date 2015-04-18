package  {
	
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	
	
	public class Clothes extends Wearable {
		
		
		override protected function processWithDude(dude:Dude):void {
			gotoAndStop(1+((dude.id-1+totalFrames)%totalFrames));
		}
	}
	
}
