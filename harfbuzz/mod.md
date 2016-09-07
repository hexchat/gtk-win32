* Download [HarfBuzz 1.3.0](https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.3.0.tar.bz2)
* In win32\config-msvc.mak, replace
	```
	HARFBUZZ_DLL_FILENAME = $(CFG)\$(PLAT)\harfbuzz-vs$(VSVER)
	HARFBUZZ_ICU_DLL_FILENAME = $(CFG)\$(PLAT)\harfbuzz-icu-vs$(VSVER)
	HARFBUZZ_GOBJECT_DLL_FILENAME = $(CFG)\$(PLAT)\harfbuzz-gobject-vs$(VSVER)
	```

	with

	```
	HARFBUZZ_DLL_FILENAME = $(CFG)\$(PLAT)\harfbuzz
	HARFBUZZ_ICU_DLL_FILENAME = $(CFG)\$(PLAT)\harfbuzz-icu
	HARFBUZZ_GOBJECT_DLL_FILENAME = $(CFG)\$(PLAT)\harfbuzz-gobject
	```
