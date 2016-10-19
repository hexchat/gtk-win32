<#

.SYNOPSIS
This is a build script to build GTK+ 2 and openssl.


.DESCRIPTION
1. Install the requirements mentioned in the README
2. Run this script. Set the parameters, if needed.


.PARAMETER Configuration
The configuration to be built. One of the following:
x86       - 32-bit build.
x64       - 64-bit build. Uses the 32-bit cross-compiler with VS Community / VC++ Build Tools, or the native 64-bit compiler with VS Professional and up.


.PARAMETER TargetSDK
Overrides the default MSBuild WindowsTargetPlatformVersion property.


.PARAMETER DisableParallelBuild
Setting this to $true forces the items to be built one after the other.


.PARAMETER BuildDirectory
The directory where the sources will be downloaded and built.


.PARAMETER Msys2Directory
The directory where you installed msys2.


.PARAMETER ArchivesDownloadDirectory
The directory to download the source archives to. It will be created. If a source archive already exists here, it won't be downloaded again.


.PARAMETER PatchesRootDirectory
The directory where you checked out https://github.com/hexchat/gtk-win32.git


.PARAMETER VSInstallPath
The directory where you installed Visual Studio or the VC++ Build Tools.


.PARAMETER CMakePath
The directory where you installed cmake.


.PARAMETER PerlDirectory
The directory where you installed perl.


.PARAMETER OnlyBuild
A subset of the items you want built.


.EXAMPLE
build.ps1
Default paths. x86 build.


.EXAMPLE
build.ps1 -Configuration x64
Default paths. x64 build.


.EXAMPLE
build.ps1 -DisableParallelBuild
Default paths. Items are built one at a time. x86 build.


.EXAMPLE
build.ps1 -Msys2Directory D:\msys32 -ArchivesDownloadDirectory C:\hexchat-deps
Custom paths. x86 build.


.EXAMPLE
build.ps1 -OnlyBuild libpng
Only builds libpng and its dependencies (zlib).


.EXAMPLE
build.ps1 -TargetSDK 10.0.10240.0
Overrides MSBuild to use the Windows 10 SDK.


.LINK
https://github.com/hexchat/gtk-win32/

#>

#Requires -version 4.0

#========================================================================================================================================================
# Parameters begin here
#========================================================================================================================================================

param (
	[string][ValidateSet('x86', 'x64')]
	$Configuration = 'x86',

	[string]
	$TargetSDK,

	[switch]
	$DisableParallelBuild = $false,

	[string]
	$BuildDirectory = 'C:\gtk-build',

	[string]
	$Msys2Directory = 'C:\msys32',

	[string]
	$ArchivesDownloadDirectory = "$BuildDirectory\src",

	[string]
	$PatchesRootDirectory = "$BuildDirectory\github\gtk-win32",

	[string]
	$VSInstallPath = $(
		if (Test-Path 'C:\Program Files (x86)\Microsoft Visual C++ Build Tools\vcbuildtools.bat') {
			'C:\Program Files (x86)\Microsoft Visual C++ Build Tools'
		}
		else {
			'C:\Program Files (x86)\Microsoft Visual Studio 14.0'
		}
	),

	[string]
	$CMakePath = 'C:\Program Files\CMake\bin',

	[string]
	$PerlDirectory = "$BuildDirectory\perl-5.20",

	[string[]][ValidateSet('atk', 'cairo', 'enchant', 'fontconfig', 'freetype', 'gdk-pixbuf', 'gettext-runtime', 'glib', 'gobject-introspection', 'gtk', 'harfbuzz', 'lgi', 'libffi', 'libpng', 'libxml2', 'luajit', 'openssl', 'pango', 'pixman', 'pkg-config', 'win-iconv', 'zlib')]
	$OnlyBuild = @()
)

#========================================================================================================================================================
# Parameters end here
#========================================================================================================================================================

#========================================================================================================================================================
# Source URLs begin here
#========================================================================================================================================================

$items = @{
	'atk' = @{
		'ArchiveUrl' = 'https://dl.hexchat.net/gtk-win32/src/atk-2.20.0.tar.xz'
		'Dependencies' = @('glib', 'gobject-introspection')
	};

	'cairo' = @{
		'ArchiveUrl' = 'https://dl.hexchat.net/gtk-win32/src/cairo-1.14.6.tar.xz'
		'Dependencies' = @('fontconfig', 'glib', 'pixman')
	};

	'enchant' = @{
		'ArchiveUrl' = 'https://dl.hexchat.net/gtk-win32/src/enchant-1.6.1.tar.xz'
		'Dependencies' = @('glib')
	};

	'fontconfig' = @{
		'ArchiveUrl' = 'https://dl.hexchat.net/gtk-win32/src/fontconfig-2.8.0.tar.gz'
		'Dependencies' = @('freetype', 'libxml2')
	};

	'freetype' = @{
		'ArchiveUrl' = 'https://dl.hexchat.net/gtk-win32/src/freetype-2.6.5.tar.bz2'
		'Dependencies' = @()
	};

	'gdk-pixbuf' = @{
		'ArchiveUrl' = 'https://dl.hexchat.net/gtk-win32/src/gdk-pixbuf-2.34.0.tar.xz'
		'Dependencies' = @('glib', 'libpng', 'gobject-introspection')
	};

	'gettext-runtime' = @{
		'ArchiveUrl' = 'https://dl.hexchat.net/gtk-win32/src/gettext-vc100-0.18-src.tar.bz2'
		'Dependencies' = @('win-iconv')
	};

	'glib' = @{
		'ArchiveUrl' = 'https://dl.hexchat.net/gtk-win32/src/glib-2.48.2.tar.xz'
		'Dependencies' = @('gettext-runtime', 'libffi', 'zlib')
	};

	'gobject-introspection' = @{
		'ArchiveUrl' = 'https://dl.hexchat.net/gtk-win32/src/gobject-introspection-1.48.0.tar.xz'
		'Dependencies' = @('glib', 'cairo', 'pkg-config')
	};

	'gtk' = @{
		'ArchiveUrl' = 'https://dl.hexchat.net/gtk-win32/src/gtk+-2.24.30.tar.xz'
		'Dependencies' = @('atk', 'gdk-pixbuf', 'pango', 'gobject-introspection')
	};

	'harfbuzz' = @{
		'ArchiveUrl' = 'https://dl.hexchat.net/gtk-win32/src/harfbuzz-1.3.0.tar.bz2'
		'Dependencies' = @('freetype', 'glib')
	};

	'lgi' = @{
		'ArchiveUrl' = 'https://dl.hexchat.net/gtk-win32/src/lgi-0.9.1.tar.gz'
		'Dependencies' = @('luajit', 'gobject-introspection')
	}

	'libffi' = @{
		'ArchiveUrl' = 'https://dl.hexchat.net/gtk-win32/src/libffi-3.2.1.tar.gz'
		'Dependencies' = @()
	};

	'libpng' = @{
		'ArchiveUrl' = 'https://dl.hexchat.net/gtk-win32/src/libpng-1.6.25.tar.xz'
		'Dependencies' = @('zlib')
	};

	'libxml2' = @{
		'ArchiveUrl' = 'https://dl.hexchat.net/gtk-win32/src/libxml2-2.9.4.tar.gz'
		'Dependencies' = @('win-iconv')
	};

	'luajit' = @{
		'ArchiveUrl' = 'https://dl.hexchat.net/gtk-win32/src/luajit-2.0.4.tar.gz'
		'Dependencies' = @()
	};

	'openssl' = @{
		'ArchiveUrl' = 'https://dl.hexchat.net/gtk-win32/src/openssl-1.0.2h.tar.gz'
		'Dependencies' = @()
	};

	'pango' = @{
		'ArchiveUrl' = 'https://dl.hexchat.net/gtk-win32/src/pango-1.40.2.tar.xz'
		'Dependencies' = @('cairo', 'harfbuzz', 'gobject-introspection')
	};

	'pixman' = @{
		'ArchiveUrl' = 'https://dl.hexchat.net/gtk-win32/src/pixman-0.34.0.tar.gz'
		'Dependencies' = @('libpng')
	};

	'pkg-config' = @{
		'ArchiveUrl' = 'https://pkg-config.freedesktop.org/releases/pkg-config-0.29.1.tar.gz'
		'Dependencies' = @('glib')
	}

	'win-iconv' = @{
		'ArchiveUrl' = 'https://dl.hexchat.net/gtk-win32/src/win-iconv-0.0.8.tar.gz'
		'Dependencies' = @()
	};

	'zlib' = @{
		'ArchiveUrl' = 'https://dl.hexchat.net/gtk-win32/src/zlib-1.2.8.tar.xz'
		'Dependencies' = @()
	};
}

