* Download [GDK-PixBuf 2.34.0](http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.34/gdk-pixbuf-2.34.0.tar.xz)
* In `build\win32\vs14\gdk-pixbuf-build-defines.props`, replace `intl.lib` with `libintl.lib`
* In `build\win32\vs14\gdk-pixbuf-version-paths.props`, replace:
	* `<GlibEtcInstallRoot>$(SolutionDir)..\..\..\..\vs$(VSVer)\$(Platform)</GlibEtcInstallRoot>` with `<GlibEtcInstallRoot>$(SolutionDir)..\..\..\..\..\..\gtk\$(Platform)</GlibEtcInstallRoot>`
	* `<CopyDir>$(GlibEtcInstallRoot)</CopyDir>` with `<CopyDir>$(SolutionDir)..\..\..\..\gdk-pixbuf-rel</CopyDir>`
	* `<GdkPixbufSeparateVSDllSuffix>-2-vs$(VSVer)</GdkPixbufSeparateVSDllSuffix>` with `<GdkPixbufSeparateVSDllSuffix>-2.0</GdkPixbufSeparateVSDllSuffix>`
* Copy `build\detectenv-msvc.mak` from a newer project like gobject-introspection (Until VS2015 added)
