# using Cairo

# li = joinpath(dirname(Cairo._jl_libcairo), "libcairo-script-interpreter.so")
# if isfile(li)
#     a = joinpath(dirname(@__FILE__),"deps.jl")
#     display(a)
#     f = open(a,"w")
#     write(f,"_jl_libcairo-script-interpreter = \"" * li * "\";")
#     close(f)
# else
#     error("couldn't find libcairo-script-interpreter.so")
# end


# # check for cairo version 
# function validate_cairo_version(name,handle)
#     f = Libdl.dlsym_e(handle, "cairo_version")
#     f == C_NULL && return false
#     v = ccall(f, Int32,())        
#     return v > 10800
# end

# group = library_group("cairo")


using BinDeps
using Compat

@BinDeps.setup

csi = library_dependency("csi", aliases = ["libcairo-script-interpreter", "libcairo-script-interpreter-2.2", "libcairo-script-interpreter-2-2", "libcairo-script-interpreter-2", "libcairo-script-interpreter-2.so.2"])

@static if is_linux() begin
        provides(AptGet, "libcairo-script-interpreter2-2",csi)
    end
end

@static if is_apple() begin
        using Homebrew
        provides(Homebrew.HB, "libcairo-script-interpreter", [csi], os=:Darwin)
    end
end

@static if is_windows() begin
        using WinRPM
        provides(WinRPM.RPM,"libcairo-script-interpreter-2-2",csi,os = :Windows)
    end
end

@BinDeps.install Dict(:csi => :_jl_libcsi)


# cairoscriptinterpreter = library_dependency("cairoscriptinterpreter", aliases = ["libcairo.so.2"])

# if is_windows()
#     using WinRPM
#     provides(WinRPM.RPM,"libpango-1_0-0",[pango,pangocairo],os = :Windows)
#     provides(WinRPM.RPM,["glib2", "libgobject-2_0-0"],gobject,os = :Windows)
#     provides(WinRPM.RPM,"zlib-devel",zlib,os = :Windows)
#     provides(WinRPM.RPM,["libcairo2","libharfbuzz0"],cairo,os = :Windows)
# end

# if is_apple()
#     if Pkg.installed("Homebrew") === nothing
#         error("Homebrew package not installed, please run Pkg.add(\"Homebrew\")")
#     end
#     using Homebrew
#     provides( Homebrew.HB, "cairo", cairo, os = :Darwin )
#     provides( Homebrew.HB, "pango", [pango, pangocairo], os = :Darwin, onload =
#     """
#     function __init__()
#         ENV["PANGO_SYSCONFDIR"] = joinpath("$(Homebrew.prefix())", "etc")
#     end
#     """ )
#     provides( Homebrew.HB, "fontconfig", fontconfig, os = :Darwin )
#     provides( Homebrew.HB, "glib", gobject, os = :Darwin )
#     provides( Homebrew.HB, "libpng", libpng, os = :Darwin )
#     provides( Homebrew.HB, "gettext", gettext, os = :Darwin )
#     provides( Homebrew.HB, "freetype", freetype, os = :Darwin )
#     provides( Homebrew.HB, "libffi", libffi, os = :Darwin )
#     provides( Homebrew.HB, "pixman", pixman, os = :Darwin )
# end

# # System Package Managers
# provides(AptGet,
#     @compat Dict(
#         "libcairo2" => cairo,
#         "libfontconfig1" => fontconfig,
#         "libpango1.0-0" => [pango,pangocairo],
#         "libglib2.0-0" => gobject,
#         "libpng12-0" => libpng,
#         "libpixman-1-0" => pixman,
#         "gettext" => gettext
#     ))

# # TODO: check whether these are accurate
# provides(Yum,
#     @compat Dict(
#         "cairo" => cairo,
#         "fontconfig" => fontconfig,
#         "pango" => [pango,pangocairo],
#         "glib2" => gobject,
#         "libpng" => libpng,
#         "gettext-libs" => gettext
#     ))
    
# provides(Zypper,
#     @compat Dict(
#         "libcairo" => cairo,
#         "libfontconfig" => fontconfig,
#         "libpango-1.0" => [pango,pangocairo],
#         "libglib-2.0" => gobject,
#         "libpng12" => libpng,
#         "libpixman-1" => pixman,
#         "gettext" => gettext
#     ))

# const png_version = "1.5.14"

