---
layout: default
title: main page
---

## About

This page is intended to guide you through the process of building the whole GTK+ stack (and some additional libraries required by HexChat) on Windows using Visual C++ a.k.a. MSVC, version 11 that comes with Visual Studio 2012. It is largely based on Chun-wei Fan's [Compiling the GTK+ stack using Visual C++](https://live.gnome.org/GTK%2B/Win32/MSVCCompilationOfGTKStack). Thanks!

You can also skip the building process and right off just **download** and use the Visual C++ builds of GTK+ so that you don't have to spend **a lot** of time on getting it to work like we had. So without further ado:

## GTK+ Visual C++ Builds:

This is the redistributable and a bundle of all the GTK+ stuff. **This is most likely what you need**.

<table>

<tr>
<td>Microsoft Visual C++ Redistributable Package</td>
<td>2012 Update 1</td>
<td><a href="http://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU1/vcredist_x86.exe">32 bit</a></td>
<td><a href="http://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU1/vcredist_x64.exe">64 bit</a></td>
</tr>

<tr class="even">
<td>GTK+ bundle</td>
<td>2.24.17</td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x86/gtk-x86.7z">32 bit</a></td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x64/gtk-x64.7z">64 bit</a></td>
</tr>

</table>

These are the separate packages for advanced users. These also require the redistributable to be installed.

<table>

<tr>
<td>zlib</td>
<td class="current">1.2.7</td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x86/zlib-1.2.7-x86.7z">32 bit</a></td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x64/zlib-1.2.7-x64.7z">64 bit</a></td>
</tr>

<tr class="even">
<td>win-iconv</td>
<td class="current">0.0.6</td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x86/win-iconv-0.0.6-x86.7z">32 bit</a></td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x64/win-iconv-0.0.6-x64.7z">64 bit</a></td>
</tr>

<tr>
<td>FreeType</td>
<td class="current">2.4.11</td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x86/freetype-2.4.11-x86.7z">32 bit</a></td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x64/freetype-2.4.11-x64.7z">64 bit</a></td>
</tr>

<tr class="even">
<td>libffi</td>
<td class="current">3.0.13</td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x86/libffi-3.0.13-x86.7z">32 bit</a></td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x64/libffi-3.0.13-x64.7z">64 bit</a></td>
</tr>

<tr>
<td>libxml2</td>
<td class="current">2.9.0</td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x86/libxml2-2.9.0-x86.7z">32 bit</a></td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x64/libxml2-2.9.0-x64.7z">64 bit</a></td>
</tr>

<tr class="even">
<td>gettext-runtime</td>
<td class="current">0.18</td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x86/gettext-runtime-0.18-x86.7z">32 bit</a></td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x64/gettext-runtime-0.18-x64.7z">64 bit</a></td>
</tr>

<tr>
<td>OpenSSL</td>
<td class="current">1.0.1e</td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x86/openssl-1.0.1e-x86.7z">32 bit</a></td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x64/openssl-1.0.1e-x64.7z">64 bit</a></td>
</tr>

<tr class="even">
<td>libpng</td>
<td class="current">1.6.1</td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x86/libpng-1.6.1-x86.7z">32 bit</a></td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x64/libpng-1.6.1-x64.7z">64 bit</a></td>
</tr>

<tr>
<td>Fontconfig</td>
<td class="outdated">2.8.0</td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x86/fontconfig-2.8.0-x86.7z">32 bit</a></td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x64/fontconfig-2.8.0-x64.7z">64 bit</a></td>
</tr>

<tr class="even">
<td>Pixman</td>
<td class="current">0.28.2</td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x86/pixman-0.28.2-x86.7z">32 bit</a></td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x64/pixman-0.28.2-x64.7z">64 bit</a></td>
</tr>

<tr>
<td>GLib</td>
<td class="current">2.36.0</td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x86/glib-2.36.0-x86.7z">32 bit</a></td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x64/glib-2.36.0-x64.7z">64 bit</a></td>
</tr>

<tr class="even">
<td>HarfBuzz</td>
<td class="current">0.9.15</td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x86/harfbuzz-0.9.15-x86.7z">32 bit</a></td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x64/harfbuzz-0.9.15-x64.7z">64 bit</a></td>
</tr>

<tr>
<td>Enchant</td>
<td class="current">1.6.0</td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x86/enchant-1.6.0-x86.7z">32 bit</a></td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x64/enchant-1.6.0-x64.7z">64 bit</a></td>
</tr>

