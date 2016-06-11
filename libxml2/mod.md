* Download [libxml2 2.9.3](ftp://xmlsoft.org/libxml2/libxml2-2.9.4.tar.gz)
* Copy `win32\VC10` to `win32\VC14`
* In `libxml2.vcxproj`:
	* Add
		```
		    <ProjectConfiguration Include="Release|x64">
		      <Configuration>Release</Configuration>
		      <Platform>x64</Platform>
		    </ProjectConfiguration>
		```
	* Add `<PlatformToolset>v140</PlatformToolset>` to all `<PropertyGroup>` elements that have `Label="Configuration"`
	* Replace `<ConfigurationType>Application</ConfigurationType>` with `<ConfigurationType>DynamicLibrary</ConfigurationType>`
	* Add
		```
		  <ImportGroup Condition="'$(Configuration)|$(Platform)'=='Release|x64'" Label="PropertySheets">
		    <Import Project="$(UserRootDir)\Microsoft.Cpp.$(Platform).user.props" Condition="exists('$(UserRootDir)\Microsoft.Cpp.$(Platform).user.props')" Label="LocalAppDataPlatform" />
		  </ImportGroup>
		```
	* Add `<Import Project="..\..\..\stack.props" />`
	* Replace
	```
	  <PropertyGroup Condition="'$(Configuration)|$(Platform)'=='Debug|Win32'">
	    <OutDir>$(ProjectDir)..\..\lib\</OutDir>
	  </PropertyGroup>
	  <PropertyGroup Condition="'$(Configuration)|$(Platform)'=='Debug|Win32'">
	    <IntDir>build\$(ProjectName)$(Configuration)\</IntDir>
	  </PropertyGroup>
	```
	with
	```
	  <PropertyGroup>
	    <OutDir>$(ProjectDir)..\..\lib\</OutDir>
	    <IntDir>build\$(ProjectName)$(Configuration)\</IntDir>
	  </PropertyGroup>
	```
	* Remove all `<Optimization>` elements
	* Add `<DisableSpecificWarnings>4996</DisableSpecificWarnings>`
	* In the `<ItemDefinitionGroup>` elements' `<Link>` tags for `Release|Win32` and `Release|x64`:
		* Under `<Compile>`, add:
			```
			      <AdditionalIncludeDirectories>$(ProjectDir);$(ProjectDir)..\..\include;$(ProjectDir)..\..\include;$(ProjectDir)..\..\..\..\..\gtk\$(Platform)\include;%(AdditionalIncludeDirectories)</AdditionalIncludeDirectories>
			      <DisableSpecificWarnings>4996</DisableSpecificWarnings>
			```
		* Under `<Link>`, add:
			```
			      <AdditionalLibraryDirectories>..\..\..\..\..\gtk\$(Platform)\lib;$(AdditionalLibraryDirectories)</AdditionalLibraryDirectories>
			      <AdditionalDependencies>ws2_32.lib;iconv.lib;%(AdditionalDependencies)</AdditionalDependencies>
			```
	* Remove
		```
		  <ItemGroup>
		    <ProjectReference Include="..\..\..\libiconv-1.14.vc10\windows\VC10\iconv.vcxproj">
		      <Project>{bec03130-a64c-48f8-863c-52da83cfb3ae}</Project>
		      <Private>true</Private>
		      <ReferenceOutputAssembly>true</ReferenceOutputAssembly>
		      <CopyLocalSatelliteAssemblies>false</CopyLocalSatelliteAssemblies>
		      <LinkLibraryDependencies>true</LinkLibraryDependencies>
		      <UseLibraryDependencyInputs>false</UseLibraryDependencyInputs>
		    </ProjectReference>
		  </ItemGroup>
		```
* In `win32\VC14\config.h`
	* Add
	```
	#define SEND_ARG2_CAST
	#define GETHOSTBYNAME_ARG_CAST
	```
	* Add `#undef LIBXML_LZMA_ENABLED`
