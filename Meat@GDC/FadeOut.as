package  {
	
	import flash.display.MovieClip;
	
	
	public class FadeOut extends MovieClip {
		
		public var callback:Function = null;
		function FadeOut(callback:Function = null):void {
			this.callback = callback;
		}
	}
	
}
