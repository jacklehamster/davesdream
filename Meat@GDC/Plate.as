package  {
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	public class Plate extends Mover {

		public function Plate() {
			// constructor code
		}

		private var attachment:DisplayObject;
		public var balance:Balance;
				
		override protected function refresh():void {
			followAttachment();
			for each(var moveable:IMoveable in moveables) {
				moveable.follow(this);
			}
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
		
		override public function get walkPoint():DisplayObject {
			return balance.walkPoint;
		}
		
		override public function addMoveable(moveable:IMoveable,id:int):void
		{
			super.addMoveable(moveable,id);
			balance.updateBalance();
		}
		
		override public function removeMoveable(id:int):void {
			super.removeMoveable(id);
			balance.updateBalance();
		}
		
		public function get weight():Number {
			var w:Number = .3;
			for each(var moveable:IMoveable in moveables) {
				if(moveable) {
					if(!(moveable as HotObject).master) {
						moveable.setMover(null);
					}
					else if(moveable is Dude) {
						w ++;
						if((moveable as Dude).hero && (moveable as Dude).hero.hasItem("rock")) {
							w+=1.5;
						}
					}
					else if(moveable is Rock) {
						w+=1.5;
					}
				}
			}
			return w;
		}
	}
	
}
