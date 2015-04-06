package  {
	import flash.display.MovieClip;
	import flash.display.FrameLabel;
	
	public class Element extends MovieClip {

		//	
		
		protected var frameInfos:Object = {};
		
		public function Element() {
			var previousInfo:Object = null;
			for each(var label:FrameLabel in currentLabels) {
				trace(label.name,label.frame,label);
				if(previousInfo) {
					previousInfo.end = label.frame-1;
				}
				var currentInfo:Object = frameInfos[label.name] = {
					label:label,
					start:label.frame
				};
				previousInfo = currentInfo;
			}
			previousInfo.end = totalFrames;
			trace(frameInfos);
		}

	}
	
}
