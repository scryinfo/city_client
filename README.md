
1. Project introduction

	This is the client data warehouse of the ScryCity project, which is responsible for the presentation of the City project on the terminal. This project is developed by Unity3D game engine,
	The customized content includes two parts:
	The
	1. The logic code of the City project
	The
	2. Art resources of the City project

	Currently, the data warehouse only includes logic codes and no art resources. Because the art resources are not very large, they are not suitable for version management using git.
	The relevant resources may be put in the right place for downloading

2. Introduction to the logic code of the City project

	The City project includes three parts: project Lua code, Unity engine C# code and Tolua framework, among which:

	The project Lua code path is:

		city_client/Assets/CityGame/Lua/

	The C# code path is:

		city_client/Assets/CityGame/Scripts/

	Tolua framework part:

		city_client/Assets/CityGame/ToLua/

3. Compile and run

	1. This project realizes the compilation of different versions by controlling the macro settings in the Unity engine editor, which involves the following macros:

		HOTUP;LUA_BUNDEL;RES_BUNDEL;PUB_BUILD;LUA_LOG;ASYNC_MODE

		HOTUP controls whether to enable hot resource update

		LUA_BUNDEL whether to enable the bundle mode of Lua script

		RES_BUNDEL Whether to enable the bundle mode of art resources

		PUB_BUILD Whether to open the external network mode

		LUA_LOG Whether to enable script log printing and test grouping

		ASYNC_MODE Whether to enable the asynchronous mode for loading art resources
		
	2. Recommended macro settings during development

		* Intranet

			HOTUP1;LUA_BUNDEL1;RES_BUNDEL1;PUB_BUILD1;LUA_LOG;ASYNC_MODE

		* Extranet

			HOTUP1;LUA_BUNDEL1;RES_BUNDEL1;PUB_BUILD;LUA_LOG;ASYNC_MODE

	3. Recommended macro settings when packaging

		* Intranet

			HOTUP;LUA_BUNDEL;RES_BUNDEL;PUB_BUILD1;LUA_LOG1;ASYNC_MODE

				* Extranet

			HOTUP;LUA_BUNDEL;RES_BUNDEL;PUB_BUILD;LUA_LOG1;ASYNC_MODE
			

	
