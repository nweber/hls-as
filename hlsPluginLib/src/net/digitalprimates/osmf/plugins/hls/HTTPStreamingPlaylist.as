package net.digitalprimates.osmf.plugins.hls
{
	/**
	 *
	 *
	 * @author Nathan Weber
	 */
	public class HTTPStreamingPlaylist
	{
		//----------------------------------------
		//
		// Variables
		//
		//----------------------------------------

		private var _streamName:String;

		private var _bitrate:Number;

		//----------------------------------------
		//
		// Properties
		//
		//----------------------------------------

		public function get streamName():String {
			return _streamName;
		}

		public function get bitrate():Number {
			return _bitrate;
		}

		//----------------------------------------
		//
		// Constructor
		//
		//----------------------------------------

		public function HTTPStreamingPlaylist(streamName:String, bitrate:Number) {
			_streamName = streamName;
			_bitrate = bitrate;
		}
	}
}
