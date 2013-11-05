package age.assets
{
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	import age.utils.__projectY;
	import nt.assets.Asset;

	/**
	 * SceneInfo 是场景信息<br>
	 * 包含了多个场景的图层
	 * @author zhanghaocong
	 */
	public class SceneInfo
	{
		/**
		 * ID
		 */
		public var id:String;

		/**
		 * 宽
		 */
		public var width:uint = 0;

		/**
		 * 高
		 */
		public var height:uint = 0;

		/**
		 * 深
		 */
		public var depth:Number = 0;

		/**
		 * 场景的下标，这里可以视作左下角位置
		 */
		public var lower:Vector3D = new Vector3D();

		/**
		 * 地面摩擦力
		 */
		public var friction:Number = 1 - 0.21;

		/**
		 * 空气阻力
		 */
		public var airResistance:Number = 1 - 0.02;

		/**
		 * 场景的重力（风力？）
		 * x 表示水平重力（风力）
		 * y 表示纵向重力（风力）
		 * z 表示前后重力（风力）
		 */
		public var g:Vector3D = new Vector3D(1, 9.8, 1);

		/**
		 * 场景图层列表<br>
		 * 在渲染时，索引大的遮挡索引小的<br>
		 * @see SceneLayerInfo
		 */
		public var layers:Vector.<LayerInfo> = new Vector.<LayerInfo>;

		/**
		 * 位于 layers 的角色层索引<br>
		 * 默认为 0
		 */
		public var charLayerIndex:int = 0;

		/**
		 * 寻路网格<br>
		 * 储存形式是 [z][x]<br>
		 * 默认值为一个网格
		 */
		public var grids:Array = [[ 0 ]];

		/**
		 * 网格大小
		 */
		public var gridResolution:Vector3D;

		/**
		 * 区域列表
		 */
		public var regions:Vector.<RegionInfo> = new Vector.<RegionInfo>;

		/**
		 * 用于创建 LayerInfo 的类<br>
		 * 默认值 LayerInfo
		 * @return
		 *
		 */
		protected function get layerInfoClass():Class
		{
			return LayerInfo;
		}

		/**
		 * 用于创建 RegionInfo 的类<br>
		 * 默认值 RegionInfo
		 * @return
		 *
		 */
		protected function get regionInfoClass():Class
		{
			return RegionInfo;
		}

		/**
		 * 创建一个新的 SceneInfo
		 * @param raw
		 */
		public function SceneInfo(raw:Object = null)
		{
			fromJSON(raw);
		}

		/**
		 * 获得图层数目
		 * @return
		 *
		 */
		final public function get numLayers():int
		{
			return layers.length;
		}

		/**
		 * 根据 id 获得指定的区域对象<br>
		 * 索引为 0 的区域默认就有，属无效区域
		 * @param regionID
		 * @return
		 *
		 */
		public function getRegionByID(id:int):RegionInfo
		{
			for (var i:int = regions.length - 1; i >= 0; i--)
			{
				if (regions[i].id == id)
				{
					return regions[i];
				}
			}
			return null;
		}

		/**
		 * 区域总数<br>
		 * 第一个区域从 1 开始<br>
		 * 是无效的
		 * @return
		 *
		 */
		public function get numRegions():int
		{
			return regions.length - 1;
		}

		/**
		 * 获得角色层<br>
		 * 角色层的索引由 charLayerIndex 设置
		 * @return
		 *
		 */
		final public function get charLayer():LayerInfo
		{
			return layers[charLayerIndex];
		}

		/**
		 * 根据指定的 actions 获得 objects 中使用的 assets
		 * @param actions
		 * @return
		 *
		 */
		public function getObjectFullAssets(actions:Vector.<String>):Vector.<Asset>
		{
			throw new Error("尚未实现");
			return null;
		}

		/**
		 * 根据指定的 actions 获得 objects 中使用的 assets 的缩略图
		 * @param actions
		 * @return
		 *
		 */
		public function getObjectThumbAssets(actions:Vector.<String>):Vector.<Asset>
		{
			throw new Error("尚未实现");
			return null;
		}

		/**
		 * 获得所有背景贴图的 assets
		 * @return
		 *
		 */
		public function getBGAssets():Vector.<Asset>
		{
			var uniqueListHelper:Object = {};

			for each (var l:LayerInfo in layers)
			{
				var bgAssets:Vector.<Asset> = l.getBGAssets();

				for each (var a:Asset in bgAssets)
				{
					uniqueListHelper[a.path] = true;
				}
			}
			var result:Vector.<Asset> = new Vector.<Asset>();

			for (var path:String in uniqueListHelper)
			{
				var ta:TextureAsset = TextureAsset.get(path) as TextureAsset;
				ta.useThumb = false;
				result.push(ta);
			}
			return result;
		}

		/**
		 * 投影 y, z 到 UI 坐标
		 * @param y
		 * @param z
		 * @return
		 *
		 */
		public function projectY(y:Number, z:Number):Number
		{
			return __projectY(y, z, height);
		}

		/**
		 * UI 坐标系转换到 y 坐标
		 * @param y
		 * @return
		 *
		 */
		public function uiToY(y:Number):Number
		{
			return height - y;
		}

		/**
		 * UI 坐标系转换到 z 坐标
		 * @param y
		 * @return
		 *
		 */
		public function uiToZ(y:Number):Number
		{
			return (depth - y) * 2;
		}

		/**
		 * 从当前 SceneInfo 中派生出新的，并且所有属性都一样
		 * @return
		 *
		 */
		public function fork():SceneInfo
		{
			return new SceneInfo(JSON.parse(JSON.stringify(this)));
		}

		/**
		 * 所有 SceneInfo 按 id 存在这里
		 */
		public static var list:Object = {};

		/**
		 * 场景贴图的子文件夹
		 */
		public static var folder:String;

		/**
		 * 获得相对于 folder 的路径
		 * @param args
		 *
		 */
		public static function resolvePath(... args):String
		{
			return folder + "/" + args.join("/");
		}

		/**
		 * 从 JSON 中转换出场景列表
		 * @param json
		 *
		 */
		public static function init(o:Object, folder:String = ""):void
		{
			list = o.list;
			SceneInfo.folder = folder;
		}

		/**
		 * 根据 id 获得一个 SceneInfo
		 * @param id
		 * @return
		 *
		 */
		public static function get(id:String):SceneInfo
		{
			if (!(list[id] is SceneInfo)) // 获取时才进行转换操作
			{
				trace("[SceneInfo] 已运行时实例化 ID =", id);
				list[id] = new SceneInfo(list[id]);
				SceneInfo(list[id]).id = id; // 运行时复制 ID
			}
			return list[id];
		}

		/**
		 * JSON.stringify 内部会调用的方法
		 * @param k
		 * @return
		 *
		 */
		public function toJSON(k:*):*
		{
			// 这里输出的 JSON 并不记录 ID，这可以确保修改文件名就可以改场景 ID
			var result:Object = { width: width, height: height, depth: depth,
					charLayerIndex: charLayerIndex, grids: grids, layers: layers,
					regions: regions, g: [ g.x, g.y, g.z ], lower: [ lower.x, lower.y,
																	 lower.z ], friction: friction };
			return result;
		}

		/**
		 * 从 JSON 反序列化
		 * @param s
		 *
		 */
		public function fromJSON(s:*):void
		{
			if (s)
			{
				var started:Number = getTimer();
				id = s.id;
				width = s.width;
				height = s.height;
				depth = s.depth || s.height;
				charLayerIndex = s.charLayerIndex;
				grids = s.grids; // 这里要当心 raw.grids 被修改。方便起见先这么做，应该没什么问题
				restore(s, this, "friction");

				if (grids)
				{
					gridResolution = new Vector3D(grids.length > 0 ? grids[0].length : 0, 0, grids.length);
				}
				var i:int, n:int;

				// 图层
				for (i = 0, n = s.layers.length; i < n; i++)
				{
					var layerInfo:LayerInfo = new layerInfoClass(s.layers[i], this);
					layerInfo.parent = this;
					layers.push(layerInfo);
				}
				// 标记角色层
				layers[charLayerIndex].isCharLayer = true;

				// 区域
				if (s.regions)
				{
					for (i = 0, n = s.regions.length; i < n; i++)
					{
						var r:RegionInfo = new regionInfoClass(s.regions[i]);
						r.parent = this;
						regions.push(r);
					}
				}

				// g
				if (s.g)
				{
					g = new Vector3D(s.g[0], s.g[1], s.g[2]);
				}

				// 下标
				if (s.lower)
				{
					lower = new Vector3D(s.lower[0], s.lower[1], s.lower[2]);
				}
				trace("[SceneInfo] 反序列化耗时", getTimer() - started + "ms");
			}
		}
	}
}
