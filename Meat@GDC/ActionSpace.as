package  {
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.display.DisplayObject;
	
	public class ActionSpace extends MovieClip {


		protected var frame:int;
		protected var registry:Object;
		private var repeater:Object;
		private var history:Array;
		static protected var global_history:Array = [];
		static protected var itemStatus:Object = {};
		
		public function ActionSpace() {
			addEventListener(Event.ADDED_TO_STAGE,onStage);
			addEventListener(Event.REMOVED_FROM_STAGE,offStage);
		}

		protected function clearHistory():void {
			global_history = [];
			repeater = {};
			history = [];
		}
		
		private function onStage(e:Event):void {
			frame = 0;
			registry = {};
			history = [];
			repeater = {};
			repeatHistory();
			global_history.push(history);
			addEventListener(Event.ENTER_FRAME,onFrame);
		}
		
		private function repeatHistory():void {
			for each(var array:Array in global_history) {
				for each(var entry:Object in array) {
					if(!repeater[entry.frame])
						repeater[entry.frame] = [];
					repeater[entry.frame].push(entry);
				}
			}
		}
		
		private function offStage(e:Event):void {
			removeEventListener(Event.ENTER_FRAME,onFrame);
		}
		
		private function onFrame(e:Event):void {
			if(repeater[frame]) {
				performHistory(repeater[frame]);
			}
			frame++;
		}
		
		private function performHistory(events:Array):void {
			for each(var event:Object in events) {
				performEvent(event);
			}
		}
		
		protected function createDude(modelName:String,id:int):Dude {
			var model:Dude = getChildByName(modelName) as Dude;
			var dude:Dude = new (Object(model).constructor)();
			if(id) {
				dude.id = id;
			}
			Clothes.updateClothes(dude);
			dude.model = model;
			dude.visible = true;
			addChildAt(dude,getChildIndex(model));
			return dude;
		}
		
		private function performEvent(event:Object):void {
			trace(JSON.stringify(event));
			switch(event.action) {
				case "born":
					if(!registry[event.id]) {
						_born(createDude(event.model,event.id));
					}
					for(var a:String in event.attribute) {
						registry[event.id][a] = event.attribute[a];
					}
					break;
				case "action":
					_mouseAction(registry[event.id],event.model?getChildByName(event.model) as HotObject:null,event.item);
					break;
				case "disappear":
					_disappear(registry[event.id]);
					break;
			}
		}
		
		private function addHistory(frame:int,event:Object):void {
			event.frame = frame;
			history.push(event);
			if(!repeater[frame]) {
				repeater[frame] = [];
			}
			repeater[frame].push(event);
		}
		
		
		public function born(dude:Dude,attribute:Object = null):void {
			registry[dude.id] = dude;
			addHistory(frame,
				{
					id:dude.id,
					action:"born",
					model:dude.model.name,
					attribute:attribute
				}
			);
		}
		
		private function _born(dude:Dude):void {
			registry[dude.id] = dude;
		}
		
		public function disappear(dude:Dude):void {
			addHistory(frame,
				{
					id:dude.id,
					action:"disappear"
				}
			);
		}
		
		public function mouseAction(dude:Dude,hotObject:HotObject,item:String):void {
			addHistory(frame,
				{
					id:dude.id,
					action:"action",
					model:hotObject==dude?null:hotObject.model.name,
					item:item
				}
			);
		}
		
		public function itemAction(dude:Dude,hotObject:HotObject,item:String):void {
			addHistory(frame,
				{
					id:dude.id,
					action:"item",
					model:hotObject==dude?null:hotObject.model.name,
					item:item
				}
			);
		}
		
		private function _disappear(dude:Dude):void {
			if(dude) {
				dude.stop();
				dude.visible = false;
				if(dude.parent)
					dude.parent.removeChild(dude);
				delete registry[dude.id];
			}
		}
		
		private function _mouseAction(dude:Dude,hotObject:HotObject,item:String):void {
			if(dude.doomed) {
			}
			else if(dude && hotObject) {
				dude.usingItem = item;
				if(dude.inTransit || hotObject.direct) {
					var hot:DisplayObject = hotObject.hotPos ? hotObject.hotPos : hotObject;
					var point:Point = globalToLocal(hot.localToGlobal(new Point()));
					var dx:Number = dude.x - point.x;
					if(dude.scaleX*dx<0) {
						dude.scaleX = -dude.scaleX;
					}
					if(hotObject.direct) {
						dude.interact(hotObject);
					}
				}
				else {
					dude.walkTo(hotObject);
				}
			}
			else if(dude && item) {
				dude.useItem(item);
			}
		}

	}
	
}
