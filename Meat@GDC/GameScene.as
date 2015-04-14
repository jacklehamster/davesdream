package  {
	
	import flash.display.MovieClip;
	
	
	public class GameScene extends Game {
		
		function GameScene():void {
			scripts = {
				scene: {
					initialize : function():void {
						var dude:Dude = setDude("dude0",persisted_id);
						born(dude,{speed:2});
						mouseAction(dude,dude1,null);
					},
					hotspots: [
						"cheat",
						"balancecheat"
					]
				},
				"dude1" : {
					hotspots: [
						"switch1",
						"hand1",
						"exit"
					],
					action : function(object:HotObject,dude:Dude):void {
						dude = setDude("dude1",dude.id);
					}
				},
				"cheat": {
					action: function(object:HotObject,dude:Dude):void {
						dude.setPosition(exit);
					}
				},
				"dude2" : {
					hotspots: [
						"leftPlatform1",
						"rightPlatform1"
					]
				},
				"exit" : {
					action: function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						object.setLabel("EXIT");
					},
					end : function(object:HotObject,dude:Dude):void {
						object.setLabel("STILL",false);
						if(dude==mainCharacter) {
							solveLevel();
							gotoScene("ThePyramid");
						}
					}
				},
				"switch1" : {
					action: function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						object.setLabel(object.currentLabel=="UP"?"SWITCHDOWN":"SWITCHUP");
					},
					activate: function(object:HotObject,dude:Dude):void {
						hand1.locationGoal++;
					},
					end : function(object:HotObject,dude:Dude):void {
						dude.visible = true;
						object.setLabel(object.currentLabel=="SWITCHDOWN"?"DOWN":
							object.currentLabel=="SWITCHUP"?"UP":object.currentLabel,false);
					}
				},
				"hand1": {
					action: function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						object.setLabel(dude.x<object.x?"FROMLEFT":"FROMRIGHT");
					},
					failaction: function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						if(dude.x<object.x) {
							leftPlatform1.activator = dude;
							dude.doomed = true;
							leftPlatform1.setLabel("JUMPDOWN",true,
								function(platform:HotObject):void {
									platform.setLabel("STILL",false);
									gameOver(dude);
								}
							);
						}
						else {
							rightPlatform1.activator = dude;
							dude.doomed = true;
							rightPlatform1.setLabel("JUMPDOWN",true,
								function(platform:HotObject):void {
									platform.setLabel("STILL",false);
									gameOver(dude);
								}
							);
						}
					},					
					end : function(object:HotObject,dude:Dude):void {
						dude = setDude("dude2",dude.id);
						dude.setMover(object as DudeMover);
						dude.setPosition(object);
						object.setLabel("STILL",false);
					}
				},
				"leftPlatform1": {
					action: function(object:HotObject,dude:Dude):void {
						dude.setMover(null);
						dude.visible = false;
						object.setLabel("STEPON");
					},
					failaction: function(object:HotObject,dude:Dude):void {
						if(dude.mover==hand1) {
							dude.visible = false;
							hand1.activator = dude;
							dude.doomed = true;
							hand1.setLabel("JUMPDOWNLEFT",true,
								function(hand:HotObject):void {
									hand.setLabel("STILL",false);
									gameOver(dude);
								}
							);
						}
					},					
					end : function(object:HotObject,dude:Dude):void {
						dude = setDude("dude1",dude.id);
						dude.setPosition(object,-1);
						object.setLabel("STILL",false);
					}
				},
				"rightPlatform1": {
					action: function(object:HotObject,dude:Dude):void {
						dude.setMover(null);
						dude.visible = false;
						object.setLabel("STEPON");
					},
					failaction: function(object:HotObject,dude:Dude):void {
						if(dude.mover==hand1) {
							dude.visible = false;
							hand1.activator = dude;
							dude.doomed = true;
							hand1.setLabel("JUMPDOWNRIGHT",true,
								function(hand:HotObject):void {
									hand.setLabel("STILL",false);
									gameOver(dude);
								}
							);
						}
					},					
					end : function(object:HotObject,dude:Dude):void {
						dude = setDude("dude1",dude.id);
						dude.setPosition(object,1);
						object.setLabel("STILL",false);
					}
				}
			}
		}
	}
	
}
