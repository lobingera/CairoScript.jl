using Cairo
using CairoScript

using Compat, Colors
import Compat.String

import Base.show

using Base.Test

include("test_painting.jl")

pkg_dir = dirname(dirname(@__FILE__))

# Image Surface
@testset "Interpreter Run" begin

    # run a script that includes a writing operation
    surf = CairoImageSurface(256, 256, Cairo.FORMAT_ARGB32)
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


    # run a script that just does painting
    surf = CairoImageSurface(256, 256, Cairo.FORMAT_ARGB32)
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

    # script from string
    surf = CairoImageSurface(256, 256, Cairo.FORMAT_ARGB32)
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

    h = CairoScript.InterpreterHooks()
    h.surface_create = CairoScript.surf_create_c
    h.closure = surf.ptr
    c = CairoScript.Interpreter()
    c = CairoScript.interpreter_install_hooks(c,h)
    status = CairoScript.interpreter_feed_string(c,testdata)
    #display(testdata)
    @test status == 0

    outputfile = "out.png"
    Cairo.write_to_png(surf,outputfile)
    finish(surf)
    surf.ptr = C_NULL;
    
    @test isfile(outputfile)
    rm(outputfile)

end

@testset "Content Test" begin

    # test if surface contains color
    surf = CairoImageSurface(256, 256, Cairo.FORMAT_ARGB32)
    testfile = joinpath(pkg_dir,"data","a2.cs");

    h = CairoScript.InterpreterHooks()
    h.surface_create = CairoScript.surf_create_c
    h.closure = surf.ptr
    c = CairoScript.Interpreter()
    c = CairoScript.interpreter_install_hooks(c,h)
    status = CairoScript.interpreter_run(c,testfile)
    @test status == 0
    
    d = simple_hist(matrix_read(surf))
    
    @test length(d) == 1 
    @test collect(keys(d))[1] == 0xffffff00

    finish(surf)
    surf.ptr = C_NULL;

    # short setup, same data and test
    surf = CairoImageSurface(256, 256, Cairo.FORMAT_ARGB32)
    testfile = joinpath(pkg_dir,"data","a2.cs");
    c = CairoScript.Interpreter(
        CairoScript.InterpreterHooks(
            closure = surf.ptr, surface_create = CairoScript.surf_create_c))
    status = CairoScript.interpreter_run(c,testfile)

    @test status == 0
    
    d = simple_hist(matrix_read(surf))
    
    @test length(d) == 1 
    @test collect(keys(d))[1] == 0xffffff00

    finish(surf)

    surf.ptr = C_NULL;        

end

