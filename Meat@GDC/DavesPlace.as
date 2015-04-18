package  {
	
	import flash.display.MovieClip;
	import flash.media.SoundTransform;
	
	
	public class DavesPlace extends Game {
		
		
		public function DavesPlace() {
			scripts = {
				scene: {
					initialize : function():void {
						var dude:Dude = setDude("dude1",persisted_id);
						born(dude);
						dude.hero.dropItem("wallet");
						runPlan("plan");
					},
					hotspots: [
						"dog"
					],
					plan: [
						function():void {
							switchLabels("IN",false);
							switchLabels("NOTALK",false);
							switchLabels("DAVEIN",false);
							switchLabels("DAVENORMAL",false);
							wait(100,next);
						},
						function():void {
							switchLabels("DAVEUPSET");
							switchLabels("IN");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("DAVEIN");
							switchLabels("BOSSTALK");
							populates("Hum... Dave?","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("MEATTALK");
							populates("Oozie, where's my burger?","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("BOSSTALK");
							populates("Well, you know...","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("MEATTALK");
							populates("Don't tell me you spent the money on weed","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("BOSSTALK");
							populates("Well, you know...","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("MEATTALK");
							populates("How can you do this! I trust you with my wallet","tf");
							wait(WAIT,next);
						},
						function():void {
							populates("And this is the result?","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("BOSSTALK");
							populates("I got a very good deal though, let's just smoke a joint together old friend","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("MEATTALK");
							populates("No Oozie! I'm working here! And I need food, not weed!","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("BOSSTALK");
							populates("You know your drawer produces donuts infinitely?","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("MEATTALK");
							populates("It's not infinite! You ate the last one!!","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("BOSSTALK");
							populates("I can cook something if you want. Do you have a microwave?","tf");
							wait(WAIT,next);
							macbook.setLabel("HEAT",true,
								function():void {
									MovieClip(root).gotoAndPlay("WARP");
								}
							);
						},
						function():void {
							switchLabels("MEATTALK");
							populates("I've got nothing left at home! That's why I asked you to go","tf");
							wait(WAIT,next);
						},
						function():void {
							populates("But what on earth happened to my credit card?","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("BOSSTALK");
							populates("Well... I can explain","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("MEATTALK");
							populates("Go ahead explain","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("BOSSTALK");
							populates("It's unexplainable!","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("MEATTALK");
							populates("That's what I thought.","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("BOSSTALK");
							populates("No Really! This was not supposed to happen. I didn't even write the script for this","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("MEATTALK");
							populates("I still demand an explanation.","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("BOSSTALK");
							populates("how much wood would a woodchuck chuck if a woodchuck could chuck wood","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("MEATTALK");
							populates("A woodchuck would chuck so much wood he wouldn't know how much wood he chucked.","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("BOSSTALK");
							populates("Dude right now is a good time to smoke some weed","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("MEATTALK");
							populates("I'd rather figure out what happened.","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("BOSSTALK");
							populates("Why do you guys keep clicking!? I don't have anything else to say","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("MEATTALK");
							populates("Then don't say anything.","tf");
							wait(WAIT,next);
						},
						function():void {
							switchLabels("BOTHTALK");
							populates("","tf");
//							wait(WAIT,next);
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
						hotObject.setLabel("BARK");
						(new DogBark()).play(0,0,new SoundTransform(.5,.5));
					},
					end : function(hotObject:HotObject,dude:Dude):void {
						hotObject.setLabel("STILL",false);
					}
				}
			};
		}
		
		public function blah():void {
			switchLabels("BOTHTALK");
		}
		
		override protected function get music():Class {
			return KeyboardTyping;
		}
		
		public function continueStuff():void {
			trace("HERE");
			gotoScene("Level1",mainCharacter,false,false);
		}
	}
	
}
