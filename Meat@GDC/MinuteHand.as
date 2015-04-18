package  {
	
	import flash.display.MovieClip;
	
	
	public class MinuteHand extends TimeHand {
		
		
		override protected function get timePercent():Number {
			var date:Date = new Date();
			var min:Number = date.minutes;
			var seconds:Number = date.seconds;
			return (min+seconds/60)/60;
		}
		
	}
	
}
