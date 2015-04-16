package  {
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	
	public class HotObject extends Element 
		implements IHotObject
	{

		private var _model:HotObject;
		public var scriptRunning:Object;
		public var activator:Dude;
		public var labelPlaying:String;
		
		private var _hotPos:HotPos;
		public var _id:int = id_counter++;;
		static public var id_counter:int = 1;
		
		protected var callback:Function = null;

		public function get id():int {
			return _id;
		}
		
		public function set id(value:int):void {
			_id = value;
		}
		
		
		public function HotObject() {
			stop();
			
			model = this;
			buttonMode = true;
			mouseEnabled = mouseChildren = false;
			
			for(var i:int=0;i<numChildren;i++) {
				if(getChildAt(i) is HotPos) {
					_hotPos = getChildAt(i) as HotPos;
				}
			}
		}
		
		public function set model(value:HotObject):void {
			_model = value;
			if(model!=this) {
				x = _model.x;
				y = _model.y;
				scaleX = _model.scaleX;
				scaleY = _model.scaleY;
			}
		}
		
		public function get model():HotObject {
			return _model;
		}
		
		public function setLabel(label:String,doplay:Boolean=true,callback:Function=null):void {
//			Debug.getStackTrace();
			if(doplay) {
				labelPlaying = label;
				if(currentLabel==label)
					play();
				else
					gotoAndPlay(label);
				this.callback = callback;
			}
			else {
				labelPlaying = null;
				gotoAndStop(label);
			}
		}
		
		public function set active(value:Boolean):void {
			if(mouseEnabled!=value) {
				mouseEnabled = value;
			}
		}
		
		public function activate():void {
			if(scriptRunning) {
				master.activateScript(scriptRunning,this,activator);
			}
		}
		
		public function deactivate():void {
			if(scriptRunning) {
				master.deactivateScript(scriptRunning,this,activator);
			}
		}
		
		public function updated():void {
			master.updateScript(this);
		}
		
		public function cancel():void {
			if(callback!=null) {
				callback = null;
			}
			if(scriptRunning) {
				scriptRunning = null;
				activator = null;
			}
			gotoAndStop(1);
		}
		
		override protected function onEndAnimation():void {
			stop();
			if(callback!=null) {
				var c:Function = callback;
				callback = null;
				c(this);
			}
			else if(scriptRunning) {
				var script:Object = scriptRunning;
				scriptRunning = null;
				var dude:Dude = activator;
				activator = null;
				labelPlaying = null;
				master.finishScript(script,this,dude);
			}
		}
		
		public function get hotPos():HotPos {
			return _hotPos;
		}
		
		public function get hot():DisplayObject {
			return hotPos ? hotPos : this;
		}
		
		public function get walkPoint():DisplayObject {
			return hot;
		}
		
		public function canInteract(dude:Dude):Boolean {
			return dude.distanceTo(this)<100;
		}
		
		public function distanceTo(object:IHotObject):Number {
			var hot:DisplayObject = object.walkPoint;
			var point:Point = master.globalToLocal(hot.localToGlobal(new Point()));
			return Point.distance(point,new Point(x,y));
		}
		
		public function get direct():Boolean {
			return false;
		}
		
		public function setDirection(dir:Number):void {
			if(scaleX*dir<0) {
				scaleX = -scaleX;
			}
		}
		
		public function setPosition(hotObject:HotObject,direction:Number=0):void {
			var hot:DisplayObject = hotObject.hot;
			var point:Point = master.globalToLocal(hot.localToGlobal(new Point()));
			x = point.x;
			y = point.y;
			setDirection(direction);
		}
		
		public function caughtDude():Boolean {
			return false;
		}

		override protected function refresh():void {
			if(scriptRunning && scriptRunning.refresh) {
				master.refresh(this,activator);
			}
		}
		
	}
	
}
