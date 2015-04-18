package  {
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.events.Event;
	import flash.media.SoundTransform;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.events.TextEvent;
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.Stage;
	
	public class GameBase extends ActionSpace {


		static public var dialogHistory:Array = [];
		
		static protected const WAIT:int = 5000;
		
		protected var scripts:Object = {};
		static private var soundChannel:SoundChannel = null;
		static private var currentMusic:Class = null;
		private var currentPlan:String = null;
		private var index:int = 0;
		private var _stage:Stage;
		
		function GameBase():void {
			addEventListener(Event.ADDED_TO_STAGE,
				function(e:Event):void {
					_stage = stage;
				});
		}
		
		protected function get music():Class {
			return PuzzleSong;
//			return null;
		}
		
		protected function get dialogchooser():DialogChooser {
			return MovieClip(root).dialogchooser;
		}
		
		
		protected function resetMusic():void {
			if(music!=currentMusic) {
				if(soundChannel) {
					var channel:SoundChannel = soundChannel;
					var volume:Number = 1;
					addEventListener(Event.ENTER_FRAME,
						function(e:Event):void {
							volume -= .02;
							channel.soundTransform = new SoundTransform(volume);
							if(volume<=0) {
								e.currentTarget.removeEventListener(e.type,arguments.callee);
								channel.stop();
							}
						});
					soundChannel = null;
				}
				
				
				currentMusic = music;
				if(currentMusic) {
					var sound:Sound = new (currentMusic)();
					soundChannel = sound.play(0,int.MAX_VALUE,null);
				}
			}			
			
		}
		
		protected function runPlan(planName:String):void {
			if(scripts.scene && scripts.scene[planName]) {
				currentPlan = planName;
				index = 0;
				scripts.scene[planName][0].call(this);
			}
		}
		
		protected function next(...params):void {
			index++;
			if(scripts.scene[currentPlan][index])
				scripts.scene[currentPlan][index].apply(this,params);
		}
		
		protected function wait(seconds:int,callback:Function,...params):void {
			var startTime:int = getTimer();
			var f:Function = function(e:MouseEvent=null):void {
				if(e && getTimer()-startTime<Math.min(seconds,200)) {
					return;
				}
				clearTimeout(timeout);
				_stage.removeEventListener(MouseEvent.MOUSE_DOWN,f);
				callback.apply(this,params);
			};
			var timeout:int = setTimeout(f,seconds);
			_stage.addEventListener(MouseEvent.MOUSE_DOWN,f);
		}
		
		
		protected function populates(text:String,tfname:String):void {
			populate(root as MovieClip,text,tfname);
		}
		
		static public function populate(root:DisplayObjectContainer,text:String,tfname:String):void {
			if(!root)
				return;
			for(var i:int=0;i<root.numChildren;i++) {
				var child:DisplayObject = root.getChildAt(i);
				if(child) {
					if((child is TextField) && child.name==tfname) {
						setText(text,child as TextField);
					}
					else if(child is DisplayObjectContainer) {
						populate(child as DisplayObjectContainer,text,tfname);
					}
				}
			}
		}
		
		static private function setText(text:String,tf:TextField):void {
			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.text = text;
			tf.x = -tf.width/2;
			tf.y = -tf.height/2;
			dialogHistory.push(text);
		}
		
		public function switchLabels(label:String,doPlay:Boolean=true):void {
			switchLabel(root as MovieClip,label,doPlay);
		}
		
		static public function switchLabel(root:DisplayObjectContainer,label:String,doPlay:Boolean):void {
			if(!root)
				return;
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
		
		
		protected function prompt(a:String,b:String,c:String,callback:Function):void {
			var array:Array = [a,b,c];
			populates(a,"tfmiddle");
			populates(b,"tfright");
			populates(c,"tfleft");
			dialogchooser.visible = true;
			dialogchooser.addEventListener(TextEvent.LINK,
				function(e:TextEvent):void {
					e.currentTarget.removeEventListener(e.type,arguments.callee);
					dialogchooser.visible = false;
					callback(array.indexOf(e.text));
				});
		}
	}
	
}
