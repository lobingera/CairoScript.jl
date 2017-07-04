using Cairo
using CairoScript

using Compat, Colors
import Compat.String

@compat import Base.show

if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end


pkg_dir = dirname(dirname(@__FILE__))

# Image Surface
@testset "Interpreter Run" begin

    surf = CairoImageSurface(512, 512, Cairo.FORMAT_ARGB32)
    testfile = joinpath(pkg_dir,"data","a1.cs");

    h = CairoScript.InterpreterHooks()
    h.surface_create = CairoScript.surf_create_c
    h.closure = surf.ptr
    c = CairoScript.Interpreter()
    c = CairoScript.interpreter_install_hooks(c,h)
    status = CairoScript.interpreter_run(c,testfile)
    @test status == 0
    finish(surf)
    surf.ptr = C_NULL;
    outputfile = "out.png"
    @test isfile(outputfile)
    rm(outputfile)


    surf = CairoImageSurface(512, 512, Cairo.FORMAT_ARGB32)
    testfile = joinpath(pkg_dir,"data","a2.cs");

    h = CairoScript.InterpreterHooks()
    h.surface_create = CairoScript.surf_create_c
    h.closure = surf.ptr
    c = CairoScript.Interpreter()
    c = CairoScript.interpreter_install_hooks(c,h)
    status = CairoScript.interpreter_run(c,testfile)
    @test status == 0

    outputfile = "out.png"
    Cairo.write_to_png(surf,outputfile)
    finish(surf)
    surf.ptr = C_NULL;
    
    @test isfile(outputfile)
    rm(outputfile)

    surf = CairoImageSurface(512, 512, Cairo.FORMAT_ARGB32)
    testdata = """
%!CairoScript
<< /content //COLOR_ALPHA /width 400 /height 300 >> surface context
0 0 1 rgb set-source
n 128 25.601562 m 230.398438 230.398438 l 128 230.398438 l 51.199219 230.398438 51.199219 128 128 128 c h 64 25.601562 m 115.199219 76.800781 l 64 128 l 12.800781 76.800781 l h 64 25.601562 m
fill+
0 g set-source
10 set-line-width
stroke
"""

#     testdata = """
# %!CairoScript
# << /content //COLOR_ALPHA /width 400 /height 300 >> surface context
# 1 0 1 rgb set-source
# paint
# """
    h = CairoScript.InterpreterHooks()
    h.surface_create = CairoScript.surf_create_c
    h.closure = surf.ptr
    c = CairoScript.Interpreter()
    c = CairoScript.interpreter_install_hooks(c,h)
    status = CairoScript.interpreter_feed_string(c,testdata)
    display(testdata)
    @test status == 0

    outputfile = "out.png"
    Cairo.write_to_png(surf,outputfile)
    finish(surf)
    surf.ptr = C_NULL;
    
    @test isfile(outputfile)
    rm(outputfile)


end