#========================================================================================================================================================
# Source URLs end here
#========================================================================================================================================================

#========================================================================================================================================================
# Build steps begin here
#========================================================================================================================================================

$items['atk'].BuildScript = {
	$packageDestination = "$PWD-rel"
	Remove-Item -Recurse $packageDestination -ErrorAction Ignore

	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	Exec msbuild build\win32\vs14\atk.sln /p:Platform=$platform /p:Configuration=Release /maxcpucount /nodeReuse:True $windowsTargetPlatformVersion

	[void] (Swap-Environment $originalEnvironment)

	New-Item -Type Directory $packageDestination\lib\pkgconfig
	Copy-Item .\atk.pc $packageDestination\lib\pkgconfig

	New-Item -Type Directory $packageDestination\share\doc\atk
	Copy-Item .\COPYING $packageDestination\share\doc\atk

	Package $packageDestination
	$packageDestination = "$PWD-gir-rel"

	Push-Location .\build
	
	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	Exec nmake -f .\atk-introspection-msvc.mak CFG=release PYTHON2=..\..\..\..\python-2.7\$platform\python.exe BASEDIR=..\..\..\..\gtk\$platform

	[void] (Swap-Environment $originalEnvironment)

	New-Item -Type Directory $packageDestination\lib\girepository-1.0
	Copy-Item .\*.typelib $packageDestination\lib\girepository-1.0

	New-Item -Type Directory $packageDestination\share\gir-1.0
	Copy-Item .\*.gir $packageDestination\share\gir-1.0
	
	Pop-Location

	Package $packageDestination
}

$items['cairo'].BuildScript = {
	$packageDestination = "$PWD-rel"
	Remove-Item -Recurse $packageDestination -ErrorAction Ignore

	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	Exec msbuild msvc\vc12\cairo.sln /p:Platform=$platform /p:Configuration=Release_FC /maxcpucount /nodeReuse:True $windowsTargetPlatformVersion

	[void] (Swap-Environment $originalEnvironment)

	New-Item -Type Directory $packageDestination\lib\pkgconfig
	Copy-Item .\cairo*.pc $packageDestination\lib\pkgconfig
	
	New-Item -Type Directory $packageDestination\share\doc\cairo
	Copy-Item .\COPYING $packageDestination\share\doc\cairo

	Package $packageDestination
}

