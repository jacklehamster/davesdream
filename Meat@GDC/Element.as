package  {
	import flash.display.MovieClip;
	import flash.display.FrameLabel;
	import com.newgrounds.encoders.json.encodeJson;
	import flash.events.Event;
	
	public class Element extends MovieClip {

		//	

		protected var frameInfos:Object = {};
		
		public function Element() {

			if(totalFrames>1) {
				var previousInfo:Object = null;
				for each(var label:FrameLabel in currentLabels) {
					//trace(label.name,label.frame,label);
					if(previousInfo) {
						previousInfo.end = label.frame-1;
					}
					var currentInfo:Object = frameInfos[label.name] = {
						label:label,
						start:label.frame
					};
					previousInfo = currentInfo;
				}
				if(previousInfo)
					previousInfo.end = totalFrames;
				//trace(encodeJson(frameInfos));
			}
			addEventListener(Event.ADDED_TO_STAGE,onStage);
			addEventListener(Event.REMOVED_FROM_STAGE,offStage);
		}
		
		private function onStage(e:Event):void {
			addEventListener(Event.ENTER_FRAME,onFrame);			
		}
		
		private function offStage(e:Event):void {
			stop();
			removeEventListener(Event.ENTER_FRAME,onFrame);
		}
		
		public function get master():Game {
			return parent as Game;
		}
		
		private function onFrame(e:Event):void {
			var info:Object = frameInfos[currentLabel];
			refresh();
			if(info && currentFrame==info.end) {
				onEndAnimation();
			}
		}
		
		protected function refresh():void {
		}
		
		protected function onEndAnimation():void {
		}

	}
	
}
