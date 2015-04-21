package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	import flash.display.DisplayObject;
	import com.newgrounds.encoders.json.encodeJson;
	import com.newgrounds.API;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import com.newgrounds.crypto.MD5;
	
	
	public class Game extends GameBase {
		

		static public function hardReset(root:MovieClip):void {
			currentLevel = null;
			previousLevel = null;
			levelsToSolve = [];
			Hero.persistentItems = [];
			ActionSpace.heroes = {};
			ActionSpace.rebirthCount = 0;
			global_history = [];
			GameBase.dialogHistory = [];
			root.gotoAndPlay(1,"Logo");
		}
		
		
		
		static public const DEBUG:Boolean = false;
		static public const jumpScene:String = "Giant";
		
		static public var persisted_id:int = 0;
		public var mainCharacter:Dude;
		
		private var blockedAreas:Object = {};
		private var detectAreas:Object = {};
		
		static public var currentLevel:String;
		static protected var previousLevel:String;
		
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

			if(!scripts) {
				scripts = {};
			}
			if(!scripts.scene) {
				scripts.scene = {};
			}
			
			if(!scripts.scene.noFadein)
				MovieClip(root).addChild(new FadeIn());
			if(scripts.scene && scripts.scene.initialize) {
				scripts.scene.initialize.call(this);
			}
			if(inventory && mainHero) {
				mainHero.addEventListener(Event.CHANGE,onInventoryChange);
				if(!scripts.scene.noNeedRemote) {
					mainHero.pickupItem("timeRemote");
				}
				inventory.updateInventory(mainHero.items);
			}
			resetHotspots();
			
			persisted_id = 0;
			resetMusic();
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
				rebirthCount++;
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
				var hotObject:HotObject = e.target as HotObject;
				if(mainCharacter && mainCharacter.visible 
					|| hotObject && hotObject.activator==mainCharacter
					|| hotObject && hotObject.caughtDude()) {
					if(hotObject) {
						var item:String = inventory?inventory.activeItem:null;
						if(inventory)
							inventory.setCursor(null);
						mouseAction(mainCharacter,hotObject,item);
						e.stopImmediatePropagation();
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
//			var doomed:Boolean = false;
			
			if(dude) {
				//doomed = dude.doomed;
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
//				dude.doomed = doomed;
			}
			if(!mainCharacter || !dude || mainCharacter.id==dude.id) {
				mainCharacter = dude;
				resetHotspots();
			}
			return dude;
		}
				
		public function resetHotspots():void {
			var dude:Dude = mainCharacter;
			var script:Object = dude ? scripts[dude.model.name] : null;
			var hotspots:Array = script?script.hotspots:null;
			if(!hotspots) {
				hotspots = [];
				trace("NO SCRIPT OR NO HOTSPOTS FOR",dude?dude.model.name:null);
			}
			var sceneHotSpots = scripts.scene.hotspots;
			if(sceneHotSpots) {
				hotspots = hotspots.concat(sceneHotSpots);
			}
			
			var hash:Object = {};
			for each(var spot:String in hotspots) {
				hash[spot] = true;
			}
			trace(hotspots);
			for(var i:int=0;i<numChildren;i++) {
				var hotSpot:HotObject = getChildAt(i) as HotObject;
				if(hotSpot) {
					hotSpot.active = hash[hotSpot.model.name] ||
						hotSpot==mainCharacter && inventory && inventory.activeItem;
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
		
		public function action(hotObject:HotObject,dude:Dude,item:String,fail:Boolean):void {
			
			var script:Object = scripts[hotObject.model.name];
			var act:String = fail?"failaction":"action";
			if(script) {
				if(script[act] || item && script.combo && script.combo[item]) {
					if(hotObject.scriptRunning) {
						if(hotObject.activator.born>dude.born) {
							hotObject.cancel();
							rescue();
						}
						else {
							if(hotObject.activator.root) {
								return;
							}
						}
					}
					hotObject.scriptRunning = script;
					hotObject.activator = dude;
					if(!item) {
						script[act].call(this,hotObject,dude);
					}
					else {
						var subscript:Object = script.combo ? script.combo[item] : null;
						if(subscript && subscript[act]) {
							hotObject.scriptRunning = subscript;
							subscript[act].call(this,hotObject,dude);
						}
					}
					if(!hotObject.labelPlaying) {
						dude.usingItem = null;
						hotObject.scriptRunning = null;
						hotObject.activator = null;
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
			undoDude(mainCharacter);
			var ghost:Dude = mainCharacter;
			var dude:Dude = setDude(mainCharacter.model.name,mainCharacter.id);
			dude.setPosition(ghost);
		}
		
		private function undoDude(dude:Dude):void {
			if(dude==mainCharacter) {
				undo();
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
		
		override protected function onBorn(dude:Dude):void {
			if(scripts.scene && scripts.scene.born) {
				scripts.scene.born.call(this,dude);
			}
		}
		
		
		public function gotoScene(scene:String,dude:Dude,solve:Boolean,fade:Boolean):void {
			if(dude!=mainCharacter) {
				return;
			}
			previousLevel = currentLevel;
			if(solve) {
				solveLevel();
			}

			if(dude) {
				Hero.persistentItems = dude.hero.items.concat([]);
			}

			var func:Function = function():void {
				persisted_id = mainCharacter?mainCharacter.id:1;
				clearHistory();
				if(root)
					MovieClip(root).gotoAndStop(1,scene);
			}
			
			if(fade) {
				if(root)
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
		
		public function refresh(hotObject:HotObject,dude:Dude):void {
			var script:Object = hotObject.scriptRunning;
			if(script && script.refresh) {
				script.refresh.call(this,hotObject,dude);
			}			
		}
		
		protected function freeFall(dude:Dude):void {
			var mov:Number = 0;
			dude.doomed = true;
			dude.addEventListener(Event.ENTER_FRAME,
				function(e:Event):void {
					dude.y += mov;
					mov++;
					if(dude.y>stage.stageHeight+dude.height+50) {
						e.currentTarget.removeEventListener(e.type,arguments.callee);
						gameOver(dude);
					}
				});
		}
		
		
		static public function finish(root:MovieClip):void {
			API.unlockMedal("ACT 1");
			gamejoltAchieve(root,22891);
		}
		
		protected function medal420():void {
			API.unlockMedal("420");
			gamejoltAchieve(MovieClip(root),23341);
		}
		
		static private function gamejoltAchieve(root:MovieClip,trophyID:int):void {
			var username:String = root.loaderInfo.parameters.gjapi_username;
			var token:String = root.loaderInfo.parameters.gjapi_token;
			if(username && token) {
				var url:String = "http://gamejolt.com/api/game/v1/trophies/add-achieved/";
				var gameID:String = "59918";
				var key:String = "2763769fe33664f2d1d964d49f2df721";
				url += "?game_id="+gameID;
				url += "&username="+username;
				url += "&user_token="+token;
				url += "&trophy_id="+trophyID;
				url += "&format=json";
				url += "&signature="+MD5.hash(url + key);
				var request:URLRequest = new URLRequest(url);
				var urlloader:URLLoader = new URLLoader();
				urlloader.load(request);
				
			}
		}
		
		static public function restartLevel():void {
			global_history.pop();
			instance.gameOver(instance.mainCharacter);
		}
	}
	
}
