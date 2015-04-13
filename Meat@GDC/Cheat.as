package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	public class Cheat extends HotObject {
		
		function Cheat() {
			visible = Game.DEBUG;
			addEventListener(MouseEvent.MOUSE_DOWN,
				function(e:MouseEvent):void {
					visible = false;
				});
		}
		
		override public function get direct():Boolean {
			return true;
		}
		
	}
	
}
