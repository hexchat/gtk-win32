Here you can download a GTK+ 2 bundle (and a few additional libraries) built with Visual Studio 2015. HexChat for Windows is built using this bundle.


## GTK+ Bundle

This is the bundle built by us containing all the GTK+ binaries, headers and import libraries. If you just want to use GTK+ for your application and don't want to build it yourself, download this. You will also need the Visual C++ redistributable to be able to run applications that use this bundle.


<table>
    <tr>
        <td>GTK+ bundle</td>
        <td><a href="https://dl.hexchat.net/gtk-win32/vc14/x86/gtk-Win32.7z">32-bit</a></td>
        <td><a href="https://dl.hexchat.net/gtk-win32/vc14/x64/gtk-x64.7z">64-bit</a></td>
    </tr>
    <tr>
        <td><a href="https://www.microsoft.com/en-us/download/details.aspx?id=48145">Microsoft Visual C++ Redistributable Package for Visual Studio 2015</a></td>
        <td>vcredist_x86.exe - 32-bit</a></td>
        <td>vcredist_x64.exe - 64-bit</a></td>
    </tr>
</table>

These are the libraries in the bundle:

| Library                | Version        | Source
| ---------------------- | -------------- | ------
| ATK                    | 2.20.0         | [Source](https://dl.hexchat.net/gtk-win32/src/atk-2.20.0.tar.xz)
| Cairo                  | 1.14.6         | [Source](https://dl.hexchat.net/gtk-win32/src/cairo-1.14.6.tar.xz)
| Enchant                | 1.6.1          | [Source](https://dl.hexchat.net/gtk-win32/src/enchant-1.6.1.tar.xz)
| Fontconfig             | 2.8.0          | [Source](https://dl.hexchat.net/gtk-win32/src/fontconfig-2.8.0.tar.gz)
| FreeType               | 2.6.5          | [Source](https://dl.hexchat.net/gtk-win32/src/freetype-2.6.5.tar.bz2)
| GDK-PixBuf             | 2.34.0         | [Source](https://dl.hexchat.net/gtk-win32/src/gdk-pixbuf-2.34.0.tar.xz)
| gettext-runtime        | 0.18           | [Source](https://dl.hexchat.net/gtk-win32/src/gettext-vc100-0.18-src.tar.bz2)
| GLib                   | 2.48.1         | [Source](https://dl.hexchat.net/gtk-win32/src/glib-2.48.1.tar.xz)
| GObject-Introspection  | 1.48.0         | [Source](https://dl.hexchat.net/gtk-win32/src/gobject-introspection-1.48.0.tar.xz)
| GTK+                   | 2.24.30        | [Source](https://dl.hexchat.net/gtk-win32/src/gtk+-2.24.30.tar.xz)
| HarfBuzz               | 1.2.7          | [Source](https://dl.hexchat.net/gtk-win32/src/harfbuzz-1.2.7.tar.bz2)
| lgi                    | 0.9.1          | [Source](https://dl.hexchat.net/gtk-win32/src/lgi-0.9.1.tar.gz)
| libffi                 | 3.2.1          | [Source](https://dl.hexchat.net/gtk-win32/src/libffi-3.2.1.tar.gz)
| libpng                 | 1.6.22         | [Source](https://dl.hexchat.net/gtk-win32/src/libpng-1.6.22.tar.xz)
| libxml2                | 2.9.4          | [Source](https://dl.hexchat.net/gtk-win32/src/libxml2-2.9.4.tar.gz)
| luajit                 | 2.0.4          | [Source](https://dl.hexchat.net/gtk-win32/src/luajit-2.0.4.tar.gz)
| OpenSSL                | 1.0.2h         | [Source](https://dl.hexchat.net/gtk-win32/src/openssl-1.0.2h.tar.gz)
| Pango                  | 1.40.1         | [Source](https://dl.hexchat.net/gtk-win32/src/pango-1.40.1.tar.xz)
| Pixman                 | 0.34.0         | [Source](https://dl.hexchat.net/gtk-win32/src/pixman-0.34.0.tar.gz)
| win-iconv              | 0.0.8          | [Source](https://dl.hexchat.net/gtk-win32/src/win-iconv-0.0.8.tar.gz)
| zlib                   | 1.2.8          | [Source](https://dl.hexchat.net/gtk-win32/src/zlib-1.2.8.tar.xz)

## Building from Source

If you want to build the bundle from source yourself, we have a PowerShell script that will download the sources, apply some patches and run the build. It is largely based on Fan Chun-wei's [Compiling the GTK+ (and Clutter) stack using Visual C++ 2008 and later](https://wiki.gnome.org/action/show/Projects/GTK+/Win32/MSVCCompilationOfGTKStack).

1. Install the following build tools and dependencies:

    * [Visual Studio 2015 Community](http://www.visualstudio.com/downloads/download-visual-studio-vs) or [Visual C++ Build Tools 2015](http://go.microsoft.com/fwlink/?LinkId=691126) - Any version of VS apart from 2015 is not supported.
    * [Visual C++ Redistributable Packages for VS 2012 Update 4](https://www.microsoft.com/en-us/download/details.aspx?id=30679)
    * [Visual C++ Redistributable Packages for VS 2013](https://www.microsoft.com/en-us/download/details.aspx?id=40784)
    * [Windows Management Framework 4.0](https://www.microsoft.com/en-us/download/details.aspx?id=40855) - Not needed for Windows 8.1 and above
    * [CMake 3.5.2](https://cmake.org/download/)
    * [msys2](https://msys2.github.io/)
    * [Python 2.7](https://www.python.org/downloads/windows/) (install to _C:\gtk-build\python-2.7\Win32_ or _C:\gtk-build\python-2.7\x64_)

1. Follow the instructions on the msys2 page to update the core packages.

1. Install needed packages in the msys2 shell

    ```bash
    pacman -S gzip nasm patch tar xz
    ```

1. Install the following build tools and dependencies:

    * Perl 5.20 [x86](https://dl.hexchat.net/misc/perl/perl-5.20.0-x86.tar.xz) or [x64](https://dl.hexchat.net/misc/perl/perl-5.20.0-x64.tar.xz) (extract to _C:\gtk-build\perl-5.20_ so you have _C:\gtk-build\perl-5.20\Win32\bin\perl.exe_ or _C:\gtk-build\perl-5.20\x64\bin\perl.exe_)
    * [msgfmt](https://dl.hexchat.net/gtk-win32/msgfmt-0.18.1.tar.xz) (extract to _C:\gtk-build_ so you have _C:\gtk-build\msgfmt\msgfmt.exe_)

	Extract the files with 7-zip, or in the MSYS2 shell with the `tar` command, eg `tar xf perl-5.20.0-x86.tar.xz`

1. Clone [this repository](https://github.com/hexchat/gtk-win32) to _C:\gtk-build\github\gtk-win32_ It contains the build script, project files and patches.

1. Now you have to allow PowerShell scripts to be run on your system. Open a PowerShell prompt **as Administrator** and run the following command:

    ```powershell
    Set-ExecutionPolicy RemoteSigned
    ```

1. Now start a new PowerShell window as a regular user. Go to the _gtk-win32_ directory and start building with the script. For example, to build the 32-bit bundle, run:

    ```powershell
    C:\gtk-build\github\gtk-win32\build.ps1
    ```

    To build the 64-bit bundle instead, run:

    ```powershell
    C:\gtk-build\github\gtk-win32\build.ps1 -Configuration x64
    ```

    The script has some parameters you can pass in. Run

    ```powershell
    Get-Help -Full C:\gtk-build\github\gtk-win32\build.ps1
    ```

    to see the help for the parameters and examples.

1. When the script is done, your GTK+ stack will be found under _C:\gtk-build\gtk_. Enjoy!

![GTK+ 2 dependency graph](https://hexchat.github.io/gtk-win32/img/dependency-graph.png)
