package
{
	import flash.utils.getQualifiedClassName;

	public class Log
	{
		public static function log( ... args ):void {
			var info:Object = getCallingInfo();
			var message:String = info.className + " :: " + info.methodName;

			for each ( var obj:Object in args ) {
				if ( obj != null )
					message += " :: " + obj.toString();
			}

			trace( message );
		}

		private static function getCallingInfo():Object {
			var tmp:Array = new Error().getStackTrace().split( "\n" );
			tmp = tmp[ 3 ].split( " " );
			tmp = tmp[ 1 ].split( "/" );

			var idx:int;

			var className:String = tmp[ 0 ];
			idx = className.lastIndexOf( "::" );
			if ( idx != -1 )
				className = className.substring( idx + 2 );

			var methodName:String = tmp[ 1 ];
			idx = methodName.lastIndexOf( "()" );
			if ( idx != -1 )
				methodName = methodName.substring( 0, idx );

			return { className:className, methodName:methodName };
		}
	}
}
