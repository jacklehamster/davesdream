﻿package  {
	
	import flash.display.MovieClip;
	
	
	public class MovingPlatform extends HotObject {
		
		public var holders:Object = {};
		
		public function MovingPlatform() {
			// constructor code
		}
		
		override public function canGo():Boolean {
			return x<800;
		}
		
	}
	
}
