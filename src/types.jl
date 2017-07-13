type csi_t
    ref_count::Int64
    status::Int32
    finished::UInt32
    hooks::Ptr{Void}
end

type Interpreter <: GraphicsDevice
    ptr::Ptr{csi_t}

    function Interpreter(ptr::Ptr{Void})
        self = new(ptr)
        finalizer(self, destroy)
        self
    end
end

function destroy(csi::Interpreter)
    if csi.ptr == C_NULL
        return
    end
    ccall((:cairo_script_interpreter_destroy,_jl_libcsi), Void, (Ptr{Void},), csi.ptr)
    csi.ptr = C_NULL
    nothing
end

function Interpreter()
    ptr = ccall((:cairo_script_interpreter_create,_jl_libcsi),
                Ptr{Void},())
    Interpreter(ptr)
end

type cl <: GraphicsDevice
    s::CairoSurface
end

type InterpreterHooks <: GraphicsDevice
	closure::Ptr{Void} 
	surface_create::Ptr{Void} 
	surface_destroy::Ptr{Void}
	context_create::Ptr{Void} 
	context_destroy::Ptr{Void}
	show_page::Ptr{Void} 
	copy_page::Ptr{Void} 
	create_source_image::Ptr{Void} 

	function InterpreterHooks(;
                closure = C_NULL, 
                surface_create = C_NULL,
                surface_destroy = C_NULL,
                context_create = C_NULL, 
                context_destroy = C_NULL,
                show_page = C_NULL, 
                copy_page = C_NULL, 
                create_source_image = C_NULL)

		#self = new(cl(CairoSurface(Ptr{Void}(0))),C_NULL,C_NULL,C_NULL,C_NULL,C_NULL,C_NULL,C_NULL)
        self = new(closure,surface_create,surface_destroy,context_create,context_destroy,show_page,copy_page,create_source_image)
		self
	end

    #function InterpreterHooks()
end

# typedef enum _csi_status {
#     CSI_STATUS_SUCCESS = CAIRO_STATUS_SUCCESS,
#     CSI_STATUS_NO_MEMORY = CAIRO_STATUS_NO_MEMORY,
#     CSI_STATUS_INVALID_RESTORE = CAIRO_STATUS_INVALID_RESTORE,
#     CSI_STATUS_INVALID_POP_GROUP = CAIRO_STATUS_INVALID_POP_GROUP,
#     CSI_STATUS_NO_CURRENT_POINT = CAIRO_STATUS_NO_CURRENT_POINT,
#     CSI_STATUS_INVALID_MATRIX = CAIRO_STATUS_INVALID_MATRIX,
#     CSI_STATUS_INVALID_STATUS = CAIRO_STATUS_INVALID_STATUS,
#     CSI_STATUS_NULL_POINTER = CAIRO_STATUS_NULL_POINTER,
#     CSI_STATUS_INVALID_STRING = CAIRO_STATUS_INVALID_STRING,
#     CSI_STATUS_INVALID_PATH_DATA = CAIRO_STATUS_INVALID_PATH_DATA,
#     CSI_STATUS_READ_ERROR = CAIRO_STATUS_READ_ERROR,
#     CSI_STATUS_WRITE_ERROR = CAIRO_STATUS_WRITE_ERROR,
#     CSI_STATUS_SURFACE_FINISHED = CAIRO_STATUS_SURFACE_FINISHED,
#     CSI_STATUS_SURFACE_TYPE_MISMATCH = CAIRO_STATUS_SURFACE_TYPE_MISMATCH,
#     CSI_STATUS_PATTERN_TYPE_MISMATCH = CAIRO_STATUS_PATTERN_TYPE_MISMATCH,
#     CSI_STATUS_INVALID_CONTENT = CAIRO_STATUS_INVALID_CONTENT,
#     CSI_STATUS_INVALID_FORMAT = CAIRO_STATUS_INVALID_FORMAT,
#     CSI_STATUS_INVALID_VISUAL = CAIRO_STATUS_INVALID_VISUAL,
#     CSI_STATUS_FILE_NOT_FOUND = CAIRO_STATUS_FILE_NOT_FOUND,
#     CSI_STATUS_INVALID_DASH = CAIRO_STATUS_INVALID_DASH,
#     CSI_STATUS_INVALID_DSC_COMMENT = CAIRO_STATUS_INVALID_DSC_COMMENT,
#     CSI_STATUS_INVALID_INDEX = CAIRO_STATUS_INVALID_INDEX,
#     CSI_STATUS_CLIP_NOT_REPRESENTABLE = CAIRO_STATUS_CLIP_NOT_REPRESENTABLE,
#     CSI_STATUS_TEMP_FILE_ERROR = CAIRO_STATUS_TEMP_FILE_ERROR,
#     CSI_STATUS_INVALID_STRIDE = CAIRO_STATUS_INVALID_STRIDE,
#     CSI_STATUS_FONT_TYPE_MISMATCH = CAIRO_STATUS_FONT_TYPE_MISMATCH,
#     CSI_STATUS_USER_FONT_IMMUTABLE = CAIRO_STATUS_USER_FONT_IMMUTABLE,
#     CSI_STATUS_USER_FONT_ERROR = CAIRO_STATUS_USER_FONT_ERROR,
#     CSI_STATUS_NEGATIVE_COUNT = CAIRO_STATUS_NEGATIVE_COUNT,
#     CSI_STATUS_INVALID_CLUSTERS = CAIRO_STATUS_INVALID_CLUSTERS,
#     CSI_STATUS_INVALID_SLANT = CAIRO_STATUS_INVALID_SLANT,
#     CSI_STATUS_INVALID_WEIGHT = CAIRO_STATUS_INVALID_WEIGHT,

#     /* cairo-script-interpreter specific errors */

#     CSI_STATUS_INVALID_SCRIPT,
#     CSI_STATUS_SCRIPT_INVALID_TYPE,
#     CSI_STATUS_SCRIPT_INVALID_INDEX,
#     CSI_STATUS_SCRIPT_UNDEFINED_NAME,
#     CSI_STATUS_INTERPRETER_FINISHED,

#     _CSI_STATUS_SCRIPT_LAST_ERROR,
#     CSI_INT_STATUS_UNSUPPORTED
# } csi_status_t;