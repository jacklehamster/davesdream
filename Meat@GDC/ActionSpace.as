package  {
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import com.newgrounds.encoders.json.encodeJson;
	
	public class ActionSpace extends MovieClip {


		protected var frame:int;
		protected var registry:Object;
		static public var heroes:Object = {};
		static protected var rebirthCount:int = 0;
		private var repeater:Object;
		private var history:Array;
		static protected var global_history:Array = [];
		
		public function ActionSpace() {
			addEventListener(Event.ADDED_TO_STAGE,onStage);
			addEventListener(Event.REMOVED_FROM_STAGE,offStage);
		}

		protected function clearHistory():void {
			global_history = [];
			repeater = {};
			history = [];
			rebirthCount = 0;
		}
		
		protected function undo():void {
			var event:Object = history.pop();
//			trace("undo",encodeJson(event));
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
/*			trace("------------");
			trace("------------");
			trace(encodeJson(global_history));
			trace("------------");
			trace(encodeJson(repeater));
			trace("------------");
			trace("------------");*/
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
			Wearable.fullUpdate(dude);
			dude.model = model;
			dude.visible = true;
			addChildAt(dude,getChildIndex(model));
			return dude;
		}
		
		protected function createItem(modelName:String):HotObject {
			var model:HotObject = getChildByName(modelName) as HotObject;
			var object:HotObject = new (Object(model).constructor)();
			object.model = model;
			object.visible = true;
			addChildAt(object,getChildIndex(model));
			return object;
		}
		
		private function performEvent(event:Object):void {
			trace(encodeJson(event),registry[event.id] ? registry[event.id].model.name : "---");
			switch(event.action) {
				case "born":
					if(!registry[event.id]) {
						_born(createDude(event.model,event.id),event.attribute);
					}
					else {
						initializeDude(registry[event.id],event.attribute);
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
//			trace("ADDHISTORY",frame,encodeJson(event),encodeJson(repeater));
		}
		
		
		public function born(dude:Dude,attribute:Object = null):void {
			var delay:int = rebirthCount*15;
			registry[dude.id] = dude;
			if(!heroes[dude.id])
				heroes[dude.id] = new Hero();
			addHistory(frame+delay,
				{
					id:dude.id,
					action:"born",
					model:dude.model.name,
					attribute:attribute
				}
			);
		}
		
		private function _born(dude:Dude,attribute:Object):void {
			registry[dude.id] = dude;
			initializeDude(dude,attribute);
		}
		
		private function initializeDude(dude:Dude,attribute:Object):void {
			if(!heroes[dude.id])
				heroes[dude.id] = new Hero();
			for(var a:String in attribute) {
				dude[a] = attribute[a];
			}
			dude.born = frame;
			onBorn(dude);
		}
		
		protected function onBorn(dude:Dude):void {
			
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
					id:dude?dude.id:null,
					action:"action",
					model:hotObject==dude?null:hotObject.model.name,
					item:item
				}
			);
		}
		
		private function _disappear(dude:Dude):void {
			if(dude) {
				dude.stop();
				dude.visible = false;
				if(dude.hero)
					dude.hero.resetInventory();
				if(dude.parent)
					dude.parent.removeChild(dude);
				delete registry[dude.id];
				delete heroes[dude.id];
			}
		}
		
		protected function cantAccess(dude:Dude,hotObject:HotObject):Boolean {
			return false;
		}
		
		private function _mouseAction(dude:Dude,hotObject:HotObject,item:String):void {
			//trace("00000",dude?dude.model.name:null,hotObject,item);
			if(!dude) {
				if(hotObject && hotObject.direct) {
					var dude:Dude = new Dude();
					addChild(dude);
					dude.interact(hotObject);
				}
			}
			else if(dude.doomed) {
				//trace(dude.model.name,"DOOMED");
			}
			else if(dude && hotObject) {
				//trace(dude.inTransit,cantAccess(dude,hotObject),"||||");
				dude.usingItem = item;
				if(dude.inTransit || hotObject.direct || cantAccess(dude,hotObject)) {
					var hot:DisplayObject = hotObject.hotPos ? hotObject.hotPos : hotObject;
					var point:Point = globalToLocal(hot.localToGlobal(new Point()));
					dude.setDirection(point.x-dude.x);
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
