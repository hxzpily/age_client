package nt.lib.util
{
	import flash.system.Capabilities;

	/**
	 * debug 异常抛出类
	 * @param b 值为flase则抛出异常
	 * @param m 如果错误类为空则抛出该错误信息
	 * @param errorClass 错误类
	 */
	[Inline]
	public function assert(b:Boolean, m:String = "", errorClass:Class = null):void
	{
		if (Capabilities.isDebugger)
		{
			if (!b)
			{
				throw new (errorClass ||= Error)(m);
			}
		}
	}
}
