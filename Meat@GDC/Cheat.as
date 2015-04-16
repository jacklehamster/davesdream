package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	
	public class Cheat extends HotObject {
		
		function Cheat() {
			visible = Game.DEBUG;
			if(visible) {
				stage.addEventListener(MouseEvent.MOUSE_DOWN,
					function(e:MouseEvent):void {
						e.currentTarget.removeEventListener(e.type,arguments.callee);
						visible = false;
					});
			}
		}
		
		override public function get direct():Boolean {
			return true;
		}
		
	}
	
}
