package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	import fl.transitions.easing.Strong;
	
	
	public class Game extends ActionSpace {
		
		static public const DEBUG:Boolean = true;
		
		static public var persisted_id:int = 0;
		public var mainCharacter:Dude;
		
		protected var scripts:Object = {};
		private var blockedAreas:Array = [];
		
		static public var currentLevel:String;
		static protected var lastLevel:String;
		
		static public var instance:Game;
		
		static public var levelsToSolve:Array = [];
		
		public function Game() {
			addEventListener(Event.ADDED_TO_STAGE,onStage);
			addEventListener(Event.REMOVED_FROM_STAGE,offStage);
			
			for(var i:int=0;i<numChildren;i++) {
				if(getChildAt(i) is Blocker) {
					var rect:Rectangle = getChildAt(i).getRect(this);
					blockedAreas.push(rect);
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
			persisted_id = 0;
		}
		
		public function gameOver(dude:Dude):void {
			var script:Object = scripts[dude.model.name];
			if(script.preDestroy) {
				script.preDestroy(dude);
			}
			if(dude==mainCharacter) {
				setDude(null,dude.id);
				disappear(dude);
				MovieClip(root).addChild(new FadeOut(
					function():void {
						Hero.instance.resetInventory();
						MovieClip(root).gotoAndPlay(1,"ResetLevel");
					}
				));
			}
		}
		
		private function onStage(e:Event):void {
			instance = this;
			MovieClip(root).stop();
			currentLevel = MovieClip(root).currentScene.name;
			initialize();
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouse);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouse);
		}
		
		private function offStage(e:Event):void {
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,onMouse);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouse);
		}
		
		private function onMouse(e:MouseEvent):void {
			if(e.buttonDown) {
				if(mainCharacter) {
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
				if(script) {
					var hotspots:Array = script.hotspots;
					if(hotspots) {

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
									hotSpot==mainCharacter && Inventory.instance.activeItem;
							}
						}
					}
					else {
						trace("NO HOTSPOTS FOR",dude.model.name);
					}
				}
				else {
					trace("NO SCRIPT FOR",dude.model.name);
				}
			}
		}
		
		public function finishScript(script:Object,hotObject:HotObject,dude:Dude):void {
			if(script.end) {
				script.end.call(this,hotObject,dude);
			}
			if(mainCharacter && dude.id==mainCharacter.id) {
				unblock();
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
				if(script.action) {
					if(hotObject.scriptRunning) {
						if(hotObject.activator==mainCharacter) {
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
						var subscript:Object = script[item];
						if(subscript && subscript.action) {
							subscript.action.call(this,hotObject,dude);
						}
					}
					if(mainCharacter && dude.id==mainCharacter.id && script.end) {
						block();
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
		
		public function comboItem(hotObject:HotObject,dude:Dude,item:String):void {
			itemAction(dude,hotObject,item);
		}
		
		private function block():void {
			mouseChildren = false;
			if(inventory)
				inventory.mouseChildren = false;
		}
		
		private function unblock():void {
			mouseChildren = true;
			if(inventory)
				inventory.mouseChildren = true;
		}
		
		private function rescue():void {
			mainCharacter.doomed = false;
			mainCharacter.visible = true;
			unblock();
		}
		
		public function failaction(hotObject:HotObject,dude:Dude,item:String):void {
			var script:Object = scripts[hotObject.model.name];
			if(script) {
				if(script.failaction) {
					if(!item) {
						script.failaction.call(this,hotObject,dude);
					}
					else {
						var subscript:Object = script[item];
						if(subscript && subscript.failaction) {
							subscript.failaction.call(this,hotObject,dude);
						}
					}
				}
			}
			else {
				trace("NO SCRIPT FOR",hotObject.model.name);
			}
		}
		
		public function canGo(x:Number,y:Number):Boolean {
			for each(var rect:Rectangle in blockedAreas) {
				if(rect.contains(x,y)) {
					return false;
				}
			}
			return true;
		}
		
		public function gotoScene(scene:String,fade:Boolean=true):void {
			block();
			
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
	}
	
}