$items['enchant'].BuildScript = {
	$packageDestination = "$PWD-$filenameArch"
	Remove-Item -Recurse $packageDestination -ErrorAction Ignore

	Push-Location .\src

	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	Exec nmake -f makefile.mak clean
	Exec nmake -f makefile.mak DLL=1 $(if ($filenameArch -eq 'x64') { 'X64=1' }) MFLAGS=-MD GLIBDIR=..\..\..\..\gtk\$platform\include\glib-2.0

	[void] (Swap-Environment $originalEnvironment)

	Pop-Location

	New-Item -Type Directory $packageDestination\bin
	Copy-Item `
		.\bin\release\enchant.exe, `
		.\bin\release\pdb\enchant.pdb, `
		.\bin\release\enchant-lsmod.exe, `
		.\bin\release\pdb\enchant-lsmod.pdb, `
		.\bin\release\test-enchant.exe, `
		.\bin\release\pdb\test-enchant.pdb, `
		.\bin\release\libenchant.dll, `
		.\bin\release\pdb\libenchant.pdb `
		$packageDestination\bin

	New-Item -Type Directory $packageDestination\etc\fonts
	Copy-Item `
		.\fonts.conf, `
		.\fonts.dtd `
		$packageDestination\etc\fonts

	New-Item -Type Directory $packageDestination\include\enchant
	Copy-Item `
		.\src\enchant.h, `
		.\src\enchant++.h, `
		.\src\enchant-provider.h `
		$packageDestination\include\enchant

	New-Item -Type Directory $packageDestination\lib\enchant
	Copy-Item `
		.\bin\release\libenchant.lib `
		$packageDestination\lib
	Copy-Item `
		.\bin\release\libenchant_ispell.dll, `
		.\bin\release\libenchant_ispell.lib, `
		.\bin\release\pdb\libenchant_ispell.pdb, `
		.\bin\release\libenchant_myspell.dll, `
		.\bin\release\libenchant_myspell.lib, `
		.\bin\release\pdb\libenchant_myspell.pdb `
		$packageDestination\lib\enchant

	New-Item -Type Directory $packageDestination\share\doc\enchant
	Copy-Item .\COPYING.LIB $packageDestination\share\doc\enchant\COPYING

	Package $packageDestination
}

$items['fontconfig'].BuildScript = {
	$packageDestination = "$PWD-$filenameArch"
	Remove-Item -Recurse $packageDestination -ErrorAction Ignore

	Exec $patch -p1 -i fontconfig.patch

	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	Exec msbuild fontconfig.sln /p:Platform=$platform /p:Configuration=Release /t:build /nodeReuse:True $windowsTargetPlatformVersion

	[void] (Swap-Environment $originalEnvironment)

	switch ($filenameArch) {
		'x86' {
			$releaseDirectory = '.\Release'
		}

		'x64' {
			$releaseDirectory = '.\x64\Release'
		}
	}

	New-Item -Type Directory $packageDestination\bin
	Copy-Item `
		$releaseDirectory\fontconfig.dll, `
		$releaseDirectory\fontconfig.pdb, `
		$releaseDirectory\fc-cache.exe, `
		$releaseDirectory\fc-cache.pdb, `
		$releaseDirectory\fc-cat.exe, `
		$releaseDirectory\fc-cat.pdb, `
		$releaseDirectory\fc-list.exe, `
		$releaseDirectory\fc-list.pdb, `
		$releaseDirectory\fc-match.exe, `
		$releaseDirectory\fc-match.pdb, `
		$releaseDirectory\fc-query.exe, `
		$releaseDirectory\fc-query.pdb, `
		$releaseDirectory\fc-scan.exe, `
		$releaseDirectory\fc-scan.pdb `
		$packageDestination\bin

	New-Item -Type Directory $packageDestination\etc\fonts
	Copy-Item `
		.\fonts.conf, `
		.\fonts.dtd `
		$packageDestination\etc\fonts

	New-Item -Type Directory $packageDestination\include\fontconfig
	Copy-Item `
		.\fontconfig\fcfreetype.h, `
		.\fontconfig\fcprivate.h, `
		.\fontconfig\fontconfig.h `
		$packageDestination\include\fontconfig

	New-Item -Type Directory $packageDestination\lib
	Copy-Item `
		$releaseDirectory\fontconfig.lib `
		$packageDestination\lib

	New-Item -Type Directory $packageDestination\share\doc\fontconfig
	Copy-Item .\COPYING $packageDestination\share\doc\fontconfig

	Package $packageDestination
}

$items['freetype'].BuildScript = {
	$packageDestination = "$PWD-$filenameArch"
	Remove-Item -Recurse $packageDestination -ErrorAction Ignore

	# Pango requires freetype.h to be in utf-8 with BOM
	$freetype_h = Get-Content .\include\freetype\freetype.h -Encoding UTF8
	Out-File .\include\freetype\freetype.h -InputObject $freetype_h -Encoding UTF8

	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	Exec msbuild builds\windows\vc2015\freetype.vcxproj /p:Platform=$platform /p:Configuration=Release /maxcpucount /nodeReuse:True $windowsTargetPlatformVersion

	[void] (Swap-Environment $originalEnvironment)

	New-Item -Type Directory $packageDestination\include
	Copy-Item -Recurse `
		.\include\* `
		$packageDestination\include

	New-Item -Type Directory $packageDestination\lib
	Copy-Item `
		".\objs\vc2015\$platform\freetype.lib" `
		$packageDestination\lib

	New-Item -Type Directory $packageDestination\share\doc\freetype
	Copy-Item .\docs\LICENSE.TXT $packageDestination\share\doc\freetype\COPYING

	Package $packageDestination
}

$items['gdk-pixbuf'].BuildScript = {
	$packageDestination = "$PWD-rel"
	Remove-Item -Recurse $packageDestination -ErrorAction Ignore

	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	Exec msbuild build\win32\vs14\gdk-pixbuf.sln /p:Platform=$platform /p:Configuration=Release_GDI+ /maxcpucount /nodeReuse:True $windowsTargetPlatformVersion

	[void] (Swap-Environment $originalEnvironment)

	New-Item -Type Directory $packageDestination\lib\pkgconfig
	Copy-Item .\gdk-pixbuf-2.0.pc $packageDestination\lib\pkgconfig

	New-Item -Type Directory $packageDestination\share\doc\gdk-pixbuf
	Copy-Item .\COPYING $packageDestination\share\doc\gdk-pixbuf

	Package $packageDestination
	$packageDestination = "$PWD-gir-rel"

	Push-Location .\build
	
	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	Exec nmake -f .\gdk-pixbuf-introspection-msvc.mak CFG=release PYTHON2=..\..\..\..\python-2.7\$platform\python.exe BASEDIR=..\..\..\..\gtk\$platform

	[void] (Swap-Environment $originalEnvironment)

	New-Item -Type Directory $packageDestination\lib\girepository-1.0
	Copy-Item .\*.typelib $packageDestination\lib\girepository-1.0

	New-Item -Type Directory $packageDestination\share\gir-1.0
	Copy-Item .\*.gir $packageDestination\share\gir-1.0
	
	Pop-Location

	Package $packageDestination
}

$items['gettext-runtime'].BuildScript = {
	$packageDestination = "$PWD-$filenameArch"
	Remove-Item -Recurse $packageDestination -ErrorAction Ignore

	Exec $patch -p1 -i gettext-runtime.patch

	Remove-Item -Recurse CMakeCache.txt, CMakeFiles -ErrorAction Ignore

	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	$env:PATH += ";$CMakePath"
	Exec cmake -G 'NMake Makefiles' "-DCMAKE_INSTALL_PREFIX=`"$packageDestination`"" -DCMAKE_BUILD_TYPE=Release "-DICONV_INCLUDE_DIR=`"$packageDestination\..\..\..\gtk\$platform\include`"" "-DICONV_LIBRARIES=`"$packageDestination\..\..\..\gtk\$platform\lib\iconv.lib`""
	Exec nmake clean
	Exec nmake
	Exec nmake install
	Exec nmake clean

	[void] (Swap-Environment $originalEnvironment)

	New-Item -Type Directory $packageDestination\share\doc\gettext
	Copy-Item .\COPYING $packageDestination\share\doc\gettext

	Package $packageDestination
}

$items['glib'].BuildScript = {
	$packageDestination = "$PWD-rel"
	Remove-Item -Recurse $packageDestination -ErrorAction Ignore
	New-Item -Type Directory $packageDestination

	Exec $patch -p1 -i glibpc-libintl.patch
	Exec $patch -p1 -i glib-if_nametoindex.patch
	Exec $patch -p1 -i glib-package-installation-directory.patch

	Get-ChildItem -Recurse *.c, *.h | %{
		Fix-C4819 $_.FullName
	}

	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	Exec msbuild build\win32\vs14\glib.sln /p:Platform=$platform /p:Configuration=Release_BundledPCRE /maxcpucount /nodeReuse:True $windowsTargetPlatformVersion

	[void] (Swap-Environment $originalEnvironment)

	New-Item -Type Directory $packageDestination\share\doc\glib
	Copy-Item .\COPYING $packageDestination\share\doc\glib

	Package $packageDestination
}

$items['gobject-introspection'].BuildScript = {
	$packageDestination = "$PWD-rel"
	Remove-Item -Recurse $packageDestination -ErrorAction Ignore
	New-Item -Type Directory $packageDestination

	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	# Avoid gi-introspect target
	Exec msbuild build\win32\vs14\gobject-introspection.sln /p:Platform=$platform /p:Configuration=Release /nodeReuse:True /target:gi-install $windowsTargetPlatformVersion

	[void] (Swap-Environment $originalEnvironment)

	New-Item -Type Directory $packageDestination\share\doc\gobject-introspection
	Copy-Item .\COPYING $packageDestination\share\doc\gobject-introspection

	Package $packageDestination

	# This process is split into two parts.
	# This is because:
	# - The project files are broken
	# - The build process outputs libraries and tools that are depended
	#   upon for the second phase, this requires properly setting up various
	#   paths which is just easier if it is already installed.

	$packageDestination = "$PWD-data-rel"
	Remove-Item -Recurse $packageDestination -ErrorAction Ignore

	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	Exec $patch -p1 -i pkg-config-env-var.patch

	$env:PREFIX = "..\..\..\..\..\gtk\$platform"
	$env:PKG_CONFIG = "..\..\..\..\..\gtk\$platform\bin\pkg-config.exe"
	$env:PYTHON = "..\..\..\..\..\python-2.7\$platform\python.exe"

	Push-Location .\build\win32

	Exec nmake -f .\gi-introspection-msvc.mak CFG=release CAIROGOBJECT_DLLNAME=cairo-gobject.dll

	[void] (Swap-Environment $originalEnvironment)

	New-Item -Type Directory $packageDestination\share\gir-1.0
	Copy-Item .\*.gir $packageDestination\share\gir-1.0

	New-Item -Type Directory $packageDestination\lib\girepository-1.0
	Copy-Item .\*.typelib $packageDestination\lib\girepository-1.0

	Pop-Location

	Package $packageDestination
}

$items['gtk'].BuildScript = {
	$packageDestination = "$PWD-rel"
	Remove-Item -Recurse $packageDestination -ErrorAction Ignore

	Exec $patch -p1 -i gtk-revert-scrolldc-commit.patch
	Exec $patch -p1 -i gtk-bgimg.patch
	Exec $patch -p1 -i gtk-accel.patch
	Exec $patch -p1 -i gtk-multimonitor.patch
	Exec $patch -p1 -i gtkstatusicon-dpichange.patch
	Exec $patch -p1 -i gdk-astral-keyevents.patch

	Fix-C4819 .\gdk\gdkkeyuni.c

	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	Exec msbuild build\win32\vs14\gtk+.sln /p:Platform=$platform /p:Configuration=Release /maxcpucount /nodeReuse:True $windowsTargetPlatformVersion

	[void] (Swap-Environment $originalEnvironment)

	$env:PATH += ";$BuildDirectory\msgfmt"

	New-Item -Type Directory $packageDestination\share\locale

	Push-Location .\po
	Get-ChildItem *.po | %{
		New-Item -Type Directory "$packageDestination\share\locale\$($_.BaseName)\LC_MESSAGES"
		Exec msgfmt -co "$packageDestination\share\locale\$($_.BaseName)\LC_MESSAGES\gtk20.mo" $_.Name
	}
	Pop-Location

	New-Item -Type Directory $packageDestination\share\doc\gtk
	Copy-Item .\COPYING $packageDestination\share\doc\gtk

	Package $packageDestination
	$packageDestination = "$PWD-gir-rel"

	Push-Location .\build
	
	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	Exec nmake -f .\gtk-introspection-msvc.mak CFG=release PYTHON2=..\..\..\..\python-2.7\$platform\python.exe BASEDIR=..\..\..\..\gtk\$platform

	[void] (Swap-Environment $originalEnvironment)

	New-Item -Type Directory $packageDestination\lib\girepository-1.0
	Copy-Item .\*.typelib $packageDestination\lib\girepository-1.0

	New-Item -Type Directory $packageDestination\share\gir-1.0
	Copy-Item .\*.gir $packageDestination\share\gir-1.0
	
	Pop-Location

	Package $packageDestination
}

$items['harfbuzz'].BuildScript = {
	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	Get-ChildItem -Recurse *.cc, *.hh | %{
		Fix-C4819 $_.FullName
	}

	Push-Location .\win32

	Exec nmake /f Makefile.vc CFG=release PYTHON=..\..\..\..\python-2.7\$platform\python.exe PERL=..\..\..\..\perl-5.20\$platform\bin\perl.exe PREFIX=`"$workingDirectory\..\..\gtk\$platform`" FREETYPE=1 GOBJECT=1
	Exec nmake /f Makefile.vc install CFG=release PREFIX=`"$workingDirectory\..\..\gtk\$platform`" FREETYPE=1 GOBJECT=1

	Pop-Location

	[void] (Swap-Environment $originalEnvironment)
}

