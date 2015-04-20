package  {
	
	import flash.display.MovieClip;
	
	
	public class Bed extends HotObject {
		
		
		override public function caughtDude():Boolean {
			return currentLabel=="SLEEP";
		}
	}
	
}
