package  {
	
	public class Debug {

		static public function getStackTrace():void {
			try {
				throw new Error();
			}
			catch(e:Error) {
				trace(e.getStackTrace());
			}
		}

	}
	
}