<tr class="even">
<td>ATK</td>
<td class="current">2.8.0</td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x86/atk-2.8.0-x86.7z">32 bit</a></td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x64/atk-2.8.0-x64.7z">64 bit</a></td>
</tr>

<tr>
<td>GDK-PixBuf</td>
<td class="current">2.28.0</td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x86/gdk-pixbuf-2.28.0-x86.7z">32 bit</a></td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x64/gdk-pixbuf-2.28.0-x64.7z">64 bit</a></td>
</tr>

<tr class="even">
<td>cairo</td>
<td class="current">1.12.14</td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x86/cairo-1.12.14-x86.7z">32 bit</a></td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x64/cairo-1.12.14-x64.7z">64 bit</a></td>
</tr>

<tr>
<td>Pango</td>
<td class="outdated">1.32.5</td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x86/pango-1.32.5-x86.7z">32 bit</a></td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x64/pango-1.32.5-x64.7z">64 bit</a></td>
</tr>

<tr class="even">
<td>GTK+</td>
<td class="current">2.24.17</td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x86/gtk-2.24.17-x86.7z">32 bit</a></td>
<td><a href="http://dl.hexchat.org/gtk-win32/vc11/x64/gtk-2.24.17-x64.7z">64 bit</a></td>
</tr>

</table>

## Building from Source

Building GTK+ and its dependencies on Windows has never been easier. We have a PowerShell script which does most of the work for you, so you just have to wait until it finishes. But first of all, here's the dependency graph of the GTK+ stack.

<img src="images/dependency-graph.png" alt="gtk dependency graph" />

To compile all this yourself, you need to install:

 * [Visual Studio 2012 Express for Windows Desktop](http://www.microsoft.com/visualstudio/eng/downloads#d-express-windows-desktop) + [Visual Studio 2012 Update 2](http://www.microsoft.com/en-us/download/details.aspx?id=38188)
 * [CMake 2.8](http://www.cmake.org/cmake/resources/software.html)
 * [MozillaBuild](http://ftp.mozilla.org/pub/mozilla.org/mozilla/libraries/win32/)
 * Perl 5.18 [x86](http://dl.hexchat.org/misc/perl/perl-5.17.10-x86.7z) or [x64](http://dl.hexchat.org/misc/perl/perl-5.17.10-x64.7z) (extract to _C:\mozilla-build\perl-5.18\Win32_ or _C:\mozilla-build\perl-5.18\x64_)
 * [NASM](http://www.nasm.us/pub/nasm/releasebuilds/?C=M;O=D) (extract to _C:\mozilla-build\nasm_)
 * [msgfmt](http://dl.hexchat.org/gtk-win32/msgfmt-0.18.1.7z) (extract to _c:\mozilla-build_)
 * [Ragel](http://dl.hexchat.org/gtk-win32/ragel-6.8.7z) (extract to _c:\mozilla-build_)
 * [7-Zip](http://www.7-zip.org/download.html) (install to _C:\Program Files\7-Zip_; do not use the 7z.exe bundled with mozilla-build)

When you're done installing these, you also have to clone 2 repos from GitHub.

 * [GTK-Win32](https://github.com/hexchat/gtk-win32) to _c:\mozilla-build\hexchat\github\gtk-win32_
 * [HexChat](https://github.com/hexchat/hexchat) to _c:\mozilla-build\hexchat\github\hexchat_

You can use other paths, but then make sure you update the related properties in _gtk-win32\hexchat-build.ps1_ and _hexchat\win32\hexchat.props_.

Now you have to allow PowerShell scripts to be ran on your system. Open a PowerShell prompt *as Administrator* and run the following command:

<pre>Set-ExecutionPolicy RemoteSigned</pre>

Once done, close this elevated shell, and run PowerShell as a regular user. Go to the _gtk-win32_ repo root and start building with the script:

<pre>cd c:\mozilla-build\hexchat\github\gtk-win32
.\hexchat-build.ps1 -Architecture x86</pre>

There are many more options, open _hexchat-build.ps1_ with an editor for more info. Once ready, your GTK+ stack will be found under
_c:\mozilla-build\hexchat\gtk_ and your HexChat installer under _c:\mozilla-build\hexchat\github\hexchat-build_. Enjoy!
