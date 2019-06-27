function Interpreter(h::InterpreterHooks)
    c = Interpreter()
    ccall((:cairo_script_interpreter_install_hooks,_jl_libcsi),
                Nothing,(Ptr{Nothing},Ptr{InterpreterHooks},),c.ptr,h)
    c
end

function interpreter_install_hooks(c::Interpreter,h::InterpreterHooks)
    ccall((:cairo_script_interpreter_install_hooks,_jl_libcsi),
                Nothing,(Ptr{Nothing},Ref{InterpreterHooks},),c.ptr,h)
    c
end

function interpreter_run(c::Interpreter,filename::AbstractString)
    ccall((:cairo_script_interpreter_run,_jl_libcsi),
        UInt64,(Ptr{Nothing},Cstring),c.ptr,@compat(String(filename)))
end

#function interpreter_feed_stream(c::Interpreter,stream::IOStream)
#    ccall((:cairo_script_interpreter_feed_stream,_jl_libcsi),
#        UInt64,(Ptr{Nothing},Ptr{UInt8}),c.ptr,stream)
#end

function interpreter_feed_string(c::Interpreter,s::AbstractString)
    ccall((:cairo_script_interpreter_feed_string,_jl_libcsi),
        UInt64,(Ptr{Nothing},Cstring,UInt64),c.ptr,@compat(String(s)),length(s))
end


# cairo_public cairo_status_t
# cairo_script_interpreter_feed_stream (cairo_script_interpreter_t *ctx,
#                     FILE *stream);

# cairo_public cairo_status_t
# cairo_script_interpreter_feed_string (cairo_script_interpreter_t *ctx,
#                     const char *line,
#                     int len);

# cairo_public unsigned int
# cairo_script_interpreter_get_line_number (cairo_script_interpreter_t *ctx);

# function interpreter_finish(c::Interpreter)
#     ccall((:cairo_script_interpreter_finish,_jl_libcsi),
#         UInt64,(Ptr{Void},),c.ptr)
# end

# function interpreter_destroy(c::Interpreter)
#     ccall((:cairo_script_interpreter_destroy,_jl_libcsi),
#         UInt64,(Ptr{Void},),c.ptr)
# end

# version 0 -> register surface in closure and use


function proto_surface_create(v::Ptr{Nothing},c::Int32,w::Float64,h::Float64,uid::UInt64)
    s = CairoSurface(v) 
    s.ptr
end

const surf_create_c = Ref{Ptr{Nothing}}(0)

function __init__()
  surf_create_c[] = @cfunction(CairoScript.proto_surface_create, Ptr{Nothing}, 
     (Ptr{Nothing},Int32,Float64,Float64,UInt64))
end