$items['lgi'].BuildScript = {
	$packageDestination = "$PWD-rel"
	Remove-Item -Recurse $packageDestination -ErrorAction Ignore

	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	Exec $patch -p1 -i .\Fix-loading-cairo-on-Win32.patch

	Push-Location .\lgi

	Exec nmake -f .\Makefile-msvc.mak install PREFIX=..\..\..\..\gtk\$platform DESTDIR=$packageDestination

	Pop-Location

	[void] (Swap-Environment $originalEnvironment)

	Package $packageDestination
}


$items['libffi'].BuildScript = {
	$packageDestination = "$PWD-rel"
	Remove-Item -Recurse $packageDestination -ErrorAction Ignore

	Exec $patch -p1 -i libffi-msvc-complex.patch
	Exec $patch -p1 -i libffi-win64-jmp.patch

	switch ($filenameArch) {
		'x86' {
			$buildDestination = 'i686-pc-mingw32'
		}

		'x64' {
			$buildDestination = 'x86_64-w64-mingw32'
		}
	}

	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	Exec msbuild build\win32\vs12\libffi.sln /p:Platform=$platform /p:Configuration=Release /maxcpucount /nodeReuse:True $windowsTargetPlatformVersion

	[void] (Swap-Environment $originalEnvironment)

	New-Item -Type Directory $packageDestination\bin
	Copy-Item `
		.\build\win32\vs12\Release\$platform\libffi.dll `
		$packageDestination\bin

	New-Item -Type Directory $packageDestination\lib
	Copy-Item `
		.\build\win32\vs12\Release\$platform\libffi.lib `
		$packageDestination\lib

	New-Item -Type Directory $packageDestination\include
	Copy-Item `
		.\$buildDestination\include\ffi.h, `
		.\src\x86\ffitarget.h `
		$packageDestination\include

	New-Item -Type Directory $packageDestination\share\doc\libffi
	Copy-Item .\LICENSE $packageDestination\share\doc\libffi

	Package $packageDestination
}

$items['libpng'].BuildScript = {
	$packageDestination = "$PWD-$filenameArch"
	Remove-Item -Recurse $packageDestination -ErrorAction Ignore

	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	Exec msbuild projects\vc14\pnglibconf\pnglibconf.vcxproj /p:Platform=$platform /p:Configuration=Release /p:SolutionDir=$PWD\projects\vc14\ /nodeReuse:True $windowsTargetPlatformVersion
	Exec msbuild projects\vc14\libpng\libpng.vcxproj /p:Platform=$platform /p:Configuration=Release /p:SolutionDir=$PWD\projects\vc14\ /nodeReuse:True $windowsTargetPlatformVersion

	[void] (Swap-Environment $originalEnvironment)

	switch ($filenameArch) {
		'x86' {
			$releaseDirectory = '.\projects\vc14\Release'
		}

		'x64' {
			$releaseDirectory = '.\projects\vc14\x64\Release'
		}
	}

	New-Item -Type Directory $packageDestination\bin
	Copy-Item `
		$releaseDirectory\libpng16.dll, `
		$releaseDirectory\libpng16.pdb `
		$packageDestination\bin

	New-Item -Type Directory $packageDestination\include
	Copy-Item `
		.\png.h, `
		.\pngconf.h, `
		.\pnglibconf.h, `
		.\pngpriv.h `
		$packageDestination\include

	New-Item -Type Directory $packageDestination\lib
	Copy-Item `
		$releaseDirectory\libpng16.lib `
		$packageDestination\lib

	New-Item -Type Directory $packageDestination\share\doc\libpng
	Copy-Item .\LICENSE $packageDestination\share\doc\libpng\COPYING

	Package $packageDestination
}

$items['libxml2'].BuildScript = {
	$packageDestination = "$PWD-$filenameArch"
	Remove-Item -Recurse $packageDestination -ErrorAction Ignore

	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	Exec msbuild win32\VC14\libxml2.vcxproj /p:Platform=$platform /p:Configuration=Release /maxcpucount /nodeReuse:True $windowsTargetPlatformVersion

	[void] (Swap-Environment $originalEnvironment)

	New-Item -Type Directory $packageDestination\bin
	Copy-Item `
		.\lib\libxml2.dll, `
		.\lib\libxml2.pdb `
		$packageDestination\bin

	New-Item -Type Directory $packageDestination\include\libxml
	Copy-Item `
		.\win32\VC14\config.h, `
		.\include\wsockcompat.h, `
		.\include\libxml\*.h `
		$packageDestination\include\libxml

	New-Item -Type Directory $packageDestination\lib
	Copy-Item `
		.\lib\libxml2.lib `
		$packageDestination\lib

	New-Item -Type Directory $packageDestination\share\doc\libxml2
	Copy-Item .\COPYING $packageDestination\share\doc\libxml2

	Package $packageDestination
}

