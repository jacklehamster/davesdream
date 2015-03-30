package  {
	
	import flash.display.MovieClip;
	
	
	public class LeftDoor extends HotObject {
		
		
		override public function get hotPos():HotPos {
			return !root?null:MovieClip(root).currentLabel=="LEFTDOOR"?hotpos2:hotpos1;
		}
		
	}
	
}
