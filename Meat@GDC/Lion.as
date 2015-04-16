package  {
	
	public class Lion extends HotObject {

		public var caught:Dude = null;

		override public function caughtDude():Boolean {
			return caught!=null;
		}
	}
	
}