$items['luajit'].BuildScript = {
	$packageDestination = "$PWD-$filenameArch"
	Remove-Item -Recurse $packageDestination -ErrorAction Ignore

	Exec $patch -p1 -i .\lua-default-path.patch

	Push-Location .\src

	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	Exec .\msvcbuild

	[void] (Swap-Environment $originalEnvironment)

	New-Item -Type Directory $packageDestination\include\luajit-2.0
	Copy-Item `
		.\lua.h, `
		.\lualib.h, `
		.\luaconf.h, `
		.\lauxlib.h, `
		.\luajit.h `
		$packageDestination\include\luajit-2.0

	New-Item -Type Directory $packageDestination\bin
	Copy-Item `
		.\luajit.exe, `
		.\lua51.dll `
		$packageDestination\bin

	New-Item -Type Directory $packageDestination\lib
	Copy-Item `
		.\lua51.lib `
		$packageDestination\lib

	Pop-Location

	New-Item -Type Directory $packageDestination\share\doc\luajit
	Copy-Item .\COPYRIGHT $packageDestination\share\doc\luajit
	Package $packageDestination
}

$items['openssl'].BuildScript = {
	$packageDestination = "$PWD-$filenameArch"
	Remove-Item -Recurse $packageDestination -ErrorAction Ignore

	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	$env:PATH += ";$PerlDirectory\$platform\bin;$Msys2Directory\usr\bin"

	switch ($filenameArch) {
		'x86' {
			Exec perl Configure VC-WIN32 no-ssl2 no-ssl3 no-comp --openssldir=./
			Exec ms\do_nasm
		}

		'x64' {
			Exec perl Configure VC-WIN64A no-ssl2 no-ssl3 no-comp --openssldir=./
			Exec ms\do_win64a
		}
	}

	# nmake returns error code 2 because it fails to find build outputs to delete
	try { Exec nmake -f ms\ntdll.mak vclean } catch { }

	Exec nmake -f ms\ntdll.mak

	Exec nmake -f ms\ntdll.mak test

	Exec perl mk-ca-bundle.pl -n cert.pem
	Move-Item .\include .\include-orig

	Exec nmake -f ms\ntdll.mak install

	[void] (Swap-Environment $originalEnvironment)

	New-Item -Type Directory $packageDestination

	Move-Item .\bin $packageDestination
	Copy-Item `
		.\out32dll\libeay32.pdb, `
		.\out32dll\openssl.pdb, `
		.\out32dll\ssleay32.pdb `
		$packageDestination\bin
	Move-Item .\cert.pem $packageDestination\bin

	Move-Item .\include $packageDestination
	Move-Item .\include-orig .\include

	Move-Item .\lib $packageDestination
	Copy-Item `
		.\out32dll\4758cca.pdb, `
		.\out32dll\aep.pdb, `
		.\out32dll\atalla.pdb, `
		.\out32dll\capi.pdb, `
		.\out32dll\chil.pdb, `
		.\out32dll\cswift.pdb, `
		.\out32dll\gmp.pdb, `
		.\out32dll\gost.pdb, `
		.\out32dll\nuron.pdb, `
		.\out32dll\padlock.pdb, `
		.\out32dll\sureware.pdb, `
		.\out32dll\ubsec.pdb `
		$packageDestination\lib\engines

	New-Item -Type Directory $packageDestination\share\doc\openssl
	Move-Item .\openssl.cnf $packageDestination\share\openssl.cnf.example
	Copy-Item .\LICENSE $packageDestination\share\doc\openssl\COPYING

	Package $packageDestination
}

$items['pango'].BuildScript = {
	$packageDestination = "$PWD-rel"
	Remove-Item -Recurse $packageDestination -ErrorAction Ignore

	Exec $patch -p1 -i pango-synthesize-fonts-properly.patch
	Exec $patch -p1 -i pangocairo-fix-missing-export.patch

	Fix-C4819 .\pango\break.c
	Fix-C4819 .\pango\pango-language-sample-table.h

	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	Exec msbuild build\win32\vs14\pango.sln /p:Platform=$platform /p:Configuration=Release_FC /nodeReuse:True $windowsTargetPlatformVersion

	[void] (Swap-Environment $originalEnvironment)

	New-Item -Type Directory $packageDestination\lib\pkgconfig
	Copy-Item .\pango.pc $packageDestination\lib\pkgconfig

	New-Item -Type Directory $packageDestination\share\doc\pango
	Copy-Item .\COPYING $packageDestination\share\doc\pango

	Package $packageDestination
	$packageDestination = "$PWD-gir-rel"

	Push-Location .\build\win32
	
	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	Exec nmake -f .\pango-introspection-msvc.mak CFG=release PYTHON=..\..\..\..\..\python-2.7\$platform\python.exe PREFIX=..\..\..\..\..\gtk\$platform

	[void] (Swap-Environment $originalEnvironment)

	New-Item -Type Directory $packageDestination\lib\girepository-1.0
	Copy-Item .\*.typelib $packageDestination\lib\girepository-1.0

	New-Item -Type Directory $packageDestination\share\gir-1.0
	Copy-Item .\*.gir $packageDestination\share\gir-1.0
	
	Pop-Location

	Package $packageDestination
}

