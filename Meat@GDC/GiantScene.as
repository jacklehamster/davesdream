package  {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	
	public class GiantScene extends Game {
		
		
		public function GiantScene() {
			var spearLanding:Point = new Point();
			scripts = {
				scene: {
					noFadein:true,
					initialize : function():void {
						var dude:Dude = setDude("dude0",persisted_id);
						born(dude);
						mouseAction(dude,dude1,null);
						spear.visible = false;
						spearLanding = new Point(spear.x,spear.y);
					},
					hotspots: [
						"cheat"
					]
				},
				"dude1" : {
					hotspots: [
						"exitToCrossing",
						"gianthand",
						"spear",
						"caged"
					],
					action : function(object:HotObject,dude:Dude):void {
						dude = setDude("dude1",dude.id);
					},
					preDestroy: function(dude:Dude):void {
						if(dude.hero.hasItem("spear")) {
							spear.visible = true;
							spear.setPosition(dude);
							setChildIndex(spear,getChildIndex(dude));
							spear.setLabel("DROP",true,
								function():void {
									spear.setLabel("STILL",false);
									resetHotspots();
								});
						}
					}
				},
				"cheat": {
					action: function(object:HotObject,dude:Dude):void {
						dude.hero.pickupItem("spear");
					}
				},
				"exitToCrossing": {
					action: function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						if(dude==mainCharacter)
							gotoScene("Crossing",false);
					}
				},
				"gianthand": {
					action: function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						object.setLabel("KICK");
					},
					end : function(object:HotObject,dude:Dude):void {
						object.setLabel("STILL",false);
						dude.visible = true;
					},
					combo: {
						"spear": {
							action: function(object:HotObject,dude:Dude):void {
								dude.visible = false;
								object.setLabel("PICKGIANT");

							},
							failaction : function(object:HotObject,dude:Dude):void {
								dude.visible = false;
								object.setLabel("PICKGIANTLEFT");
							},
							end : function(object:HotObject,dude:Dude):void {
								dude.visible = true;
								object.visible = false;
								dude.hero.dropItem("spear");
								giant.usable = true;
								action(giant,dude,null);
							}
						}
					}
				},
				"giant": {
					action: function(object:HotObject,dude:Dude):void {
						if(giant.usable) {
							giant.usable = false;
							object.setLabel("GRAB");
						}
					},
					activate: function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						var anim:HotAnimation = new FlyingSpear();
						
						addChildAt(anim,getChildIndex(dude1));
						anim.x = gianthand.x;
						anim.y = gianthand.y;
						anim.setLabel("FLY",true,
							function():void {
								removeChild(anim);
								spear.visible = true;
								spear.x = spearLanding.x;
								spear.y = spearLanding.y;
							});
					},
					end : function(object:HotObject,dude:Dude):void {
						object.setLabel("CARESS",false);
						dude = setDude("dudeinvis",dude.id);
						dude.alpha = 0;
					}
				},
				"handblock": {
					inactive : function(dude:Dude):Boolean {
						return !gianthand.visible;
					}
				},
				"spear": {
					action : function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						object.setLabel("PICKUP");
					},
					end: function(object:HotObject,dude:Dude):void {
						dude.visible = true;
						object.visible = false;
						dude.hero.pickupItem("spear");
						object.setLabel("STILL");
					}
				},
				"dudeinvis": {
					preVanish: function(dude:Dude):void {
						if(giant.caress.oozie) {
							giant.caress.oozie.setLabel("TIMEREMOTE",true,function(oozie:HotObject):void{
								oozie.visible = false;
								giant.setLabel("BACK",true,
									function(giant:HotObject):void {
										giant.setLabel("STILL",false);
										gianthand.visible = true;
										gianthand.setLabel("STILL",false);
									});
							});
						}
					}
				},
				"caged": {
					action : function(object:HotObject,dude:Dude):void {
						
					},
					end: function(object:HotObject,dude:Dude):void {
					}
				}
			};
		}
	}
	
}
