package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	import flash.display.DisplayObject;
	import com.newgrounds.encoders.json.encodeJson;
	
	
	public class Game extends ActionSpace {
		
		static public const DEBUG:Boolean = true;
		
		static public var persisted_id:int = 0;
		public var mainCharacter:Dude;
		
		protected var scripts:Object = {};
		private var blockedAreas:Object = {};
		private var detectAreas:Object = {};
		
		static public var currentLevel:String;
		static protected var lastLevel:String;
		
		static public var instance:Game;
		
		static public var levelsToSolve:Array = [];
		public var crawlScene:Boolean = false;
		
		public function Game() {
			addEventListener(Event.ADDED_TO_STAGE,onStage);
			addEventListener(Event.REMOVED_FROM_STAGE,offStage);
			
			for(var i:int=0;i<numChildren;i++) {
				var child:DisplayObject = getChildAt(i);
				if(child is Blocker) {
					blockedAreas[child.name] = child.getRect(this);
				}
				if(child is Detector) {
					detectAreas[child.name] = child.getRect(this);
				}
			}
		}
		
		private function getLevelIndex(level:String):int {
			for(var i=0;i<levelsToSolve.length;i++) {
				if(levelsToSolve[i].name==level)
					return i;
			}
			return -1;
		}
		
		public function initialize():void {

			var level:String = MovieClip(root).currentScene.name;
			var levelIndex:int = getLevelIndex(level);
			if(levelIndex<0) {
				levelsToSolve.push(
					{
						name:level,
						index:levelsToSolve.length,
						solved:false
					}
				);
			}
			
			if(solvedLevel) {
				clearHistory();
			}
			
			if(!scripts.scene.noFadein)
				MovieClip(root).addChild(new FadeIn());
			if(scripts.scene && scripts.scene.initialize) {
				scripts.scene.initialize();
			}
			mainHero.addEventListener(Event.CHANGE,onInventoryChange);
			if(!scripts.scene.noNeedRemote) {
				mainHero.pickupItem("timeRemote");
			}
			
			
			persisted_id = 0;
		}
		
		public function gameOver(dude:Dude):void {
			var script:Object = scripts[dude.model.name];
			if(script && script.preDestroy) {
				script.preDestroy(dude);
			}
			if(dude==mainCharacter) {
				mainHero.removeEventListener(Event.CHANGE,onInventoryChange);
				setDude(null,dude.id);
				disappear(dude);
				Inventory.instance.updateInventory([]);
				ActionSpace.heroes = {};
				MovieClip(root).addChild(new FadeOut(
					function():void {
						MovieClip(root).gotoAndPlay(1,"ResetLevel");
					}
				));
			}
		}
		
		private function onInventoryChange(e:Event):void {
			inventory.updateInventory(mainHero.items);
		}
		
		private function onStage(e:Event):void {
			instance = this;
			currentLevel = MovieClip(root).currentScene.name;
			initialize();
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouse);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouse);
			if(!scripts.scene.nonStop)
				MovieClip(root).stop();
		}
		
		private function offStage(e:Event):void {
			if(mainHero)
				mainHero.removeEventListener(Event.CHANGE,onInventoryChange);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,onMouse);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouse);
		}
		
		private function onMouse(e:MouseEvent):void {
			if(e.buttonDown) {
				if(mainCharacter && mainCharacter.visible) {
					var hotObject:HotObject = e.target as HotObject;
					if(hotObject) {
						var item:String = inventory.activeItem;
						inventory.setCursor(null);
						mouseAction(mainCharacter,hotObject,item);
					}
					else {
						//mainCharacter.walkTo(mouseX,mouseY);
					}
				}
			}
		}
		
		override protected function cantAccess(dude:Dude,hotObject:HotObject):Boolean {
			var script:Object = scripts[hotObject.model.name];
			if(script && script.cantAccess && script.cantAccess(hotObject,dude)) {
				return true;
			}
			return false;
		}
		
		protected function setDude(name:String,id:int):Dude {
			var model:Dude = name?getChildByName(name) as Dude:null;
			var dude:Dude = registry[id];
			var direction:Number = 0;
			
			if(dude) {
				direction = dude.scaleX;
				if(dude.model!=model) {
					dude.parent.removeChild(dude);
					dude = null;
					registry[id] = null;
				}
			}
			if(!dude && model) {
				dude = createDude(model.name,id);
				registry[dude.id] = dude;
			}
			if(dude) {
				dude.setDirection(direction);
				dude.visible = true;
			}
			if(!mainCharacter || !dude || mainCharacter.id==dude.id) {
				mainCharacter = dude;
				resetHotspots();
			}
			return dude;
		}
				
		public function resetHotspots():void {
			var dude:Dude = mainCharacter;
			if(dude) {
				var script:Object = scripts[dude.model.name];
				var hotspots:Array = script?script.hotspots:null;
				if(!hotspots) {
					hotspots = [];
					trace("NO SCRIPT OR NO HOTSPOTS FOR",dude.model.name);
				}
				var sceneHotSpots = scripts.scene.hotspots;
				if(sceneHotSpots) {
					hotspots = hotspots.concat(sceneHotSpots);
				}
				
				var hash:Object = {};
				for each(var spot:String in hotspots) {
					hash[spot] = true;
				}
				for(var i:int=0;i<numChildren;i++) {
					var hotSpot:HotObject = getChildAt(i) as HotObject;
					if(hotSpot) {
						hotSpot.active = hash[hotSpot.model.name] ||
							hotSpot==mainCharacter && inventory && inventory.activeItem;
					}
				}
			}
		}
		
		public function finishScript(script:Object,hotObject:HotObject,dude:Dude):void {			
			if(script.end) {
				script.end.call(this,hotObject,dude);
			}
		}
		
		public function activateScript(script:Object,hotObject:HotObject,dude:Dude):void {
			if(script.activate) {
				script.activate.call(this,hotObject,dude);
			}
		}
		
		public function deactivateScript(script:Object,hotObject:HotObject,dude:Dude):void {
			if(script.deactivate) {
				script.deactivate.call(this,hotObject,dude);
			}
		}
		
		public function updateScript(hotObject:HotObject):void {
			var script:Object = scripts[hotObject.model.name];
			if(script.updated) {
				script.updated.call(this,hotObject);
			}
		}
		
		public function action(hotObject:HotObject,dude:Dude,item:String):void {
			
			var script:Object = scripts[hotObject.model.name];
			if(script) {
				if(script.action || item && script.combo && script.combo[item]) {
					if(hotObject.scriptRunning) {
						if(hotObject.activator==dude) {
							return;
						}
						else if(hotObject.activator==mainCharacter) {
							hotObject.cancel();
							rescue();
						}
						else if(dude==mainCharacter) {
							return;
						}
					}
					hotObject.scriptRunning = script;
					hotObject.activator = dude;
					if(!item) {
						script.action.call(this,hotObject,dude);
					}
					else {
						var subscript:Object = script.combo ? script.combo[item] : null;
						if(subscript && subscript.action) {
							hotObject.scriptRunning = subscript;
							subscript.action.call(this,hotObject,dude);
						}
					}
				}
				else {
					trace("NO ACTION FOR",hotObject.model.name);
				}
			}
			else {
				trace("NO SCRIPT FOR",hotObject.model.name);
			}
		}
		
		private function rescue():void {
			mainCharacter.doomed = false;
			mainCharacter.visible = true;
			undo();
		}
		
		public function failaction(hotObject:HotObject,dude:Dude,item:String):void {
			var script:Object = scripts[hotObject.model.name];
			if(script || item && script.combo && script.combo[item]) {
				if(hotObject.scriptRunning) {
					if(hotObject.activator==dude) {
						return;
					}
					else if(hotObject.activator==mainCharacter) {
						hotObject.cancel();
						rescue();
					}
					else if(dude==mainCharacter) {
						return;
					}
				}
				hotObject.scriptRunning = script;
				hotObject.activator = dude;
				if(!item) {
					if(script.failaction) {
						script.failaction.call(this,hotObject,dude);
					}
				}
				else {
					var subscript:Object = script.combo[item];
					if(subscript && subscript.failaction) {
						hotObject.scriptRunning = subscript;
						subscript.failaction.call(this,hotObject,dude);
					}
				}
			}
			else {
				trace("NO SCRIPT FOR",hotObject.model.name);
			}
		}
		
		public function canGo(dude:Dude,x:Number,y:Number):Boolean {
			for (var name:String in blockedAreas) {
				var rect:Rectangle = blockedAreas[name];
				if(rect.contains(x,y)) {
					script = scripts[name];
					if(script && script.inactive && script.inactive(dude)) {
						continue;
					}
					return false;
				}
			}
			var script:Object = scripts[dude.model.name];
			if(script && script.cantWalk && script.cantWalk(dude))
				return false;
			return true;
		}
		
		public function detect(dude:Dude,x:Number,y:Number):void {
			for (var name:String in detectAreas) {
				var rect:Rectangle = detectAreas[name];
				if(rect.contains(x,y)) {
					var script:Object = scripts[name];
					if(script && script.detect) {
						script.detect(dude);
					}
				}
			}
		}
		
		public function preVanish(dude:Dude):void  {
			var script:Object = scripts[dude.model.name];
			if(script && script.preVanish)
				script.preVanish(dude);
		}
		
		protected function caught(detectorName:String):Array {
			var array:Array = [];
			var rect:Rectangle = detectAreas[detectorName];
			for(var i:int=0;i<numChildren;i++) {
				var dude:Dude = getChildAt(i) as Dude;
				if(dude && !dude.doomed && dude.currentLabel!="BURIED" && rect.contains(dude.x,dude.y)) {
					array.push(dude);
				}
			}
			return array;
		}
		
		public function gotoScene(scene:String,fade:Boolean=true):void {
			lastLevel = currentLevel;

			var func:Function = function():void {
				persisted_id = mainCharacter.id;
				clearHistory();
				MovieClip(root).gotoAndStop(1,scene);
			}
			
			if(fade) {
				MovieClip(root).addChild(new FadeOut(func));
			}
			else {
				func();
			}
		}
		
		protected function get inventory():Inventory {
			return root?MovieClip(root).inventory:null;
		}
		
		protected function solveLevel():void {
			var level:String = MovieClip(root).currentScene.name;
			var levelIndex:int = getLevelIndex(level);
			levelsToSolve[levelIndex].solved = true;
		}
		
		protected function get solvedLevel():Boolean {
			var level:String = MovieClip(root).currentScene.name;
			var levelIndex:int = getLevelIndex(level);
			return levelsToSolve[levelIndex] && levelsToSolve[levelIndex].solved;
		}
		
		public function get mainHero():Hero {
			return mainCharacter ? mainCharacter.hero : null;
		}
	}
	
}
