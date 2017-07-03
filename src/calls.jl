function Interpreter(h::InterpreterHooks)
    c = Interpreter()
    ccall((:cairo_script_interpreter_install_hooks,_jl_libcsi),
                Void,(Ptr{Void},Ptr{InterpreterHooks},),c.ptr,&h)
    c
end

function interpreter_install_hooks(c::Interpreter,h::InterpreterHooks)
    ccall((:cairo_script_interpreter_install_hooks,_jl_libcsi),
                Void,(Ptr{Void},Ptr{InterpreterHooks},),c.ptr,&h)
    c
end

function interpreter_run(c::Interpreter,filename::String)
    ccall((:cairo_script_interpreter_run,_jl_libcsi),
        UInt64,(Ptr{Void},Ptr{UInt8}),c.ptr,string(filename))
end

#function interpreter_feed_stream(c::Interpreter,stream::IOStream)
#    ccall((:cairo_script_interpreter_feed_stream,_jl_libcsi),
#        UInt64,(Ptr{Void},Ptr{UInt8}),c.ptr,stream)
#end

function interpreter_feed_string(c::Interpreter,s::AbstractString)
    ccall((:cairo_script_interpreter_feed_string,_jl_libcsi),
        UInt64,(Ptr{Void},Ptr{UInt8}),c.ptr,s)
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

function interpreter_finish(c::Interpreter)
    ccall((:cairo_script_interpreter_finish,_jl_libcsi),
        UInt64,(Ptr{Void},),c.ptr)
end

function interpreter_destroy(c::Interpreter)
    ccall((:cairo_script_interpreter_destroy,_jl_libcsi),
        UInt64,(Ptr{Void},),c.ptr)
end

# version 0 -> register surface in closure and use


function proto_surface_create(v::Ptr{Void},c::Int32,w::Float64,h::Float64,uid::UInt64)
    s = CairoSurface(v) 
    s.ptr
end

const surf_create_c = cfunction(proto_surface_create, Ptr{Void}, 
     (Ptr{Void},Int32,Float64,Float64,UInt64))
