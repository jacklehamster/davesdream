package  {
	
	import flash.display.MovieClip;
	
	
	public class GiantScene extends Game {
		
		
		public function GiantScene() {
			scripts = {
				scene: {
					noFadein:true,
					initialize : function():void {
						var dude:Dude = setDude("dude0",persisted_id);
						born(dude);
						mouseAction(dude,dude1,null);
					},
					hotspots: [
						"cheat"
					]
				},
				"dude1" : {
					hotspots: [
						"exitToCrossing"
					],
					action : function(object:HotObject,dude:Dude):void {
						dude = setDude("dude1",dude.id);
					}
				},
				"exitToCrossing": {
					action: function(object:HotObject,dude:Dude):void {
						gotoScene("Crossing",false);
					}
				}
			};
		}
	}
	
}
