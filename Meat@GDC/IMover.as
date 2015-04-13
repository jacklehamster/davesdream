package  {
	import flash.display.DisplayObject;
	
	public interface IMover extends IHotObject {

		function addMoveable(moveable:IMoveable,id:int):void;
		function removeMoveable(id:int):void;
		function get inTransit():Boolean;

	}
	
}
