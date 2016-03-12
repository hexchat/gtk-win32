* Download [FreeType 2.6.3](http://download.savannah.gnu.org/releases/freetype/freetype-2.6.3.tar.bz2)
* Copy `builds\windows\vc2010` to `builds\windows\vc2015`
* In `builds\windows\vc2015\freetype.vcxproj`:
	* Replace `<PlatformToolset>v100</PlatformToolset>` with `<PlatformToolset>v140</PlatformToolset>`
	* Replace all `vc2010` in `<OutDir>` and `<IntDir>` with `vc2015`
	* Replace
		```
		    <TargetName Condition="'$(Configuration)|$(Platform)'=='Release|Win32'">freetype263</TargetName>
		    <TargetName Condition="'$(Configuration)|$(Platform)'=='Release|x64'">freetype263</TargetName>
		```
		with
		```
		    <TargetName Condition="'$(Configuration)|$(Platform)'=='Release|Win32'">freetype</TargetName>
		    <TargetName Condition="'$(Configuration)|$(Platform)'=='Release|x64'">freetype</TargetName>
		```
	* Add `<ClCompile Include="..\..\..\src\base\ftbdf.c" />`
	* Add `<Import Project="..\..\..\..\stack.props" />` at the end
	* Delete `<Optimization>` lines
	* Replace all instances of `..\..\..\include\freetype\config\` with `..\..\..\include\config\`
