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

		private var interval:int = 0,interval2:int = 0;
		public var label:String = "OUT", label2:String = "BOSSTALK";
		
		public function Intro() {
			mouseChildren = false;
			var self:Intro = this;
			switchLabel(self,label);
			
			interval = setInterval(
				function():void {
					if(currentLabel=="INTRO") {
						if(Math.random()<.8) {
							label = label=="IN"?"OUT":"IN";
							switchLabel(self,label);
						}
					}
				},4000);
			interval2 = setInterval(
				function():void {
					if(currentLabel=="INTRO") {
						if(Math.random()<.5) {
							label2 = label2=="BOSSTALK"?"MEATTALK":"BOSSTALK";
							switchLabel(self,label2);
						}
					}
				},500);
			addEventListener(Event.REMOVED_FROM_STAGE,
				function(e:Event):void {
					clearInterval(interval);
					clearInterval(interval2);
				});
			addEventListener(MouseEvent.MOUSE_DOWN,
				function(e:MouseEvent):void {
					//(parent as MovieClip).nextScene();
					//return;
					switch(currentLabel) {
						case "INTRO1":
							gotoAndPlay("INTRO2");
							break;
						case "INTRO2":
							gotoAndPlay("INTRO3");
							break;
						case "INTRO3":
							gotoAndStop("INTRO");
							break;
						case "INTRO":
							mouseEnabled = false;
							play();
							mouseChildren = true;
							break;
						
					}
				});
		}
		
		static public function switchLabel(root:DisplayObjectContainer,label:String):void {
			for(var i:int=0;i<root.numChildren;i++) {
				var child:DisplayObjectContainer = root.getChildAt(i) as DisplayObjectContainer;
				if(child) {
					if((child is MovieClip) && hasLabel(child as MovieClip,label)) {
						(child as MovieClip).gotoAndPlay(label);
					}
					else {
						switchLabel(child,label);
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
