 * Download [GTK+ 2.24.30](http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.30.tar.xz)
 * In `build\win32\vs12\gtk-build-defines.props`, replace:
	* `intl.lib` with `libintl.lib`
 * In `build\win32\vs12\gtk-install.props`:
	* Add `;$(BinDir)\libpixmap.dll` to `<InstalledDlls>`
	* Add to `<GtkDoInstall`:
`
copy "$(BinDir)\$(GtkDllPrefix)gdk$(GtkDllSuffix).pdb" $(CopyDir)\bin
copy "$(BinDir)\libpixmap.pdb" $(CopyDir)\bin
copy "$(BinDir)\libwimp.pdb" $(CopyDir)\bin
`
	* Add to `GtkDoInstall`:
`copy "$(BinDir)\libpixmap.dll" $(CopyDir)\lib\gtk-$(ApiVersion)\$(GtkHost)\engines`
 * In `build\win32\vs12\gtk-version-paths.props`, replace:
	* `<GlibEtcInstallRoot>..\..\..\..\vs$(VSVer)\$(Platform)</GlibEtcInstallRoot>` with
`<GlibEtcInstallRoot>..\..\..\..\..\..\gtk\$(Platform)</GlibEtcInstallRoot>`
	* `<CopyDir>$(GlibEtcInstallRoot)</CopyDir>` with
`<CopyDir>..\..\..\..\gtk-rel</CopyDir>`
	* `<GtkSeparateVSDllSuffix>-2-vs$(VSVer)</GtkSeparateVSDllSuffix>` with
`<GtkSeparateVSDllSuffix>-2.0</GtkSeparateVSDllSuffix>`
 * Delete `<Optimization>` lines in all `*.vcxproj` files

  * Port introspection files in `build` from gtk3
     * `msvcfiles.py` and `introspection-msvc.mak` are unmodified
	 * `detectenv_msvc.mak` is from gobject-introspection (for VS2015)
	 * `gen-file-list-gtk.py` simply required scanning the correct am files and
	   using  the correct am variable names.
	 * `gtk-introspection-msvc.mak` requires replacing any 3.0 with 2.0, replacing lib names with -win32 variants,
	   and fixing include (..\gdk\win32) for GdkWin32.