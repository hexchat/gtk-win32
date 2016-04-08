* Download [Pango 1.39.0](http://ftp.gnome.org/pub/GNOME/sources/pango/1.39/pango-1.39.0.tar.xz)
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
* Copy `build\detectenv-msvc.mak` from a newer project such as gobject-introspection (Simply includes VS2015 info)
