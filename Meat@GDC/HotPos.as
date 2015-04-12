package  {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	
	public class HotPos extends MovieClip {
		
		
		public var direction:int;
		public function HotPos() {
			visible = false;
			direction = globalToLocal(new Point(1,0)).x<0?-1:1;
		}
	}
	
}
