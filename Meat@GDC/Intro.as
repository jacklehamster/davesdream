package  {
	
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.display.FrameLabel;
	import flash.events.Event;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	
	public class Intro extends MovieClip {

		public var label:String = "IN", label2:String = "BOSSTALK";
		
		public function Intro() {
			mouseChildren = false;
			var self:Intro = this;
			switchLabel(self,label,true);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouse);
		}
		
		private function onMouse(e:MouseEvent):void {
			e.currentTarget.removeEventListener(e.type,arguments.callee);
			MovieClip(root).nextScene();
		}
		
		static public function switchLabel(root:DisplayObjectContainer,label:String,doPlay:Boolean):void {
			for(var i:int=0;i<root.numChildren;i++) {
				var child:DisplayObjectContainer = root.getChildAt(i) as DisplayObjectContainer;
				if(child) {
					if((child is MovieClip) && hasLabel(child as MovieClip,label)) {
						if(doPlay)
							(child as MovieClip).gotoAndPlay(label);
						else
							(child as MovieClip).gotoAndStop(label);
					}
					else {
						switchLabel(child,label,doPlay);
					}
				}
			}
		}
		
		static private function hasLabel(mc:MovieClip,label:String):Boolean {
			for each(var frameLabel:FrameLabel in mc.currentLabels) {
				if(frameLabel.name==label)
					return true;
			}
			return false;
		}
	}
	
}
