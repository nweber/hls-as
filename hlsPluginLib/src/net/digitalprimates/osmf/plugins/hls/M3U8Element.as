package net.digitalprimates.osmf.plugins.hls
{
	import org.osmf.elements.LoadFromDocumentElement;
	import org.osmf.media.MediaResourceBase;

	/**
	 *
	 *
	 * @author Nathan Weber
	 */
	public class M3U8Element extends LoadFromDocumentElement
	{
		//----------------------------------------
		//
		// Constructor
		//
		//----------------------------------------

		public function M3U8Element(resource:MediaResourceBase = null, loader:M3U8Loader = null) {
			if (loader == null) {
				loader = new M3U8Loader();
			}
			super(resource, loader);
		}
	}
}