$items['pixman']['BuildScript'] = {
	$packageDestination = "$PWD-rel"
	Remove-Item -Recurse $packageDestination -ErrorAction Ignore

	$exports = Get-ChildItem -Recurse *.c, *.h | Select-String -Pattern 'PIXMAN_EXPORT' -Encoding UTF8 | %{
		$content = Get-Content -Encoding UTF8 $_.Path
		"$($content[$_.LineNumber - 1]) $($content[$_.LineNumber])"
	} | ?{
		$_ -like 'PIXMAN_EXPORT *'
	} | %{
		if ($_ -match 'PIXMAN_EXPORT (?:const )?\S+ (?:\* )?(PREFIX(?: ?)\()?([^\s\(\)]+)') {
			if ($Matches[1] -eq $null) {
				$Matches[2]
			}
			else {
				"pixman_region$($Matches[2])"
				"pixman_region32$($Matches[2])"
			}
		}
	} | ? {
		-not ($_ -like '_pixman*')
	}

	$exports += 'prng_srand_r'
	$exports += 'prng_randmemset_r'

	$exports | Sort-Object -Unique | Out-File -Encoding OEM .\pixman\pixman.symbols

	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	Exec msbuild build\win32\vc14\pixman.vcxproj /p:Platform=$platform /p:Configuration=Release /p:SolutionDir=$PWD\build\win32\vc14\ /maxcpucount /nodeReuse:True $windowsTargetPlatformVersion
	Exec msbuild build\win32\vc14\install.vcxproj /p:Platform=$platform /p:Configuration=Release /p:SolutionDir=$PWD\build\win32\vc14\ /maxcpucount /nodeReuse:True $windowsTargetPlatformVersion

	[void] (Swap-Environment $originalEnvironment)

	New-Item -Type Directory $packageDestination\share\doc\pixman
	Copy-Item .\COPYING $packageDestination\share\doc\pixman

	Package $packageDestination
}

$items['pkg-config'].BuildScript = {
	$packageDestination = "$PWD-rel"
	Remove-Item -Recurse $packageDestination -ErrorAction Ignore

	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	Exec nmake /f Makefile.vc CFG=release GLIB_PREFIX=..\..\..\gtk\$platform

	[void] (Swap-Environment $originalEnvironment)

	New-Item -Type Directory $packageDestination\bin
	Copy-Item `
		.\release\$platform\pkg-config.exe `
		$packageDestination\bin

	New-Item -Type Directory $packageDestination\share\doc\pkg-config
	Copy-Item .\COPYING $packageDestination\share\doc\pkg-config

	Package $packageDestination
}


$items['win-iconv'].BuildScript = {
	$packageDestination = "$PWD-$filenameArch"
	Remove-Item -Recurse $packageDestination -ErrorAction Ignore

	Remove-Item -Recurse CMakeCache.txt, CMakeFiles -ErrorAction Ignore

	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	$env:PATH += ";$CMakePath"

	Exec cmake -G 'NMake Makefiles' "-DCMAKE_INSTALL_PREFIX=`"$packageDestination`"" -DCMAKE_BUILD_TYPE=Release
	Exec nmake clean
	Exec nmake
	Exec nmake install
	Exec nmake clean

	[void] (Swap-Environment $originalEnvironment)

	New-Item -Type Directory $packageDestination\share\doc\win-iconv
	Copy-Item .\COPYING $packageDestination\share\doc\win-iconv

	Package $packageDestination
}

$items['zlib'].BuildScript = {
	$packageDestination = "$PWD-$filenameArch"
	Remove-Item -Recurse $packageDestination -ErrorAction Ignore

	$originalEnvironment = Swap-Environment $vcvarsEnvironment

	Exec msbuild contrib\vstudio\vc12\zlibvc.sln /p:Platform=$platform /p:Configuration=ReleaseWithoutAsm /maxcpucount /nodeReuse:True $windowsTargetPlatformVersion

	[void] (Swap-Environment $originalEnvironment)

	New-Item -Type Directory $packageDestination\include
	Copy-Item zlib.h, zconf.h $packageDestination\include

	Push-Location ".\contrib\vstudio\vc12\$filenameArch"

	New-Item -Type Directory $packageDestination\bin
	Copy-Item `
		.\TestZlibDllRelease\testzlibdll.exe, `
		.\TestZlibDllRelease\testzlibdll.pdb, `
		.\TestZlibReleaseWithoutAsm\testzlib.exe, `
		.\TestZlibReleaseWithoutAsm\testzlib.pdb, `
		.\ZlibDllReleaseWithoutAsm\zlib1.dll, `
		.\ZlibDllReleaseWithoutAsm\zlib1.map, `
		.\ZlibDllReleaseWithoutAsm\zlib1.pdb `
		$packageDestination\bin

	New-Item -Type Directory $packageDestination\lib
	Copy-Item `
		.\ZlibDllReleaseWithoutAsm\zlib1.lib, `
		.\ZlibStatReleaseWithoutAsm\zlibstat.lib `
		$packageDestination\lib

	Pop-Location

	New-Item -Type Directory $packageDestination\share\doc\zlib
	Copy-Item .\README $packageDestination\share\doc\zlib

	Package $packageDestination
}

#========================================================================================================================================================
# Build steps end here
#========================================================================================================================================================


$patch = "$Msys2Directory\usr\bin\patch.exe"
if (-not $(Test-Path $patch)) {
	throw "$patch not found. Please check that you installed patch in msys2 using ``pacman -S patch``"
}

$tar = "$Msys2Directory\usr\bin\tar.exe"
if (-not $(Test-Path $tar)) {
	throw "$tar not found. Please check that you installed tar and other unzipping tools in msys2 using ``pacman -S gzip tar xz``"
}


# Verify VS exists at the indicated location, and that it supports the required target
if (Test-Path "$VSInstallPath\vcbuildtools.bat") {
	$vcvarsBat = "`"$VSInstallPath\vcbuildtools.bat`" "

	switch ($Configuration) {
		'x86' {
			$vcvarsBat += 'x86'
		}

		'x64' {
			$vcvarsBat += 'amd64'
		}
	}
}
else {
	switch ($Configuration) {
		'x86' {
			$vcvarsBat = "$VSInstallPath\VC\bin\vcvars32.bat"
		}

		'x64' {
			$vcvarsBat = "$VSInstallPath\VC\bin\amd64\vcvars64.bat"

			# make sure it works even with VS Community / VC++ Build Tools
			if (-not $(Test-Path $vcvarsBat)) {
				$vcvarsBat = "$VSInstallPath\VC\bin\x86_amd64\vcvarsx86_amd64.bat"
			}
		}
	}

	if (-not $(Test-Path $vcvarsBat)) {
		throw "`"$vcvarsBat`" could not be found. Please check you have Visual Studio installed at `"$VSInstallPath`" and that it supports the configuration `"$Configuration`"."
	}

	$vcvarsBat = "`"$vcvarsBat`""
}

