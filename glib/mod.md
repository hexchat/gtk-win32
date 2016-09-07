* Download [GLib 2.48.2](http://ftp.gnome.org/pub/gnome/sources/glib/2.48/glib-2.48.2.tar.xz)
* In all vcxproj files:
	* Add `<Import Project="..\..\..\..\stack.props" />`
	* Remove all `<Optimization>` lines
* In `build\win32\vs14\glib-build-defines.props`
	* replace `intl.lib` with `libintl.lib`
	* Remove `;FFI_BUILDING` from `<GObjectBuildDefines>` since we build libffi as a DLL
* In `build\win32\vs14\glib-version-paths.props`, replace
	* `<GlibEtcInstallRoot>..\..\..\..\vs$(VSVer)\$(Platform)</GlibEtcInstallRoot>` with `<GlibEtcInstallRoot>..\..\..\..\..\..\gtk\$(Platform)</GlibEtcInstallRoot>`
	* `<CopyDir>$(GlibEtcInstallRoot)</CopyDir>` with `<CopyDir>..\..\..\..\glib-rel</CopyDir>`
	* `<GlibSeparateVSDllSuffix>-2-vs$(VSVer)</GlibSeparateVSDllSuffix>` with `<GlibSeparateVSDllSuffix>-2.0</GlibSeparateVSDllSuffix>`
	* `<PythonPath>c:\python27</PythonPath>` with `<PythonPath>..\..\..\..\..\..\python-2.7\$(Platform)</PythonPath>`
