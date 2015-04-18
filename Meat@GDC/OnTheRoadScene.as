package  {
	
	import flash.display.MovieClip;
	
	
	public class OnTheRoadScene extends Game {
		
		
		public function OnTheRoadScene() {
			scripts = {
				scene: {
					noNeedRemote:true,
					initialize : function():void {
						var dude:Dude = setDude("dude0",persisted_id);
						born(dude);
						mouseAction(dude,dude1,null);
					},
					talk: [
						function():void {
							switchLabels("NOTALK",false);
							wait(100,next);
						},
						function():void {
							switchLabels("MIMITALK");
							populates("Hey Oozie, how's it going?","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("NOTALK");
							prompt(
								"Do I know you?",
								"Out of my way, wicked!",
								"Leave me alone!",
							next);
						},
						function(choice:int):void {
							var realText:String = [
								"Do I know you?",
								"Out of my way, you wicked sorceress!",
								"Leave me alone! I already donated to PETA!",
							];
							switchLabels("BOSSTALK");
							populates(realText[choice],"tf");
							wait(WAIT,next,choice);
						},
						function(choice:int):void {
							populates("Haha, just kidding, Mimi! Hehe.. it's funny no?","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("MIMITALK");
							populates("Yeah it's kinda funny. Maybe just work a bit on the delivery","tf");
							wait(WAIT,next);
						},
						function():void {
							populates("What brings you out here in the cold?","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("NOTALK");
							prompt(
								"I'm going to Indie Burger",
								"I need to take a dump",
								"I'm Dave's personal slave",
							next);
						},
						function(choice:int):void {
							var realText:String = [
								"I'm going to Indie Burger. Wanna join?",
								"I just need to take a big dump in the snow",
								"I'm Dave's personal slave today. He asked me to go get his lunch."
							];
							switchLabels("BOSSTALK");
							populates(realText[choice],"tf");
							wait(WAIT,next,choice);
						},
						function(choice:int):void {
							var realText:String = [
								"Hum... I'd love to, but I'm vegetarian remember?",
								"Maybe... you shouldn't do that.",
								"That sucks. He shouldn't treat you like that."
							];
							switchLabels("MIMITALK");
							populates(realText[choice],"tf");
							wait(WAIT,next,choice);
						},
						function(choice:int):void {
							var realText:String = [
								"I'm going to Dosa Migos with Shahrukh.",
								"You're gonna freeze your butt!",
								"Since he's your friend."
							];
							populates(realText[choice],"tf");
							wait(WAIT,next,choice);
						},
						function(choice:int):void {
							var realText:String = [
								"Ok fine, you're missing out I tell you.",
								"Hum... you're right.",
								"It's ok, I'll do anything for Dave, because he's my secret lover!"
							];
							switchLabels("BOSSTALK");
							populates(realText[choice],"tf");
							wait(WAIT,next,choice);
						},
						function(choice:int):void {
							var realText:String = [
								"Imagine, that nice, juicy tender double meatly stuck between your teeth.",
								"I'll just go take a dump at Indie Burger instead.",
								"Haha, I'm kidding. You know I'm kidding, right?"
							];
							populates(realText[choice],"tf");
							wait(WAIT,next,choice);
						},
						function(choice:int):void {
							var realText:String = [
								"Yeah, I don't really want to imagine that. Thanks for the thought.",
								"Well, good luck with that.",
								"Yes... Oozie. I know you're kidding."
							];
							switchLabels("MIMITALK");
							populates(realText[choice],"tf");
							wait(WAIT,next,choice);
						},
						function():void {
							switchLabels("NOTALK");
							prompt(
								"Wanna come by Dave's place?",
								"Wanna smoke some weed?",
								"Wanna play some games?",
							next);
						},
						function(choice:int):void {
							var realText:String = [
								"Hey, do you wanna come by Dave's place after lunch?",
								"Hey, do you wanna smoke some weed after lunch?",
								"Hey, do you wanna play some video games after lunch?",
							];
							switchLabels("BOSSTALK");
							populates(realText[choice],"tf");
							wait(WAIT,next,choice);
						},
						function(choice:int):void {
							var realText:String = [
								"He's working on a game again, this time it looks even worst than ever.",
								"Just come to Dave's place, we can make fun of him while he's working on his game.",
								"Dave's making a game again. Let's crash his game and drive him nuts, it'll be fun!",
							];
							populates(realText[choice],"tf");
							wait(WAIT,next,choice);
						},
						function(choice:int):void {
							switchLabels("MIMITALK");
							populates("Hum... well I was planning to hang out with Shahrukh this afternoon.","tf");
							wait(WAIT,next);
						},
						function():void {
							populates("But Dave's making another game? That sounds pretty cool.","tf");
							wait(WAIT,next);
						},
						function():void {
							populates("I'll ask Shahrukh, maybe we'll drop by after lunch.","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("NOTALK");
							prompt(
								"Hope you can make it",
								"Sounds great, Mimi!",
								"No, don't bring your date!",
							next);
						},
						function(choice:int):void {
							var realText:String = [
								"Awesome! I hope you guys can make it then!",
								"Sounds great, Mimi! I'll prepare a bowl of weed for you guys!",
								"No, don't bring your date, you know I can't stand him. Haha, just kidding!"
							];
							switchLabels("BOSSTALK");
							populates(realText[choice],"tf");
							wait(WAIT,next);
						},
						function():void {
							populates("Ok, see you later","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("MIMITALK");
							populates("Later Ooz","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("NOTALK");
							theRoad.setLabel("LEAVE");
							setDude("dudemid",mainCharacter.id);
							MovieClip(root).gotoAndPlay("ZOOMOUT");
						}						
					]
				},
				"dude1" : {
					hotspots: [
						"theRoad"
					],
					action : function(object:HotObject,dude:Dude):void {
						dude = setDude("dude1",dude.id);
					}
				},
				"dudemid": {
					hotspots: [
						"exitRoad"
					]
				},
				"exitRoad": {
					action: function(object:HotObject,dude:Dude):void {
						gotoScene("BackToDave",dude,false,false);
					}
				},
				"theRoad": {
					cantAccess: function(object:HotObject,dude:Dude):Boolean {
						return object.currentLabel!="STILL";
					},
					action : function(object:HotObject,dude:Dude):void {
						if(dude.model==dude1 && object.currentLabel=="STILL") {
							dude.visible = false;
							object.setLabel("WALK");
						}
					},
					end: function(object:HotObject,dude:Dude):void {
						//	start dialog
						MovieClip(root).gotoAndPlay("ZOOMIN");
						object.setLabel("TALKING",false);
						object.activator = dude;
						runPlan("talk");
					}
				}
			}
		}
		
		override protected function get music():Class {
			return OutsideSong;
		}
	}
	
}
