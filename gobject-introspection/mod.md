* Download [GObject-Introspection 1.48.0](ftp://ftp.gnome.org/pub/GNOME/sources/gobject-introspection/1.48/gobject-introspection-1.48.0.tar.xz)
* In all vcxproj files:
	* Add `<Import Project="..\..\..\..\stack.props" />`
	* Remove all `<Optimization>` lines
* In `build\win32\vs14\glib-version-paths.props`, replace
	* `<GlibEtcInstallRoot>$(SolutionDir)\..\..\..\..\vs$(VSVer)\$(Platform)</GlibEtcInstallRoot>` with `<GlibEtcInstallRoot>$(SolutionDir)..\..\..\..\..\..\gtk\$(Platform)</GlibEtcInstallRoot>`
	* `<CopyDir>$(GlibEtcInstallRoot)</CopyDir>` with `<CopyDir>..\..\..\..\gobject-introspection-rel</CopyDir>`
	* `<GlibSeparateVSDllSuffix>-1-vs$(VSVer)</GlibSeparateVSDllSuffix>` with `<GlibSeparateVSDllSuffix>-1.0</GlibSeparateVSDllSuffix>`
	* `<PythonDir>c:\\python34</PythonDir>` with `<PythonDir>$(SolutionDir)..\..\..\..\..\..\python-2.7\$(Platform)</PythonDir>`
	* `<PythonDirX64>$(PythonDir).x64</PythonDirX64>` with `<PythonDirX64>$(SolutionDir)..\..\..\..\..\..\python-2.7\$(Platform)</PythonDirX64>`
* In `build\win32\vs14\gi-install.vcxproj`
	* Remove include of `gi-introspect.vcxproj`
* In `build\win32\vs14\gi-install.props`
	* Remove all files installed into `lib\girepository-1.0`
	* Remove all files installed into `share\gir-1.0`
	* Replace `$(SolutionDir)$(ConfigurationName)\$(PlatformName)\bin` with `$(bindir)`