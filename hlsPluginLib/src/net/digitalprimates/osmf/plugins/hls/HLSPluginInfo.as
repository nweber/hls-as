package net.digitalprimates.osmf.plugins.hls
{
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactoryItem;
	import org.osmf.media.PluginInfo;

	/**
	 * Plugin wrapper for the HLS OSMF plugin available at http://code.google.com/p/apple-http-osmf/.
	 * HLS OSMF code original code is from Matthew Kaufman.  See the license block on any file
	 * in the at.matthew.httpstreaming package.
	 *
	 * @author Nathan Weber
	 */
	public class HLSPluginInfo extends PluginInfo
	{
		//----------------------------------------
		//
		// Properties
		//
		//----------------------------------------

		private var loader:M3U8Loader;

		//----------------------------------------
		//
		// Internal Methods
		//
		//----------------------------------------

		protected function getMediaElement():MediaElement {
			return new M3U8Element(null, loader);
		}

		//----------------------------------------
		//
		// Constructor
		//
		//----------------------------------------

		public function HLSPluginInfo(mediaFactoryItems:Vector.<MediaFactoryItem> = null, mediaElementCreationNotificationFunction:Function = null) {
			if (!mediaFactoryItems) {
				mediaFactoryItems = new Vector.<MediaFactoryItem>();
			}

			var item:MediaFactoryItem;

			loader = new M3U8Loader();
			item = new MediaFactoryItem("net.digitalprimates.osmf.plugins.hls.m3u8", loader.canHandleResource, getMediaElement);
			mediaFactoryItems.push(item);

			super(mediaFactoryItems, mediaElementCreationNotificationFunction);
		}
	}
}
