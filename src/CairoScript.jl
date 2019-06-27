module CairoScript

__precompile__(false)

depsjl = joinpath(dirname(@__FILE__), "..", "deps", "deps.jl")
isfile(depsjl) ? include(depsjl) : error("CairoScript not properly ",
    "installed. Please run\nPkg.build(\"CairoScript\")")

using Compat;  import Compat.String
using Cairo

import Graphics: GraphicsDevice

include("types.jl")
include("calls.jl")

end # module
