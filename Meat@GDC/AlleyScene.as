package  {
	
	import flash.display.MovieClip;
	
	
	public class AlleyScene extends Game {
		
		
		public function AlleyScene() {

			crawlScene = true;
			
			scripts = {
				scene: {
					noFadein:true,
					initialize : function():void {
						var dude:Dude = setDude("dude0",persisted_id);
						born(dude);
						dude.setLabel("CRAWL",false);

						if(lastLevel=="Cave") {
							dude.setPosition(toCave,-1);
							mouseAction(dude,dude2,null);
						}
						else {
							mouseAction(dude,dude1,null);
						}
					},
					hotspots: [
						"cheat"
					]
				},
				"cheat": {
					action: function(object:HotObject,dude:Dude):void {
						solveLevel();
					}
				},
				"dude2" : {
					action : function(object:HotObject,dude:Dude):void {
						dude = setDude("dude1",dude.id);
						dude.setPosition(object,-1);
						dude.setLabel("CRAWL",false);
					}
				},
				"dude1" : {
					hotspots: [
						"toBalance",
						"toCave",
					],
					action : function(object:HotObject,dude:Dude):void {
						dude = setDude("dude1",dude.id);
						dude.setLabel("CRAWL",false);
					},
					cantWalk : function(dude:Dude):Boolean {
						return dude.currentLabel=="BURY" || dude.currentLabel=="BURIED" || dude.currentLabel=="CRAWLBLOCK";
					},
					preVanish: function(dude:Dude):void {
						if(dude.currentLabel=="CRAWLBLOCK") {
							crusher.setLabel("UNBLOCKED",false);
							detect(dude,dude.x,dude.y);
						}
					}
				},
				"toCave": {
					cantAccess: function(object:HotObject,dude:Dude):Boolean {
						return !canGo(dude,dude.x,dude.y) && caught("capture").length<=3;
					},
					action: function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						gotoScene("Cave",dude,true,false);
					}
				},
				"toBalance": {
					cantAccess: function(object:HotObject,dude:Dude):Boolean {
						return !canGo(dude,dude.x,dude.y) && caught("capture").length<=3;
					},
					action: function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						gotoScene("Balance",dude,false,false);
					}
				},
				"trap": {
					detect : function(dude:Dude):void {
						if(solvedLevel) {
							return;
						}
						
						if(crusher.currentLabel!="BLOCK") {
							var dudes:Array = caught("capture");
							if(dudes.length<3) {
								for each(var dude:Dude in dudes) {
									dude.stopWalking(false);
									dude.setLabel("BURY",true,
										function(dude:HotObject):void {
											dude.setLabel("BURIED",false);
										});
								}
								crusher.setLabel("CRUSH",true,
									function(crusher:HotObject):void {
										crusher.setLabel("RELEASE",true,
											function(crusher:HotObject):void {
												crusher.setLabel("STILL");
											});
									});
							}
							else {
								for each(dude in dudes) {
									dude.stopWalking(false);
									dude.setLabel("CRAWLBLOCK",true);
								}
								crusher.setLabel("BLOCK",true,
									function(crusher:HotObject):void {
									});
							}
						}
					}
				}
			};
		}
	}
	
}
