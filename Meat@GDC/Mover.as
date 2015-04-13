package  {
	
	public class Mover extends HotObject 
		implements IMover
	{
		protected var moveables:Object = {};

		public function addMoveable(moveable:IMoveable,id:int):void
		{
			moveables[id] = moveable;
			moveable.follow(this);
		}
		
		public function removeMoveable(id:int):void
		{
			delete moveables[id];
		}
		
		public function get inTransit():Boolean {
			return false;
		}
		

	}
	
}
