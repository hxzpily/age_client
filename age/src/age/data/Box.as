package age.data
{
	import flash.geom.Vector3D;
	import age.renderers.Direction;

	/**
	 * 长方体<br>
	 * 采用左手坐标系
* <pre>
*        upper
*    +----+
*   /    /|
*  +----+ |
*  |    | +
*  |    |/
*  +----+
* lower
* </pre>
	 * @author zhanghaocong
	 *
	 */
	public class Box
	{
		/**
		 * 左下角，一般是 (0, 0, 0)
		 */
		public var lower:Vector3D = new Vector3D;

		/**
		 * 右上角，一般是场景大小
		 */
		public var upper:Vector3D = new Vector3D;

		/**
		 * 中心点（以百分比记：x, y, z）<br>
		 * 默认为 [0.5, 0.5, 0.5]
		 */
		public var pivot:Vector3D = new Vector3D;

		/**
		 * 创建一个新的长方体<br>
		 *
		 * @param x
		 * @param y
		 * @param z
		 * @param width
		 * @param height
		 * @param depth
		 *
		 */
		public function Box(x:Number = 0, y:Number = 0, z:Number = 0, width:Number = 0, height:Number = 0, depth:Number = 0, pivotX:Number = 0.5, pivotY:Number = 0.5, pivotZ:Number = 0.5)
		{
			setTo(x, y, z, width, height, depth, pivotX, pivotY, pivotZ);
		}

		/**
		 * 移动所有原点到指定百分比位置<br>
		 * 0.5 表示居中
		 *
		 */
		public function movePivots(x:Number = 0.5, y:Number = 0.5, z:Number = 0.5):void
		{
			pivot.x = x;
			pivot.y = y;
			pivot.z = z;
			validate();
		}

		/**
		 * 左
		 * @return
		 *
		 */
		[Inline]
		final public function get left():Number
		{
			return lower.x;
		}

		/**
		 * 右
		 * @return
		 *
		 */
		[Inline]
		final public function get right():Number
		{
			return upper.x;
		}

		/**
		 * 上
		 * @return
		 *
		 */
		[Inline]
		final public function get top():Number
		{
			return upper.y;
		}

		/**
		 * 下
		 * @return
		 *
		 */
		[Inline]
		final public function get bottom():Number
		{
			return lower.y;
		}

		/**
		 * 前
		 * @return
		 *
		 */
		[Inline]
		final public function get front():Number
		{
			return lower.z;
		}

		/**
		 * 后
		 * @return
		 *
		 */
		[Inline]
		final public function get back():Number
		{
			return upper.z;
		}

		/**
		 * 提交数据到 lower 和 upper
		 *
		 */
		[Inline]
		final protected function validate():void
		{
			validateX();
			validateY();
			validateZ();
		}

		[Inline]
		final protected function validateX():void
		{
			lower.x = _x - _width * pivot.x;
			upper.x = _x + _width * (1 - pivot.x);

			if (_vertices)
			{
				_vertices = null;
			}
		}

		[Inline]
		final protected function validateY():void
		{
			lower.y = _y - _height * pivot.y;
			upper.y = _y + _height * (1 - pivot.y);

			if (_vertices)
			{
				_vertices = null;
			}
		}

		[Inline]
		final protected function validateZ():void
		{
			lower.z = _z - _depth * pivot.z;
			upper.z = _z + _depth * (1 - pivot.z);

			if (_vertices)
			{
				_vertices = null;
			}
		}

		private var _x:Number = 0;

		/**
		 * 中心点 x
		 * @return
		 *
		 */
		[Inline]
		final public function get x():Number
		{
			return _x;
		}

		[Inline]
		final public function set x(value:Number):void
		{
			_x = value;
			validateX();
		}

		private var _y:Number = 0;

		/**
		 * 计算出的中心点 y
		 * @return
		 *
		 */
		[Inline]
		final public function get y():Number
		{
			return _y;
		}

		[Inline]
		final public function set y(value:Number):void
		{
			_y = value;
			validateY();
		}

		private var _z:Number = 0;

		/**
		 * 计算出的中心点 z
		 * @return
		 *
		 */
		[Inline]
		final public function get z():Number
		{
			return _z;
		}

		[Inline]
		final public function set z(value:Number):void
		{
			_z = value;
			validateZ()
		}

		private var _width:Number = 0;

		/**
		 * width
		 * @return
		 *
		 */
		[Inline]
		final public function get width():Number
		{
			return _width;
		}

		[Inline]
		final public function set width(value:Number):void
		{
			_width = value;
			validateX();
		}

		private var _height:Number = 0;

		/**
		 * height
		 * @return
		 *
		 */
		[Inline]
		final public function get height():Number
		{
			return _height;
		}

		[Inline]
		final public function set height(value:Number):void
		{
			_height = value;
			validateY();
		}

		private var _depth:Number = 0;

		/**
		 * depth
		 * @return
		 *
		 */
		[Inline]
		final public function get depth():Number
		{
			return _depth;
		}

		[Inline]
		final public function set depth(value:Number):void
		{
			_depth = value;
			validateZ();
		}

		/**
		 * 设置 Box 到指定属性
		 * @param x
		 * @param y
		 * @param z
		 * @param width
		 * @param height
		 * @param depth
		 * @param pivotX
		 * @param pivotY
		 * @param pivotZ
		 * @param rotationX
		 *
		 */
		public function setTo(x:Number, y:Number, z:Number, width:Number, height:Number, depth:Number, pivotX:Number = NaN, pivotY:Number = NaN, pivotZ:Number = NaN, rotationX:Number = NaN):void
		{
			if (!isNaN(pivotX))
			{
				pivot.x = pivotX;
			}

			if (!isNaN(pivotY))
			{
				pivot.y = pivotY;
			}

			if (!isNaN(pivotZ))
			{
				pivot.z = pivotZ;
			}

			if (!isNaN(width))
			{
				_width = width;
			}

			if (!isNaN(height))
			{
				_height = height;
			}

			if (!isNaN(depth))
			{
				_depth = depth;
			}

			if (!isNaN(x))
			{
				_x = x;
			}

			if (!isNaN(y))
			{
				_y = y;
			}

			if (!isNaN(z))
			{
				_z = z;
			}
			validate();
		}

		/**
		 * 获得与指定 Box 的相交部分，如果没有相交则返回 null
		 * @param b
		 * @return
		 *
		 */
		public function intersection(other:Box):Box
		{
			if (!intersect(other))
			{
				return null;
			}
			var v:Vector3D;
			var vertices:Vector.<Vector3D>;
			var i:int;
			var intersections:Array = new Array();
			vertices = this.vertices;

			for (i = 0; i < vertices.length; i++)
			{
				v = vertices[i];

				if (other.isInBox(v.x, v.y, v.z))
				{
					intersections.push(v);
				}
			}
			vertices = other.vertices;

			for (i = 0; i < vertices.length; i++)
			{
				v = vertices[i];

				if (isInBox(v.x, v.y, v.z))
				{
					intersections.push(v);
				}
			}
			var xIndexs:Array = intersections.sortOn("x", Array.NUMERIC | Array.RETURNINDEXEDARRAY);
			var yIndexs:Array = intersections.sortOn("y", Array.NUMERIC | Array.RETURNINDEXEDARRAY);
			var zIndexs:Array = intersections.sortOn("z", Array.NUMERIC | Array.RETURNINDEXEDARRAY);
			const lastIndex:int = intersections.length - 1;
			var box:Box = new Box();
			box.fromVector3D(new Vector3D(intersections[xIndexs[0]].x, intersections[yIndexs[0]].y, intersections[zIndexs[0]].z), new Vector3D(intersections[xIndexs[lastIndex]].x, intersections[yIndexs[lastIndex]].y, intersections[zIndexs[lastIndex]].z), new Vector3D(0.5, 0.5, 0.5));
			return box;
		}

		/**
		 * 检查点是否在 Box 内
		 * @param x
		 * @param y
		 * @param z
		 * @return
		 *
		 */
		public function isInBox(x:Number, y:Number, z:Number):Boolean
		{
			var result:Boolean = true;

			do
			{
				if (x < lower.x || x > upper.x)
				{
					result = false;
				}

				if (!result)
				{
					break;
				}

				if (y < lower.y || y > upper.y)
				{
					result = false;
				}

				if (!result)
				{
					break;
				}

				if (z < lower.z || z > upper.z)
				{
					result = false;
				}
			} while (false);
			return result;
		}

		/**
		 * 判断指定 Box 是否相交
		 * @param b
		 * @return
		 *
		 */
		public function intersect(otherBox:Box):Boolean
		{
			if (_width == 0 && _height == 0 && _depth == 0)
			{
				return false;
			}
			var v:Vector3D;
			var buffer:Vector.<Vector3D>;
			var i:int;
			buffer = this.vertices;

			for (i = 0; i < buffer.length; i++)
			{
				v = buffer[i];

				if (otherBox.isInBox(v.x, v.y, v.z))
				{
					return true;
				}
			}
			buffer = otherBox.vertices;

			for (i = 0; i < buffer.length; i++)
			{
				v = buffer[i];

				if (this.isInBox(v.x, v.y, v.z))
				{
					return true;
				}
			}
			return false;
		}

		public static const BOX_SURFACE_FRONT:Number = 0;

		public static const BOX_SURFACE_BACK:Number = 1;

		public static const BOX_SURFACE_POS_LEFT:Number = 0;

		public static const BOX_SURFACE_POS_RIGHT:Number = 1;

		public static const BOX_SURFACE_POS_BOTTOM:Number = 0;

		public static const BOX_SURFACE_POS_TOP:Number = 1;

		public static const BOX_SURFACE_POS_CENTER:Number = 1;

		/**
		 * 根据 pivot 获得顶点
		 * @param pivotX
		 * @param pivotY
		 * @param pivotZ
		 * @return
		 *
		 */
		public function getVertex(pivotX:Number, pivotY:Number, pivotZ:Number):Vector3D
		{
			return new Vector3D(lower.x + (upper.x - lower.x) * pivotX, lower.y + (upper.y - lower.y) * pivotY, lower.z + (upper.z - lower.z) * pivotZ);
		}

		private var _vertices:Vector.<Vector3D>;

		/**
		 * 8 个顶点
		 */
		[Inline]
		final public function get vertices():Vector.<Vector3D>
		{
			if (!_vertices)
			{
				_vertices = new Vector.<Vector3D>(8, true);
				_vertices[0] = getVertex(BOX_SURFACE_POS_LEFT, BOX_SURFACE_POS_BOTTOM, BOX_SURFACE_FRONT);
				_vertices[1] = getVertex(BOX_SURFACE_POS_RIGHT, BOX_SURFACE_POS_BOTTOM, BOX_SURFACE_FRONT);
				_vertices[2] = getVertex(BOX_SURFACE_POS_RIGHT, BOX_SURFACE_POS_TOP, BOX_SURFACE_FRONT);
				_vertices[3] = getVertex(BOX_SURFACE_POS_LEFT, BOX_SURFACE_POS_TOP, BOX_SURFACE_FRONT);
				_vertices[4] = getVertex(BOX_SURFACE_POS_LEFT, BOX_SURFACE_POS_BOTTOM, BOX_SURFACE_BACK);
				_vertices[5] = getVertex(BOX_SURFACE_POS_RIGHT, BOX_SURFACE_POS_BOTTOM, BOX_SURFACE_BACK);
				_vertices[6] = getVertex(BOX_SURFACE_POS_RIGHT, BOX_SURFACE_POS_TOP, BOX_SURFACE_BACK);
				_vertices[7] = getVertex(BOX_SURFACE_POS_LEFT, BOX_SURFACE_POS_TOP, BOX_SURFACE_BACK);
			}
			return _vertices;
		}

		/**
		 * 从 JSON 恢复数据
		 * @param s
		 *
		 */
		public function fromJSON(s:*):void
		{
			lower.setTo(s[0], s[1], s[2]);
			upper.setTo(s[3], s[4], s[5]);

			if (s.length > 6)
			{
				pivot.setTo(s[6], s[7], s[8]);
			}
			else
			{
				// 默认原点是中心
				pivot.setTo(0.5, 0.5, 0.5);
			}
			restoreOtherProps();
		}

		/**
		 * 通过 3 个 Vector3D 设定当前 Box
		 * @param lower
		 * @param upper
		 * @param pivot
		 * @return
		 *
		 */
		public function fromVector3D(lower:Vector3D, upper:Vector3D, pivot:Vector3D):void
		{
			this.lower.copyFrom(lower);
			this.upper.copyFrom(upper);
			this.pivot.copyFrom(pivot);
			restoreOtherProps();
		}

		/**
		 * 从另一个 Box 更新数据
		 * @param box
		 *
		 */
		public function fromBox(box:Box):void
		{
			lower.copyFrom(box.lower);
			upper.copyFrom(box.upper);
			pivot.copyFrom(box.pivot);
			_direction = box.direction;
			restoreOtherProps();
		}

		/**
		 * 根据 lower 和 upper 反推出宽高坐标
		 */
		[Inline]
		final protected function restoreOtherProps():void
		{
			_width = upper.x - lower.x;
			_height = upper.y - lower.y;
			_depth = upper.z - lower.z;
			_x = lower.x + _width * pivot.x;
			_y = lower.y + _height * pivot.y;
			_z = lower.z + _depth * pivot.z;
			_vertices = null;
		}

		private var _direction:int = Direction.RIGHT;

		/**
		 * 设置或获取方向，默认朝右
		 * @see age.renderers.Direction
		 * @return
		 *
		 */
		public function get direction():int
		{
			return _direction;
		}

		/**
		 * @private
		 */
		public function set direction(value:int):void
		{
			if (_direction != value)
			{
				_direction = value;
				validateDirection();
				_vertices = null
			}
		}

		/**
		 * @private
		 *
		 */
		private function validateDirection():void
		{
			const pivotX:Number = pivot.x * _width;
			const pivotY:Number = pivot.y * _height;
			const pivotZ:Number = pivot.z * _depth;
			lower.x = _x - pivotX;
			lower.y = _y - pivotY;
			lower.z = _z - pivotZ;
			upper.x = _x - pivotX + _width;
			upper.y = _y - pivotY + _height;
			upper.z = _z - pivotZ + _depth;
		}

		/**
		 * 导出到 JSON
		 * @param k
		 * @return
		 *
		 */
		public function toJSON(k:*):*
		{
			// 以 9 个数字表示一个 Box
			return [ lower.x, lower.y, lower.z, upper.x, upper.y, upper.z, pivot.x,
					 pivot.y, pivot.z ];
		}

		/**
		 * 返回当前 Box 的副本
		 * @return
		 *
		 */
		public function clone1():Box
		{
			return new Box(x, y, z, width, height, depth, pivot.x, pivot.y, pivot.z);
		}

		/**
		 * 设置坐标
		 * @param position
		 *
		 */
		public function setPosition(position:Vector3D):void
		{
			_x = position.x;
			_y = position.y;
			_z = position.z;
			validate();
		}
	}
}