$vcvarsEnvironment = @{}
$(&cmd /C "$vcvarsBat > NUL && SET") | %{
	$keyValuePair = $_.Split('=', 2)
	$vcvarsEnvironment[$keyValuePair[0]] = $keyValuePair[1]
}

switch ($Configuration) {
	'x86' {
		$platform = 'Win32'
		$filenameArch = 'x86'
	}

	'x64' {
		$platform = 'x64'
		$filenameArch = 'x64'
	}
}

$workingDirectory = "$BuildDirectory\build\$platform"


if ($TargetSDK -eq '') {
	$windowsTargetPlatformVersion = $null
}
else {
	$windowsTargetPlatformVersion = "/p:WindowsTargetPlatformVersion=$TargetSDK"
}


# Set up additional properties on the items
$items.GetEnumerator() | %{
	$name = $_.Key
	$item = $_.Value

	$archiveUrl = $item.ArchiveUrl

	$filename = New-Object System.Uri $archiveUrl
	$filename = $filename.Segments[$filename.Segments.Length - 1]

	$item = $items[$name]

	$item.Name = $name
	$item.ArchiveFile = New-Object System.IO.FileInfo "$ArchivesDownloadDirectory\$filename"
	$item.PatchDirectory = $(New-Object System.IO.DirectoryInfo "$PatchesRootDirectory\$name")
	$item.BuildDirectory = New-Object System.IO.DirectoryInfo "$workingDirectory\$name"
	$item.Dependencies = @($item.Dependencies | %{ $items[$_] })
	$item.Dependents = @()
	$item.State = ''
}

$items.GetEnumerator() | %{
	$item = $_.Value

	$item.Dependencies | %{ $items[$_.Name].Dependents += $item }
}


# If OnlyBuild is not an empty array, only keep the items that are specified
if ($OnlyBuild.Length -gt 0) {
	$newItems = @{}

	$queue = New-Object System.Collections.Generic.Queue[string] (, $OnlyBuild)

	while ($queue.Count -gt 0) {
		$itemName = $queue.Dequeue()
		$item = $items[$itemName]

		$newItems[$itemName] = $item

		$item.Dependencies | %{
			if ($newItems[$_.Name] -eq $null) {
				$queue.Enqueue($_.Name)
			}
		}
	}

	$items = $newItems
}


New-Item -Type Directory $ArchivesDownloadDirectory -ErrorAction Ignore


New-Item -Type Directory $workingDirectory -ErrorAction Ignore
Copy-Item $PatchesRootDirectory\stack.props $workingDirectory


$logDirectory = "$workingDirectory\logs"
New-Item -Type Directory $logDirectory -ErrorAction Ignore
Remove-Item $logDirectory\*.log


New-Item -Type Directory $workingDirectory\..\..\gtk\$platform -ErrorAction Ignore


# For each item, start a job to download the source archives, extract them to $workingDirectory, and copy over the stuff from gtk-win32
Write-Host "Downloading and extracting source archives to $workingDirectory"

$items.GetEnumerator() | %{
	$item = $_.Value

	$item.State = 'Downloading and extracting'

	[void] (Start-Job -Name $item.Name -InitializationScript {
		function Exec {
			$name, $arguments = @($args)
			$arguments = @($arguments | ?{ $_ -ne $null })
			&$name @arguments
			[void] ($LASTEXITCODE -and $(throw "$name $arguments exited with code $LASTEXITCODE"))
		}

		function ConvertTo-Msys2Path ([string] $Path) {
			([regex] '^([a-zA-Z]):').Replace(($Path -replace '\\', '/'), { "/$($args[0].Groups[1].Value.ToLower())" })
		}
	} -ArgumentList $item {
		param ($item)

		$ArchivesDownloadDirectory = $using:ArchivesDownloadDirectory
		$Msys2Directory = $using:Msys2Directory
		$tar = $using:tar
		$workingDirectory = $using:workingDirectory

		'Beginning job to download and extract'

		# BaseName, etc. properties of FileInfo properties are available on the PSObject. Convert it back to a FileInfo.
		$item.ArchiveFile = New-Object System.IO.FileInfo $item.ArchiveFile

		if ($item.ArchiveFile.Exists) {
			"$($item.ArchiveFile) already exists"
		}
		else {
			"$($item.ArchiveFile) doesn't exist. Downloading..."

			$ProgressPreference = 'SilentlyContinue'
			Invoke-WebRequest $item.ArchiveUrl -OutFile $item.ArchiveFile
			$ProgressPreference = 'Continue'

			"Downloaded $($item.ArchiveUrl)"
		}

		"Extracting $($item.ArchiveFile.Name) to $workingDirectory"

		$env:PATH += ";$Msys2Directory\usr\bin"

		if ($item.Name -ne 'gettext-runtime') {
			Exec $tar xf $(ConvertTo-Msys2Path $item.ArchiveFile) -C $(ConvertTo-Msys2Path $workingDirectory)

			$outputDirectoryName = [System.IO.Path]::GetFilenameWithoutExtension($item.ArchiveFile.BaseName)

			while ($true) {
				try {
					Copy-Item "$workingDirectory\$outputDirectoryName" $item.BuildDirectory -Recurse -ErrorAction Stop
					break
				}
				catch {
					Remove-Item -Recurse -Force $item.BuildDirectory -ErrorAction Ignore
					Sleep 1
				}
			}

			Remove-Item -Recurse -Force "$workingDirectory\$outputDirectoryName"
		}
		else {
			# gettext-runtime is a tarbomb
			[void] (New-Item -Type Directory $item.BuildDirectory)
			Exec $tar xf $(ConvertTo-Msys2Path $item.ArchiveFile) -C $(ConvertTo-Msys2Path $item.BuildDirectory)
		}

		"Extracted $($item.ArchiveFile.Name)"

		if (Test-Path $item.PatchDirectory) {
			Copy-Item "$($item.PatchDirectory)\*" $item.BuildDirectory -Recurse -Force
			"Copied patch contents from $($item.PatchDirectory) to $($item.BuildDirectory)"
		}
		else {
			"Skipped copying patches, $($item.PatchDirectory) does not exist."
		}

		Push-Location $item.BuildDirectory
		Get-ChildItem -Recurse *.vcxproj | %{
			$contents = Get-Content $_.FullName
			$contents = $contents -replace '<PlatformToolset>v120</PlatformToolset>', '<PlatformToolset>v140</PlatformToolset>' -replace '<GenerateDebugInformation>true</GenerateDebugInformation>', '<GenerateDebugInformation>Debug</GenerateDebugInformation>'
			$contents | Out-File -LiteralPath $_.FullName -Encoding utf8
		}
		Pop-Location
	})
}

