package net.digitalprimates.osmf.plugins.hls
{
	import org.osmf.net.httpstreaming.HTTPStreamingIndexInfoBase;

	/**
	 *
	 *
	 * @author Nathan Weber
	 */
	public class HTTPStreamingItemsIndexInfo extends HTTPStreamingIndexInfoBase
	{
		//----------------------------------------
		//
		// Variables
		//
		//----------------------------------------

		private var _url:String;
		private var _streamInfos:Vector.<HTTPStreamingPlaylist>;

		//----------------------------------------
		//
		// Properties
		//
		//----------------------------------------

		public function get url():String {
			return _url;
		}
		
		public function get streamInfos():Vector.<HTTPStreamingPlaylist> {
			return _streamInfos;
		}

		//----------------------------------------
		//
		// Constructor
		//
		//----------------------------------------

		public function HTTPStreamingItemsIndexInfo(url:String, streamInfos:Vector.<HTTPStreamingPlaylist>) {
			_url = url;
			_streamInfos = streamInfos;
		}
	}
}
