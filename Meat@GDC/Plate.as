package  {
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	public class Plate extends HotObject {

		public function Plate() {
			// constructor code
		}

		private var attachment:DisplayObject;
		public var balance:Balance;
				
		override protected function refresh():void {
			followAttachment();
		}
		
		private function followAttachment():void {
			if(attachment && master) {
				var point:Point = master.globalToLocal(attachment.localToGlobal(new Point()));
				x = point.x;
				y = point.y;
			}
		}
		
		public function attach(displayObject:DisplayObject):void {
			attachment = displayObject;
			followAttachment();
		}
		
		override public function get hotPos():HotPos {
			return balance.hotPos;
		}
		
	}
	
}
