package  {
	
	import flash.display.MovieClip;
	
	
	public class Cheat extends HotObject {
		
		function Cheat() {
			visible = Game.DEBUG;
		}
		
		override public function get direct():Boolean {
			return true;
		}
		
	}
	
}
