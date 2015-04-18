package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Scene;
	
	
	public class Options extends MovieClip {
		
		static public var instance:Options;
		
		public function Options() {
			var self:Options = this;
			addEventListener(Event.ADDED_TO_STAGE,
				function(e:Event):void {
					instance = self;
				});
		}
		
		static public function hint(level:String):void {
			var tipText:String = "";
			switch(level) {
				case "IntroLevel":
					tipText = "Does this level look familiar?";
					break;
				case "Daves":
					tipText = "Just talk with Dave";
					break;
				case "Hallway":
					tipText = "We put a clock there, because this game is all about time travel!";
					break;
				case "Outside":
					tipText = "Enjoy the fresh air";
					break;
				case "OnTheRoad":
					tipText = "Talk to Mimi";
					break;
				case "Lobby":
					tipText = "The art on the wall are from #AdventureJam and theMeatly. The scultures are from Dobuki Studio";
					break;
				case "Level1":
					tipText = "Use the time machine device to go back. Give yourself some time to step on the hand.";
					break;
				case "ThePyramid":
					tipText = "If one clone doesn't work, perhaps you need more";
					break;
				case "Crossing":
					tipText = "You have three places to go";
					break;
				case "Balance":
					tipText = "Tip the balance to one side";
					break;
				case "Precipice":
					tipText = "Oviously, the skeleton wants you to give something";
					break;
				case "Giant":
					tipText = "You need to distract the giant to reach the cage";
					break;
				case "Hex":
					tipText = "Each step toggles the surrounding platforms. Make sure your future selves can still reach the platform.";
					break
				case "Alley":
					tipText = "Alone, you will get crush, but in numbers...";
					break;
				case "Cave":
					tipText = "Hum... just pick up the spear!";
					break;
				case "Crevasse":
					tipText = "The answer to cross could lie in the pyramid";
					break;
				case "Prairie":
					tipText = "Congratulations! Hey I'm sure you liked this game, to get this far, so please LIKE it on facebook too!";
					break;
			}
			Options.instance.tip.text = tipText;
		}
		
			/*
Preloader
Logo
IntroLevel
Daves
Hallway
Outside
OnTheRoad
Lobby
Level1
ThePyramid
Crossing
Balance
Precipice
Giant
Hex
Alley
Cave
Crevasse
Prairie
BackToDave
ResetLevel
Scene 2
Scene 1
Scene 3
*/
//		}
		
		static public function toggle(root:MovieClip):void {
			if(instance) {
				root.stage.focus = root;
				instance.parent.removeChild(instance);
				instance = null;
			}
			else {
				root.addChild(new Options());
			}
		}
	}
	
}
