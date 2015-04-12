package  {
	
	public interface IMoveable {

		function setMover(mover:DudeMover):void;
		function get mover():DudeMover;
		function get inTransit():Boolean;
		function follow(mover:DudeMover):void;
	}
	
}
