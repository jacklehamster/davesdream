package  {
	import flash.geom.Point;
	
	public class Moveable extends HotObject
		implements IMoveable
	{

		protected var dudemover:IMover;
		
		
		
		public function setMover(mover:IMover):void {
			if(dudemover) {
				dudemover.removeMoveable(id);
			}
			dudemover = mover;
			if(dudemover) {
				dudemover.addMoveable(this,id);
			}
		}
		
		public function get mover():IMover {
			return dudemover;
		}
		
		public function get inTransit():Boolean {
			return dudemover && dudemover.inTransit;
		}
		
		public function follow(mover:IMover):void {
			if(!master) {
				setMover(null);
			}
			else {
				var point:Point = master.globalToLocal(mover.hot.localToGlobal(new Point()));
				x = point.x;
				y = point.y;
			}
		}
	}
	
}