# While the jobs are running...
do {
	# Log their output
	Get-Job | %{
		$job = $_

		@(Receive-Job $job 2>&1) | %{
			if ($_ -isnot [System.Management.Automation.ErrorRecord]) {
				Write-Host "$($job.Name) : $_"
			}
			else {
				$Host.UI.WriteErrorLine("$($job.Name) : $($_.Exception.Message)")
			}
		}

		if (($job.State -eq 'Completed') -and (-not $job.HasMoreData)) {
			$items[$job.Name].State = 'Pending'

			Remove-Job $job
		}
		elseif (($job.State -eq 'Failed') -and (-not $job.HasMoreData)) {
			Write-Host "$($job.Name) : Failed"

			$items[$job.Name].State = 'Failed'

			Remove-Job $job
		}
	}

	# Sleep a bit and then try again
	Start-Sleep 1
} while (@(Get-Job).Length -gt 0)

if (@($items.GetEnumerator() | ?{ $_.Value.State -eq 'Failed' }).Length -gt 0) {
	Write-Error 'One or more source archives could not be downloaded or extracted.'
	exit 1
}

Write-Host 'Downloaded and extracted all source archives.'


# Until all items have been built
while (@($items.GetEnumerator() | ?{ ($_.Value.State -eq 'Pending') -or ($_.Value.State -eq 'Building') }).Length -gt 0) {
	# If another job can be started - either parallel build is enabled, or it's disabled and there is no running build job), and there are no failed jobs...
	if (
		(-not $DisableParallelBuild -or $(Get-Job) -eq $null) -and
		(@($items.GetEnumerator() | ?{ $_.Value.State -eq 'Failed' }).Length -eq 0)
	) {
		# Find an item which hasn't already been built, isn't being built currently, and whose dependencies have all been built
		$nextPendingItem =
			@($items.GetEnumerator() | ?{
				$item = $_.Value

				if ($item.State -ne 'Pending') {
					return $false
				}

				$remainingDependencies = @($item.Dependencies | ?{ $items[$_.Name].State -ne 'Completed' })
				return $remainingDependencies.Length -eq 0
			} | %{ $_.Value })[0]

		# If such an item exists...
		if ($nextPendingItem -ne $null) {
			$nextPendingItem.State = 'Building'

			Out-File -Append -Encoding OEM -FilePath "$logDirectory\build.log" -InputObject "$($nextPendingItem.Name) : Started"
			Write-Host "$($nextPendingItem.Name) : Started"

			# Start a job to build it
			[void] (Start-Job -Name $nextPendingItem.Name -InitializationScript {
				function Swap-Environment([HashTable] $newEnvironment) {
					$originalEnvironment = @{}

					Get-ChildItem Env: | %{ $originalEnvironment[$_.Name] = $_.Value }

					$originalEnvironment.GetEnumerator() | %{ Remove-Item "env:$($_.Key)" }

					$newEnvironment.GetEnumerator() | %{ [System.Environment]::SetEnvironmentVariable($_.Key, $_.Value) }

					return $originalEnvironment
				}

				function Exec {
					$name, $arguments = @($args)
					$arguments = @($arguments | ?{ $_ -ne $null })
					&$name @arguments
					[void] ($LASTEXITCODE -and $(throw "$name $arguments exited with code $LASTEXITCODE"))
				}

				# Add utf-8 BOM and execution charset pragma to the given file because cl.exe throws C4819 otherwise
				function Fix-C4819([string] $filename) {
					$contents = Get-Content $filename -Encoding UTF8
					$contents = @('#pragma execution_character_set("utf-8")', '') + $contents
					Out-File $filename -InputObject $contents -Encoding UTF8
				}

				function Package([string] $directory) {
					Copy-Item -Recurse -Force $directory\* $workingDirectory\..\..\gtk\$platform

					Remove-Item -Recurse $directory
				}
			} -ArgumentList $nextPendingItem {
				param ($item)

				$BuildDirectory = $using:BuildDirectory
				$CMakePath = $using:CMakePath
				$Configuration = $using:Configuration
				$filenameArch = $using:filenameArch
				$windowsTargetPlatformVersion = $using:windowsTargetPlatformVersion
				$Msys2Directory = $using:Msys2Directory
				$patch = $using:patch
				$PerlDirectory = $using:PerlDirectory
				$platform = $using:platform
				$vcvarsEnvironment = $using:vcvarsEnvironment
				$VSInstallPath = $using:VSInstallPath
				$workingDirectory = $using:workingDirectory

				Set-Location $item.BuildDirectory

				Invoke-Command ([ScriptBlock] [ScriptBlock]::Create($item.BuildScript))
			})
		}
	}

	# For each job...
	Get-Job | %{
		$job = $_

		# Log all its output
		@(Receive-Job $job 2>&1) | %{
			if ($_ -isnot [System.Management.Automation.ErrorRecord]) {
				Write-Host "$($job.Name) : $_"
			}
			else {
				$Host.UI.WriteErrorLine("$($job.Name) : $($_.Exception.Message)")
			}

			Out-File -Append -Encoding OEM -FilePath "$logDirectory\$($job.Name).log" -InputObject $_
		}

		# If the job has been completed...
		if (($job.State -eq 'Completed') -and (-not $job.HasMoreData)) {
			$items[$job.Name].State = 'Completed'

			Write-Host "$($job.Name) : Completed"
			Out-File -Append -Encoding OEM -FilePath "$logDirectory\build.log" -InputObject "$($job.Name) : Completed"

			# Delete the job
			Remove-Job $job
		}

		elseif (($job.State -eq 'Failed') -and (-not $job.HasMoreData)) {
			$items[$job.Name].State = 'Failed'

			$items.GetEnumerator() | %{
				$item = $_.Value

				if ($item.State -eq 'Pending') {
					$item.State = 'Cancelled'
				}
			}

			Write-Host "$($job.Name) : Failed"
			Out-File -Append -Encoding OEM -FilePath "$logDirectory\build.log" -InputObject "$($job.Name) : Failed"

			# Delete the job
			Remove-Job $job
		}
	}

	# Sleep a bit and then try again
	Start-Sleep 1
}

$itemStateGroups = @{}
$items.GetEnumerator() | %{ $_.Value } | Group-Object -Property { $_.State } | %{ $itemStateGroups[$_.Name] = $_.Group | Sort-Object -Property { $_.Name } }

if ($itemStateGroups.Completed.Length -gt 0) {
	Write-Host ''
	Write-Host 'The following items were successfully built:'

	$itemStateGroups.Completed | %{ Write-Host $_.Name }
}

if ($itemStateGroups.Failed.Length -gt 0) {
	Write-Host ''
	Write-Host 'The following items failed to build:'

	$itemStateGroups.Failed | %{ Write-Host $_.Name }
}

if ($itemStateGroups.Cancelled.Length -gt 0) {
	Write-Host ''
	Write-Host 'The following items were not built because one or more of the other items failed to build:'

	$itemStateGroups.Cancelled | %{ Write-Host $_.Name }
}

if ($itemStateGroups.Failed.Length -gt 0) {
	exit 1
}
