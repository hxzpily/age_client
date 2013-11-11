package age.renderers
{
	import flash.errors.IllegalOperationError;
	import flash.geom.Vector3D;
	import starling.display.Quad;
	import starling.events.Event;

	/**
	 * 实现了 IDisplayObject3D 的 Quad 对象
	 * @author zhanghaocong
	 *
	 */
	public class Quad3D extends Quad implements IDisplayObject3D
	{
		/**
		 * constructor
		 *
		 */
		public function Quad3D(width:Number, height:Number, color:uint = 0xffffff, premultipliedAlpha:Boolean = true)
		{
			super(width, height, color, premultipliedAlpha);
			uniqueIndex = ZIndexHelper.getUniqueZIndex();
			addEventListener(Event.ADDED_TO_STAGE, onAdd);
		}

		/**
		 * 重设 Quad 到指定大小（使用 UI 坐标系）
		 * @param width
		 * @param height
		 *
		 */
		public function draw(width:Number, height:Number):void
		{
			mVertexData.setPosition(0, 0.0, 0.0);
			mVertexData.setPosition(1, width, 0.0);
			mVertexData.setPosition(2, 0.0, height);
			mVertexData.setPosition(3, width, height);
			onVertexDataChanged();
		}

		/**
		 * @private
		 *
		 */
		private function onAdd():void
		{
			projectY = SceneRenender(parent.parent).projectY;
		}

		protected var uniqueIndex:int;

		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		public function get zIndex():int
		{
			return position.z * ZIndexHelper.Z_RANGE;
		}

		private var _position:Vector3D = new Vector3D;

		/**
		 * @inheritDoc
		 *
		 */
		public function get position():Vector3D
		{
			return _position;
		}

		public function set position(value:Vector3D):void
		{
			_position = value;
			validatePosition();
		}

		/**
		 * 相当于调用 position.setTo(x, y, z); validatePosition();
		 * @param x
		 * @param y
		 * @param z
		 *
		 */
		public function setPosition(x:Number, y:Number, z:Number):void
		{
			position.setTo(x, y, z);
			validatePosition();
		}

		/**
		 * @inheritDoc
		 *
		 */
		public function setX(value:Number):void
		{
			position.x = value;
			validatePositionX();
		}

		/**
		 * @inheritDoc
		 *
		 */
		public function setY(value:Number):void
		{
			position.y = value;
			validatePositionYZ();
		}

		/**
		 * @inheritDoc
		 *
		 */
		public function setZ(value:Number):void
		{
			position.z = value;
			validatePositionYZ();
		}

		/**
		 * 当 position 发生变化时调用该方法以投影新坐标
		 *
		 */
		[Inline]
		final protected function validatePosition():void
		{
			if (_projectY == null)
			{
				return;
			}
			super.x = position.x;
			super.y = _projectY(position.y, position.z);
		}

		/**
		 * 当 position.x 发生变化时调用该方法以投影新坐标
		 *
		 */
		[Inline]
		final protected function validatePositionX():void
		{
			super.x = position.x;
		}

		/**
		 * 当 position.y 或 position.z 发生变化时调用该方法以投影新坐标
		 *
		 */
		[Inline]
		final protected function validatePositionYZ():void
		{
			if (_projectY == null)
			{
				return;
			}
			super.y = _projectY(position.y, position.z);
		}

		private var _projectY:Function;

		/**
		 * @inheritDoc
		 *
		 */
		public function get projectY():Function
		{
			return _projectY;
		}

		public function set projectY(value:Function):void
		{
			_projectY = value;

			if (value != null)
			{
				validatePosition();
			}
		}

		/**
		 * @private
		 */
		[Deprecated("不允许从外部设置该属性。如要设置坐标，请使用 position 属性或 setPosition", "position")]
		public override function set y(value:Number):void
		{
			throw new IllegalOperationError("不允许从外部设置该属性，要设置坐标，请使用 position 属性");
		}

		/**
		 * @private
		 */
		[Deprecated("不允许从外部设置该属性。如要设置坐标，请使用 position 属性或 setPosition", "position")]
		public override function set x(value:Number):void
		{
			throw new IllegalOperationError("不允许从外部设置该属性，要设置坐标，请使用 position 属性");
		}

		private var _scale:Number = 1;

		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		public function get scale():Number
		{
			return _scale;
		}

		public function set scale(value:Number):void
		{
			if (value != _scale)
			{
				_scale = value;
				scaleX = value;
				scaleY = value;
			}
		}

		override public function dispose():void
		{
			_projectY = null;
			super.dispose();
		}

		/**
		* 标记 visible 是否已经锁定<br>
		* 一旦锁定，将不能操作 visible 属性
		*/
		public var isVisibleLocked:Boolean = false;

		override public function set visible(value:Boolean):void
		{
			if (isVisibleLocked)
			{
				return;
			}
			super.visible = value;
		}
	}
}
