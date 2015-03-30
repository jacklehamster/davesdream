package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class HotObject extends MovieClip{

		public var model:HotObject;
		private var _hotPos:HotPos;
		public var activator:Meatly;
		public var scriptRunning:Object;
		public var id:String = null;
		public var occupied:Boolean;
		public var blocked:Boolean;
		
		public function HotObject() {
			activator = null;
			model = this;
			buttonMode = true;
			mouseEnabled = mouseChildren = false;
			addEventListener(MouseEvent.MOUSE_DOWN,
				function(e:MouseEvent):void {
					(parent as Game).handlePress(self);
				});
			stop();
				
			for(var i:int=0;i<numChildren;i++) {
				if(getChildAt(i) is HotPos) {
					_hotPos = getChildAt(i) as HotPos;
				}
			}
		}
		
		public function get hotPos():HotPos {
			return _hotPos;
		}
		
		protected function get self():HotObject {
			return this;
		}
		
		public function get ClassObj():Class {
			return Object(this).constructor;
		}
		
		public function get master():Game {
			return parent as Game;
		}
		
		public function canGo():Boolean {
			return true;
		}
		
		public function forceScriptEnd():void {
			master.scriptEnded(self);
		}
		
		public function runScript(label:Object=null,noEnd:Boolean= false):void {
			if(!label) {
				play();
			}
			else {
				gotoAndPlay(label);
			}
			addEventListener(Event.ENTER_FRAME,
				function(e:Event):void {
					if(currentFrameLabel=="ACTIVATE") {
						master.activate(self);
					}
					if(currentFrame==totalFrames) {
						e.currentTarget.removeEventListener(e.type,arguments.callee);
						if(!noEnd)	
							master.scriptEnded(self);
					}
				});
		}

	}
	
}
