package  {
	
	import flash.display.MovieClip;
	
	
	public class Fire extends HotObject {
		
		
		public function Fire() {
			stop();
		}
		
		override public function canGo():Boolean {
			return currentLabel=="NONE";
		}
	}
	
}
