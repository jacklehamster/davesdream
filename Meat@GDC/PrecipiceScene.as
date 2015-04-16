package  {
	
	import flash.display.MovieClip;
	
	
	public class PrecipiceScene extends Game {
		
		
		public function PrecipiceScene() {
			scripts = {
				scene: {
					initialize : function():void {
						var dude:Dude = setDude("dude0",persisted_id);
						born(dude);
						
						if(solvedLevel) {
							skully.setLabel("GOTIDOL");
							platformToGiant.setLabel("DOOR");
							if(lastLevel=="Giant") {
								dude.setPosition(platformToGiant);
							}
						}
						mouseAction(dude,dude1,null);
					},
					hotspots: [
						"cheat"
					]
				},
				"dude1" : {
					hotspots: [
						"exitToCrossing",
						"rightprecipice",
						"leftprecipice",
						"skully",
						"platformToGiant"
					],
					action : function(object:HotObject,dude:Dude):void {
						dude = setDude("dude1",dude.id);
					}
				},
				"cheat": {
					action : function(object:HotObject,dude:Dude):void {
						dude.hero.pickupItem("idol");
					}
				},
				"skully": {
					action: function(object:HotObject,dude:Dude):void {
						if(object.currentLabel=="STILL") {
							object.setLabel("GIVEME");
						}
					},
					end: function(object:HotObject,dude:Dude):void {
						object.setLabel("STILL",false);
					},
					combo: {
						"idol": {
							action: function(object:HotObject,dude:Dude):void {
								if(object.currentLabel=="STILL") {
										dude.visible = false;
										dude.hero.dropItem("idol");
										object.setLabel("GIVEIDOL");
								}

							},
							end : function(object:HotObject,dude:Dude):void {
								object.setLabel("GOTIDOL",false);
								platformToGiant.setLabel("LAND",true,
									function(platform:HotObject):void {
										platform.setLabel("DOOR",false);
									});
								dude.visible = true;
								var dudes:Array = caught("precipiceDetector");
								for each(var d:Dude in dudes) {
									if(dude!=dudeinvis && dude.model==dudeinvis)
										dude.useItem("timeRemote");
								}
							}
						}
					}
				},
				"platformToGiant": {
					action: function(object:HotObject,dude:Dude):void {
						if(object.currentLabel=="DOOR") {
							dude.visible = false;
							object.setLabel("EXIT");
						}
					},
					end : function(object:HotObject,dude:Dude):void {
						object.setLabel("STILL",false);
						gotoScene("Giant",dude,true,false);
					}
				},
				"exitToCrossing": {
					action: function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						gotoScene("Crossing",dude,false,false);
					}
				},
				"leftprecipice": {
					failaction: function(object:HotObject,dude:Dude):void {
						if(object.currentLabel=="STILL") {
							dude.visible = false;
							object.setLabel("CROSS");
						}
					},
					end: function(object:HotObject,dude:Dude):void {
						object.activator = dude;
						object.setLabel("BRIDGE",false);
						dude = setDude("dudeinvis",dude.id);
						dude.alpha = 0;
					}
				},				
				"rightprecipice": {
					failaction: function(object:HotObject,dude:Dude):void {
						if(object.currentLabel=="STILL") {
							dude.visible = false;
							object.setLabel("CROSS");
						}
					},
					end: function(object:HotObject,dude:Dude):void {
						object.activator = dude;
						object.setLabel("BRIDGE",false);
						dude = setDude("dudeinvis",dude.id);
						dude.alpha = 0;
					}
				},
				"precipiceGap": {
					inactive : function(dude:Dude):Boolean {
						return leftprecipice.currentLabel=="BRIDGE"||rightprecipice.currentLabel=="BRIDGE"
							|| platformToGiant.currentLabel!="STILL";
					}
				},
				"dudeinvis": {
					preVanish: clearBridge
				}
			};
		}
		
		function clearBridge(dude:Dude):void 
		{
			var trapped:Boolean = false;
			if(leftprecipice.currentLabel=="BRIDGE") {
				leftprecipice.setLabel("TIMEREMOTE",true,
					function(object:HotObject):void {
						object.activator = null;
						rightprecipice.setLabel("FLASH",true,
							function(object:HotObject):void {
								object.setLabel("STILL",false);
							});
						leftprecipice.setLabel("FLASH",true,
							function(object:HotObject):void {
								object.setLabel("STILL",false);
							});
					});
				trapped = true;
			}
			if(rightprecipice.currentLabel=="BRIDGE") {
				rightprecipice.setLabel("TIMEREMOTE",true,
					function(object:HotObject):void {
						object.activator = null;
						rightprecipice.setLabel("FLASH",true,
							function(object:HotObject):void {
								object.setLabel("STILL",false);
							});
						leftprecipice.setLabel("FLASH",true,
							function(object:HotObject):void {
								object.setLabel("STILL",false);
							});
					});
				trapped = true;
			}
			if(trapped) {
				var dudes:Array = caught("precipiceDetector");
				for each(var d:Dude in dudes) {
					if(dude!=d && d!=dudeinvis)
						freeFall(d);
				}
			}
		}
	}
	
}
