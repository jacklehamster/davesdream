package  {
	
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.display.FrameLabel;
	import flash.events.Event;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	import flash.text.TextField;
	import flash.display.DisplayObject;
	import flash.text.TextFieldAutoSize;
	import flash.events.TextEvent;
	import flash.media.SoundTransform;
	
	
	public class Intro extends Game {

		public var label:String = "IN", label2:String = "BOSSTALK";
		private var barked:Boolean = false;
		
		public function Intro() {
			scripts = {
				scene: {
					initialize : function():void {
						var dude:Dude = setDude("dudeinvis",persisted_id);
						born(dude);
						if(dude.hero.hasItem("daveRequest")) {
							runPlan("wheresmyburger");
						}
						else {
							runPlan("plan");
						}
					},
					hotspots: [
						"cheat",
						"dog"
					],
					wheresmyburger: [
						function():void {
							switchLabels("IN",false);
							switchLabels("NOTALK",false);
							switchLabels("DAVEIN",false);
							switchLabels("DAVENORMAL",false);
							wait(WAIT,next);
						},
						function():void {
							switchLabels("IN");
							wait(500,next);
						},
						function():void {
							switchLabels("DAVEIN");
							wait(500,next);
						},
						function():void {
							switchLabels("MEATTALK");
							populates("Where's my burger?","tf");
							wait(2500,next);
						},
						function():void {
							switchLabels("NOTALK",false);
							switchLabels("OUT");
							wait(1000,next);
						},
						function():void {
							switchLabels("DAVEUPSET");
							gotoScene("IntroLevel",mainCharacter,false,true);
							wait(500,function():void {
								switchLabels("DAVEOUT");
							});
						}
					],
					plan: [
						function():void {
							switchLabels("IN",false);
							switchLabels("NOTALK",false);
							switchLabels("DAVEIN",false);
							switchLabels("DAVENORMAL",false);
							wait(WAIT,next);
						},
						function():void {
							switchLabels("IN");
							wait(100,next);
						},
						function():void {
							switchLabels("BOSSTALK");
							populates("What's up Dave?","tf");
							switchLabels("DAVEUPSET");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("DAVEIN");
							switchLabels("MEATTALK");
							populates("Oozie, leave me alone.","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("DAVEOUT");
							populates("I'm busy right now.","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("NOTALK");
							prompt(
								"Games, Games, Games...",
								"Chill dude...",
								"You don't have a job...",
							next);
						},
						function(choice:int):void {
							var realText:String = [
								"Games, Games, Games...",
								"Chill dude, I just came by to say hi...",
								"You don't have a job, what you busy for?"
							];
							switchLabels("BOSSTALK");
							populates(realText[choice],"tf");
							wait(WAIT,next,choice);
						},
						function(choice:int):void {
							var realText:String = [
								"All Dave does is make games, no time to see his best buddy",
								"But I see you're too busy making games, huh?",
								"Don't tell me you're making a game, again!"
							];
							switchLabels("BOSSTALK");
							populates(realText[choice],"tf");
							wait(WAIT,next,choice);
						},
						function(choice:int):void {
							var realText:String = [
								barked?"See, even Molynux thinks you're a douche, that says something.":"Shame on you, dude! Shame on you!",
								barked?"You're always making games! See, even Molynux thinks you're crazy!":"Your life is just games, games, games",
								barked?"You don't even have time to take care of Molynux. Look how unhappy he is!":"You don't have anything better to do?"
							];
							switchLabels("BOSSTALK");
							populates(realText[choice],"tf");
							wait(WAIT,next);
							barked = false;
						},
						function():void {
							switchLabels("MEATTALK");
							switchLabels("DAVEIN");
							switchLabels("DAVENORMAL",false);
							populates("Listen, last night, I had a strange dream.","tf");
							wait(WAIT,next);
						},
						function():void {
							populates("I was stuck forever in an infinite loop.","tf");
							wait(WAIT,next);
						},
						function():void {
							populates("I would shoot myself with a gun, then wake up again the same day...","tf");
							wait(WAIT,next);
						},
						function():void {
							populates("... and I would repeat everything over and over again","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("NOTALK");
							prompt(
								"You're depressed, dude...",
								"Dude, that's crazy man...",
								"You're a psycho, dude...",
							next);
						},
						function(choice:int):void {
							var realText:String = [
								"You're depressed, dude. That's cause you got fired from your job ",
								"Dude that's crazy man, you kept repeating the same day over and over",
								"You're a psycho, dude. You keep having these fucked up dreams dude"
							];
							switchLabels(choice==2?"DAVEUPSET":"DAVENORMAL");
							switchLabels("BOSSTALK");
							populates(realText[choice],"tf");
							wait(WAIT,next,choice);
						},
						function(choice:int):void {
							var realText:String = [
								"You need some weed, man. That's what you need, you should have some weed, dude.",
								"And you kept shooting yourself in that dream? Wow, that's totally crazy dude.",
								"I'm worried about you, dude. One day you're gonna go crazy dude, totally crazy."
							];
							populates(realText[choice],"tf");
							barked = false;
							wait(WAIT,next,choice);
						},
						function(choice:int):void {
							if(barked) {
								switchLabels("DAVEOUT");
								switchLabels("MEATTALK");
								switchLabels("DAVEUPSET");
								populates("Quiet Molynux!","tf");
								wait(WAIT,next,choice);
							}
							else {
								wait(100,next,choice);
							}
						},
						function(choice:int):void {
							var realText:String = [
								"Hey I don't need any weed.",
								"Well you see, inspired by that dream, I decided to make this game.",
								"Oozie, I don't think there's any point to talk to you."
							];
							barked = false;
							switchLabels(choice==1?"DAVENORMAL":"DAVEUPSET");
							switchLabels("MEATTALK");
							switchLabels("DAVEIN");
							populates(realText[choice],"tf");
							wait(WAIT,next,choice);
						},
						function(choice:int):void {
							var realText:String = [
								"I just need to concentrate and make this game. It's going to be my next masterpiece.",
								"It not only gave me inspiration, but also a lot of motivation.",
								barked?"Maybe you should have a conversation with the dog.":"It's like talking to a complete idiot."
							];
							populates(realText[choice],"tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("DAVEOUT");
							barked = false;
							switchLabels("NOTALK");
							prompt(
								"I think we need some food",
								"We need to smoke some weed",
								"I really want to take a dump",
							next);
						},
						function(choice:int):void {
							var realText:String = [
								"Dude, I think we need some food.",
								"Dude, we need to smoke some weed.",
								"Dude, I really want to take a dump."
							];
							switchLabels("BOSSTALK");
							populates(realText[choice],"tf");
							wait(WAIT,next,choice);
						},
						function(choice:int):void {
							var realText:String = [
								"I'm really craving a burger right now.",
								"You need to relax man, let's smoke some weed, dude.",
								"Can I take a really big dump in your restroom?"
							];
							switchLabels("BOSSTALK");
							populates(realText[choice],"tf");
							wait(WAIT,next,choice);
						},
						function(choice:int):void {
							var realText:String = [
								barked?"You're hungry too Molynux?":"Let's grab some food dude, I know you want it.",
								barked?"You wanna smoke some weed too, Molynux?":"I can get some for you if you like.",
								barked?"Your dog just said I can take a big dump in your restroom.":"I don't think I can hold it.",
							];
							populates(realText[choice],"tf");
							wait(WAIT,next,choice);
						},
						function(choice:int):void {
							var realText:String = [
								barked?"I'll buy a burger for you too, my cute little doggy.":"Imagine, a nice juicy meatly burger stuck between your teeth.",
								barked?"Hey, your dog wants to smoke some weed.":"Cause I'd do anything for my best buddy, dude.",
								barked?"Thanks Molynux!":"I'll take a dump here if you don't mind.",
							];
							if(choice==1) {
								medal420();
							}
							populates(realText[choice],"tf");
							wait(WAIT,next,choice);
						},
						function(choice:int):void {
							if(barked) {
								switchLabels("MEATTALK");
								populates("What's wrong with Molynux? He keeps barking today.","tf");
								barked = false;
								wait(WAIT,next,choice);
							}
							else {
								wait(100,next,choice);
							}
						},
						function(choice:int):void {
							var realText:String = [
								"I guess you're right, I shouldn't work on an empty stomach",
								"I don't want to smoke Oozie, but actually I kinda starving now.",
								"No Oozie, you cannot take a big dump at my place!"
							];
							var text:String = realText[choice];
							switchLabels("MEATTALK");
							switchLabels("DAVEIN");
							switchLabels(choice==2?"DAVEUPSET":"DAVENORMAL");
							populates(text,"tf");
							wait(WAIT,next,choice);
						},
						function(choice:int):void {
							var realText:String = [
								"But I can't stop right now. Go to Indie Burger, and bring me a double meatly.",
								"I'd go to Indie Burger right now, but I have to stay and work.",
								"Go to Indie Burger and take your big dump."
							];
							populates(realText[choice],"tf");
							wait(WAIT,next,choice);
						},
						function(choice:int):void {
							var realText:String = [
								"Yeah, double meatly. That sounds delicious right now...",
								"Go there and buy me a double meatly.",
								"Also, after washing your hands, bring me back a double meatly, I'm starving!"
							];
							populates(realText[choice],"tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("DAVEIN");
							switchLabels("DAVENORMAL");
							populates("So listen very carefully.","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("DAVEIN");
							switchLabels("DAVENORMAL");
							populates("I want some freedom fries on the side, a double meatly with cheese, and a slurmy cola.","tf");
							wait(WAIT,next);
						},
						function():void {
							populates("Get my wallet in the drawer, there should be twenty in cash.","tf");
							wait(WAIT,next);
						},
						function():void {
							populates(barked?"If not, just use my visa, they don't check ID. Quiet Molynux!":"Otherwise just use my visa, they don't check ID.","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("NOTALK");
							prompt(
								"Sure, dude!",
								"You don't want some weed?",
								"Dude, I'm not your bitch",
							next);
						},
						function(choice:int):void {
							barked = false;
							var realText:String = [
								"Sure, dude! Let's get some delicious burgers from Indie Burger!",
								"You sure you don't want some weed instead?",
								"Dude, I'm not your bitch!"
							];
							switchLabels(choice==0?"DAVENORMAL":"DAVEUPSET");
							switchLabels("BOSSTALK");
							populates(realText[choice],"tf");
							wait(WAIT,next,choice);
						},
						function(choice:int):void {
							var realText:String = [
								"They really have the best burgers. Ok, see you dude!",
								"Just kidding, dude! Alright I'll get the burgers. See you soon.",
								"Just kidding, dude! I'll do anything for my best buddy. See you later!"
							];
							populates(realText[choice],"tf");
							wait(WAIT,next);
						},
						function():void {
							if(barked) {
								populates("Yes Molynux, I'll get you something too, cute doggy!","tf");
								wait(WAIT,next);
							}
							else {
								wait(100,next);
							}
						},
						function():void {
							switchLabels("DAVEOUT");
							switchLabels("NOTALK");
							switchLabels("OUT");
							mainHero.pickupItem("daveRequest");
							gotoScene("IntroLevel",mainCharacter,false,true);
						}
					]
				},
				"cheat": {
					action : function(hotObject:HotObject,dude:Dude):void {
						gotoScene("IntroLevel",null,false,true);
					}
				},
				"dog": {
					action : function(hotObject:HotObject,dude:Dude):void {
						barked = true;
						hotObject.setLabel("BARK");
						(new DogBark()).play(0,0,new SoundTransform(.5,.5));
					},
					end : function(hotObject:HotObject,dude:Dude):void {
						hotObject.setLabel("STILL",false);
					}
				}
			};
		}
		

		
		override protected function get music():Class {
			return KeyboardTyping;
		}
	}
	
}
