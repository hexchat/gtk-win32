* Download [Pango 1.38.0](http://ftp.gnome.org/pub/GNOME/sources/pango/1.38/pango-1.38.0.tar.xz)
* Patch with `patch -p1 -i pango-synthesize-all-fonts.patch`
* In all vcxproj files:
	* Add `<Import Project="..\..\..\..\stack.props" />`
	* Remove all `<Optimization>` lines
* In `build\win32\vs14\pango-build-defines.props`, replace:
	* `<PreprocessorDefinitions>HAVE_CONFIG_H;G_DISABLE_SINGLE_INCLUDES;%(PreprocessorDefinitions)</PreprocessorDefinitions>` with `<PreprocessorDefinitions>HAVE_CONFIG_H;G_DISABLE_SINGLE_INCLUDES;WIN32;%(PreprocessorDefinitions)</PreprocessorDefinitions>`
	* `intl.lib` with `libintl.lib`
* In `build\win32\vs14\pango-version-paths.props`, replace:
	* `<GlibEtcInstallRoot>$(SolutionDir)\..\..\..\..\vs$(VSVer)\$(Platform)</GlibEtcInstallRoot>` with `<GlibEtcInstallRoot>$(SolutionDir)..\..\..\..\..\..\gtk\$(Platform)</GlibEtcInstallRoot>`
	* `<CopyDir>$(GlibEtcInstallRoot)</CopyDir>` with `<CopyDir>$(SolutionDir)..\..\..\..\pango-rel</CopyDir>`
	* `<PangoSeparateVSDllSuffix>-1-vs$(VSVer)</PangoSeparateVSDllSuffix>` with `<PangoSeparateVSDllSuffix>-1.0</PangoSeparateVSDllSuffix>`
 * In `build\win32\vs14\pangoft2.vcxproj`, replace:
	* `<AdditionalDependencies>fontconfig.lib;freetype.lib;%(AdditionalDependencies)</AdditionalDependencies>` with
`<AdditionalDependencies>fontconfig.lib;freetype.lib;harfbuzz.lib;%(AdditionalDependencies)</AdditionalDependencies>`
