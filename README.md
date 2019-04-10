1、 项目介绍
这是ScryCity项目的客户端数据仓，负责City项目在终端上的呈现。 该项目是居于Unity3D游戏引擎开发的，其中定制化的内容包括两部分：
	1、 City项目的逻辑代码
	2、 City项目的美术资源
目前该数据仓仅包括逻辑代码，没有美术资源。 因为美术资源非容量常大，不适于使用git进行版本管理。后边可能会把相关资源放到合适的地方，以便下载
2、 City项目的逻辑代码介绍
	City项目包括项目Lua代码，Unity引擎C#代码和Tolua框架三部分， 其中：
	项目Lua代码路径为：
		city_client/Assets/CityGame/Lua/
	C#代码路径为：
		city_client/Assets/CityGame/Scripts/
	Tolua框架部分：
		city_client/Assets/CityGame/ToLua/
3、编译和运行
	1、 该项目通过Unity引擎编辑器中的宏设置来控制来实现其不同目的编译目的，涉及到如下宏：
		HOTUP;LUA_BUNDEL;RES_BUNDEL;PUB_BUILD;LUA_LOG;ASYNC_MODE
		HOTUP 控制是否开启热资源更新
		LUA_BUNDEL 是否开启Lua脚本的 bundle 模式
		RES_BUNDEL 是否开启美术资源的 bundle 模式
		PUB_BUILD	是否开启外网模式
		LUA_LOG	是否开启脚本的打印及分组测试
		ASYNC_MODE 是否开启美术资源加载的异步模式
	2、 开发时的推荐宏设置
		* 内网
			HOTUP1;LUA_BUNDEL1;RES_BUNDEL1;PUB_BUILD1;LUA_LOG;ASYNC_MODE
		* 外网
			HOTUP1;LUA_BUNDEL1;RES_BUNDEL1;PUB_BUILD;LUA_LOG;ASYNC_MODE
	3、 打包时的推荐宏设置
		* 内网
			HOTUP;LUA_BUNDEL;RES_BUNDEL;PUB_BUILD1;LUA_LOG1;ASYNC_MODE
		* 外网
			HOTUP;LUA_BUNDEL;RES_BUNDEL;PUB_BUILD;LUA_LOG1;ASYNC_MODE
