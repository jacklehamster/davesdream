package  {
	
	import flash.display.MovieClip;
	
	
	public class HourHand extends TimeHand {
		
		
		override protected function get timePercent():Number {
			var date:Date = new Date();
			var hour:Number = date.hours;
			var min:Number = date.minutes;
			var seconds:Number = date.seconds;
			return (hour%12 + (min+seconds/60)/60)/12;
		}
	}
	
}
