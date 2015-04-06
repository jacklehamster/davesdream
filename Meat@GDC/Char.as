package  {
	
	public class Char extends Element {

		
		public function setLabel(label:String):void {
			if(label!=currentLabel)
				gotoAndPlay(label);
		}

	}
	
}
