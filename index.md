---
layout: default
title: main page
---
This page is intended to guide you through the process of building the whole GTK+ stack (and some additional libraries required by HexChat) on Windows using Visual C++ a.k.a. MSVC, version 10 that comes with Visual Studio 2010.

More importantly, you can also skip the building process and right off just **download** and use the Visual C++ builds of GTK+ so that you don't have to <del>waste</del>spend weeks (months?) on getting it to work like I had. So without further ado:

## GTK+ Visual C++ Builds:

<table>

<tr>
<td>Microsoft Visual C++ Redistributable Package&nbsp;&nbsp;</td>
<td>2010 SP1</td>
<td><a href="">32 bit</a></td>
<td><a href="">64 bit</a></td>
</tr>

<tr class="even">
<td>zlib</td>
<td>1.2.7</td>
<td><a href="">32 bit</a></td>
<td><a href="">64 bit</a></td>
</tr>

<tr>
<td>win-iconv</td>
<td>0.0.4</td>
<td><a href="">32 bit</a></td>
<td><a href="">64 bit</a></td>
</tr>

<tr class="even">
<td>FreeType</td>
<td>2.4.10</td>
<td><a href="">32 bit</a></td>
<td><a href="">64 bit</a></td>
</tr>

<tr>
<td>libxml2</td>
<td>2.9.0</td>
<td><a href="">32 bit</a></td>
<td><a href="">64 bit</a></td>
</tr>

<tr class="even">
<td>gettext-runtime</td>
<td>0.18</td>
<td><a href="">32 bit</a></td>
<td><a href="">64 bit</a></td>
</tr>

<tr>
<td>OpenSSL</td>
<td>1.0.1c</td>
<td><a href="">32 bit</a></td>
<td><a href="">64 bit</a></td>
</tr>

<tr class="even">
<td>libffi</td>
<td>3.0.11</td>
<td><a href="">32 bit</a></td>
<td><a href="">64 bit</a></td>
</tr>

<tr>
<td>libpng</td>
<td>1.5.13</td>
<td><a href="">32 bit</a></td>
<td><a href="">64 bit</a></td>
</tr>

<tr class="even">
<td>Fontconfig</td>
<td>2.8.0</td>
<td><a href="">32 bit</a></td>
<td><a href="">64 bit</a></td>
</tr>

<tr>
<td>Pixman</td>
<td>0.26.2</td>
<td><a href="">32 bit</a></td>
<td><a href="">64 bit</a></td>
</tr>

<tr class="even">
<td>GLib</td>
<td>2.34.1</td>
<td><a href="">32 bit</a></td>
<td><a href="">64 bit</a></td>
</tr>

<tr>
<td>Enchant</td>
<td>1.6.0</td>
<td><a href="">32 bit</a></td>
<td><a href="">64 bit</a></td>
</tr>

<tr class="even">
<td>ATK</td>
<td>2.5.91</td>
<td><a href="">32 bit</a></td>
<td><a href="">64 bit</a></td>
</tr>

<tr>
<td>GDK-PixBuf</td>
<td>2.26.4</td>
<td><a href="">32 bit</a></td>
<td><a href="">64 bit</a></td>
</tr>

<tr class="even">
<td>cairo</td>
<td>1.10.2</td>
<td><a href="">32 bit</a></td>
<td><a href="">64 bit</a></td>
</tr>

<tr>
<td>HarfBuzz *</td>
<td>0.9.4</td>
<td><a href="">32 bit</a></td>
<td><a href="">64 bit</a></td>
</tr>

<tr class="even">
<td>Pango</td>
<td>1.30.1</td>
<td><a href="">32 bit</a></td>
<td><a href="">64 bit</a></td>
</tr>

<tr>
<td>GTK+</td>
<td>2.24.13</td>
<td><a href="">32 bit</a></td>
<td><a href="">64 bit</a></td>
</tr>

<tr class="even">
<td>**GTK+ bundle**</td>
<td>2.24.13</td>
<td><a href="">32 bit</a></td>
<td><a href="">64 bit</a></td>
</tr>

</table>

If you feel brave enough to build these on your own, bear in mind, GTK+ on Windows is **pain in the ass**. You're warned.

<img src="images/dependency-graph.png" alt="gtk dependency graph" />

If this graph wasn't enough to frighten you off and you still think you want to do this, you'll need to install:

 * [Visual Studio 2010 Professional Trial](http://www.microsoft.com/en-us/download/details.aspx?id=16057)
 * [CMake](http://www.cmake.org/cmake/resources/software.html)
 * [MozillaBuild](http://ftp.mozilla.org/pub/mozilla.org/mozilla/libraries/win32/)
 * Perl 5.16 [x86](https://github.com/downloads/hexchat/hexchat/perl-5.16.2-x86.7z) or [x64](https://github.com/downloads/hexchat/hexchat/perl-5.16.2-x64.7z) (extract to _C:\mozilla-build\perl-5.16\Win32_ or _C:\mozilla-build\perl-5.16\x64_)
 * [NASM](http://www.nasm.us/pub/nasm/releasebuilds/?C=M;O=D) (extract to _C:\mozilla-build\nasm_)
 * [msgftm](https://github.com/downloads/hexchat/gtk-win32/msgfmt-0.18.1.7z) (extract to _c:\mozilla-build_)

As you can see, these libraries have a quite complex dependency order, so it's really recommended to build them in the order they're explained here, otherwise you'll probably encounter quite a few problems (you'll most likely encounter too many problems already, at least initially). After you built something, always extract the resulting package to _C:\mozilla-build\hexchat\build\Win32_ or _C:\mozilla-build\hexchat\build\x64_. When in Visual Studio, always select the _Release_ configurations, others most likely won't work.
