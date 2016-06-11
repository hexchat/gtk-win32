* Download [ATK 2.20.0](http://ftp.gnome.org/pub/gnome/sources/atk/2.20/atk-2.20.0.tar.xz)
* In `build\win32\vs14\atk-build-defines.props`, replace:
	* `intl.lib` with `libintl.lib`
* In `build\win32\vs14\atk-version-paths.props`, replace:
	* `<GlibEtcInstallRoot>$(SolutionDir)\..\..\..\..\vs$(VSVer)\$(Platform)</GlibEtcInstallRoot>` with `<GlibEtcInstallRoot>$(SolutionDir)\..\..\..\..\..\..\gtk\$(Platform)</GlibEtcInstallRoot>`
	* `<CopyDir>$(GLibEtcInstallRoot)</CopyDir>` with `<CopyDir>..\..\..\..\atk-rel</CopyDir>`
	* `<AtkSeparateVSDllSuffix>-1-vs$(VSVer)</AtkSeparateVSDllSuffix>` with `<AtkSeparateVSDllSuffix>-1.0</AtkSeparateVSDllSuffix>`
* In `build\win32\vs14\atk.vcxproj`:
	* Add `<Import Project="..\..\..\..\stack.props" />`
	* Remove all `<Optimization>` lines
* Copy `build\detectenv-msvc.mak` from a newer project like gobject-introspection (Until VS2015 added)
