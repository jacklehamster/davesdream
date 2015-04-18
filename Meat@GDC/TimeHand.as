package  {
	
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	
	
	public class TimeHand extends MovieClip {
		
		var timer:Timer = new Timer(1000);
		
		public function TimeHand() {
			addEventListener(Event.ADDED_TO_STAGE,onStage);
			addEventListener(Event.REMOVED_FROM_STAGE,offStage);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			tick();
		}
		
		private function onTimer(e:TimerEvent):void {
			tick();
		}
		
		private function onStage(e:Event):void {
			timer.reset();
			timer.start();
		}
		
		private function offStage(e:Event):void {
			timer.stop();
		}
		
		protected function get timePercent():Number {
			return 0;
		}
		
		protected function tick():void {
			gotoAndStop(1+int(timePercent*totalFrames));
		}
	}
	
}
