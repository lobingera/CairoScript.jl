
function string_to_script(testdata,surf)

    h = CairoScript.InterpreterHooks()
    h.surface_create = CairoScript.surf_create_c
    h.closure = surf.ptr
    c = CairoScript.Interpreter()
    c = CairoScript.interpreter_install_hooks(c,h)
    CairoScript.interpreter_feed_string(c,testdata)

    end