# provides(Sources,
#     @compat Dict(
#         URI("http://www.cairographics.org/releases/pixman-0.28.2.tar.gz") => pixman,
#         URI("http://www.cairographics.org/releases/cairo-1.12.16.tar.xz") => cairo,
#         URI("http://download.savannah.gnu.org/releases/freetype/freetype-2.4.11.tar.gz") => freetype,
#         URI("http://www.freedesktop.org/software/fontconfig/release/fontconfig-2.10.2.tar.gz") => fontconfig,
#         URI("http://ftp.gnu.org/pub/gnu/gettext/gettext-0.18.2.tar.gz") => gettext,
#         URI("ftp://ftp.simplesystems.org/pub/libpng/png/src/history/libpng15/libpng-$(png_version).tar.gz") => libpng,
#         URI("ftp://sourceware.org/pub/libffi/libffi-3.0.11.tar.gz") => libffi,
#         URI("http://ftp.gnome.org/pub/gnome/sources/glib/2.34/glib-2.34.3.tar.xz") => gobject,
#         URI("http://ftp.gnome.org/pub/GNOME/sources/pango/1.32/pango-1.32.6.tar.xz") => [pango,pangocairo],
#         URI("http://zlib.net/zlib-1.2.7.tar.gz") => zlib
#     ))

# xx(t...) = (is_windows() ? t[1] : (is_linux() || length(t) == 2) ? t[2] : t[3])

# provides(BuildProcess,
#     @compat Dict(
#         Autotools(libtarget = "pixman/libpixman-1.la", installed_libname = xx("libpixman-1-0.","libpixman-1.","libpixman-1.0.")*Libdl.dlext) => pixman,
#         Autotools(libtarget = xx("objs/.libs/libfreetype.la","libfreetype.la")) => freetype,
#         Autotools(libtarget = "src/libfontconfig.la") => fontconfig,
#         Autotools(libtarget = "src/libcairo.la", configure_options = append!(append!(
#                 AbstractString[],
#                 !is_linux() ? AbstractString["--without-x","--disable-xlib","--disable-xcb"] : AbstractString[]),
#                 is_apple() ? AbstractString["--enable-quartz","--enable-quartz-font","--enable-quartz-image","--disable-gl"] : AbstractString[])) => cairo,
#         Autotools(libtarget = "gettext-tools/gnulib-lib/.libs/libgettextlib.la") => gettext,
#         Autotools(libtarget = "libffi.la") => libffi,
#         Autotools(libtarget = "gobject/libgobject-2.0.la") => gobject,
#         Autotools(libtarget = "pango/libpango-1.0.la") => [pango,pangocairo]
#     ))

# provides(BuildProcess,Autotools(libtarget = "libpng15.la"),libpng,os = :Unix)

# provides(SimpleBuild,
#     (@build_steps begin
#         GetSources(zlib)
#         @build_steps begin
#             ChangeDirectory(joinpath(BinDeps.depsdir(zlib),"src","zlib-1.2.7"))
#             MakeTargets(["-fwin32/Makefile.gcc"])
#             #MakeTargets(["-fwin32/Makefile.gcc","DESTDIR=../../usr/","INCLUDE_PATH=include","LIBRARY_PATH=lib","SHARED_MODE=1","install"])
#         end
#     end),zlib, os = :Windows)

# prefix=joinpath(BinDeps.depsdir(libpng),"usr")
# uprefix = replace(replace(prefix,"\\","/"),"C:/","/c/")
# pngsrcdir = joinpath(BinDeps.depsdir(libpng),"src","libpng-$png_version")
# pngbuilddir = joinpath(BinDeps.depsdir(libpng),"builds","libpng-$png_version")
# provides(BuildProcess,
#     (@build_steps begin
#         GetSources(libpng)
#         CreateDirectory(pngbuilddir)
#         @build_steps begin
#             ChangeDirectory(pngbuilddir)
#             FileRule(joinpath(prefix,"lib","libpng15.dll"),@build_steps begin
#                 `cmake -DCMAKE_INSTALL_PREFIX="$prefix" -G"MSYS Makefiles" $pngsrcdir`
#                 `make`
#                 `cp 'libpng*.dll' $prefix/lib`
#                 `cp 'libpng*.a' $prefix/lib`
#                 `cp 'libpng*.pc' $prefix/lib/pkgconfig`
#                 `cp pnglibconf.h $prefix/include`
#                 `cp $pngsrcdir/png.h $prefix/include`
#                 `cp $pngsrcdir/pngconf.h $prefix/include`
#             end)
#         end
#     end),libpng, os = :Windows)

# @BinDeps.install Dict([(:cairoscriptinterpreter, :_jl_libcairo-script-interpreter)])
                       