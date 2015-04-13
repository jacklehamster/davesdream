package  {
	
	public interface IMoveable {

		function setMover(mover:IMover):void;
		function get mover():IMover;
		function get inTransit():Boolean;
		function follow(mover:IMover):void;
	}
	
}
