package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	public class Dog extends HotObject {
		
		public function Dog():void {
			addEventListener(MouseEvent.ROLL_OVER,
				function(e:MouseEvent):void {
					master.mouseAction(null,e.currentTarget as HotObject,null);
				});
		}
		
		override public function get direct():Boolean {
			return true;
		}
	}
	
}
