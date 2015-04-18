package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.events.TextEvent;
	
	
	public class DialogChooser extends MovieClip {
		
		static const STOPPER:Array = [-330,0,330];
		private var dragPoint:Point = null;
		private var goalPoint:Point = null;
		
		public function DialogChooser() {
			visible = false;
			left.buttonMode = true;
			right.buttonMode = true;
			bubble.buttonMode = true; bubble.textslide.mouseChildren = false;
			left.addEventListener(MouseEvent.MOUSE_DOWN,onMouse);
			right.addEventListener(MouseEvent.MOUSE_DOWN,onMouse);
			bubble.addEventListener(MouseEvent.MOUSE_DOWN,onDrag);
			goalPoint = new Point(bubble.textslide.x);
			
			addEventListener(Event.ENTER_FRAME,onFrame);
		}
		
		private function onMouse(e:MouseEvent):void {
			switch(e.currentTarget) {
				case left:
					goalPoint.x -= 330;
					break;
				case right:
					goalPoint.x += 330;
					break;
			}
		}
		
		private function onDrag(e:MouseEvent):void {
			dragPoint = new Point(e.stageX,e.stageY);
			goalPoint = new Point(bubble.textslide.x,bubble.textslide.y);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onStopDrag);
			stage.addEventListener(Event.MOUSE_LEAVE,onStopDrag);
		}
		
		private function onMove(e:MouseEvent):void {
			goalPoint.x += 2*(e.stageX-dragPoint.x);
			dragPoint.x = e.stageX;
		}
		
		private function onStopDrag(e:Event):void {
			if(bubble.bubble.currentLabel=="OK") {
				dispatchEvent(new TextEvent(TextEvent.LINK,false,false,bubble.textslide.mid.tfmiddle.text));
			}			
			dragPoint = null;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onStopDrag);
			stage.removeEventListener(Event.MOUSE_LEAVE,onStopDrag);
			
			var closestIndex:int = -1;
			var closestDist:Number = Number.MAX_VALUE;
			for(var i:int=0;i<STOPPER.length;i++) {
				var pos:Number = STOPPER[i];
				var dist:Number = Math.abs(goalPoint.x - pos);
				if(dist<closestDist) {
					closestDist = dist;
					closestIndex = i;
				}
			}
			if(closestIndex>=0) {
				goalPoint.x = STOPPER[closestIndex];
			}
		}
		
		private function onFrame(e:Event):void {
			var dx:Number = (goalPoint.x-bubble.textslide.x);
			if(Math.abs(dx)>5) {
				bubble.textslide.x += dx/4;
			}
			else {
				bubble.textslide.x = goalPoint.x;
			}
			if(bubble.textslide.x<-200) {
				//	shift
				var temp:String = bubble.textslide.left.tfleft.text;
				bubble.textslide.left.tfleft.text = bubble.textslide.mid.tfmiddle.text;
				bubble.textslide.mid.tfmiddle.text = bubble.textslide.right.tfright.text;
				bubble.textslide.right.tfright.text = temp;
				bubble.textslide.x += 330;
				goalPoint.x += 330;
			}
			else if(bubble.textslide.x>200) {
				//	shift
				temp = bubble.textslide.right.tfright.text;
				bubble.textslide.right.tfright.text = bubble.textslide.mid.tfmiddle.text;
				bubble.textslide.mid.tfmiddle.text = bubble.textslide.left.tfleft.text;
				bubble.textslide.left.tfleft.text = temp;
				bubble.textslide.x -= 330;
				goalPoint.x -= 330;
			}
			bubble.bubble.gotoAndStop(Math.abs(bubble.textslide.x)<1?"OK":"WAIT");
		}
		
		
	}
	
}
