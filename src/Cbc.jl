module Cbc

if haskey(ENV,"JULIA_CBC_LIBRARY_PATH") || VERSION < v"1.3"
    deps_file = joinpath(dirname(@__DIR__), "deps", "deps.jl")
    if isfile(deps_file)
        using Libdl
        include(deps_file)
    else
        error(
            "Cbc not properly installed. Please run `import Pkg; " *
            "Pkg.build(\"Cbc\")` for more information."
        )
    end
else
    import Cbc_jll: libcbcsolver
end

using CEnum

include("gen/ctypes.jl")
include("gen/libcbc_common.jl")
include("gen/libcbc_api.jl")

const _CBC_VERSION_STRING = unsafe_string(Cbc_getVersion())

if _CBC_VERSION_STRING !== "devel"
    const _CBC_VERSION = VersionNumber(_CBC_VERSION_STRING)

    if !(v"2.10.0" <= _CBC_VERSION <= v"2.10.5")
        error("""
    You have installed version $_CBC_VERSION of Cbc, which is not supported by
    Cbc.jl We require Cbc version 2.10. After installing Cbc 2.10, run:

        import Pkg
        Pkg.rm("Cbc")
        Pkg.add("Cbc")

    If you have a newer version of Cbc installed, changes may need to be made
    to the Julia code. Please open an issue at
    https://github.com/jump-dev/Cbc.jl.
    """)
    end
end

include("MOI_wrapper/MOI_wrapper.jl")

# TODO(odow): remove at Cbc.jl v1.0.0.
function CbcSolver(args...; kwargs...)
    error(
        "`CbcSolver` is no longer supported. If you are using JuMP, upgrade " *
        "to the latest version and use `Cbc.Optimizer` instead. If you are " *
        "using MathProgBase (e.g., via `lingprog`), you will need to upgrade " *
        "to MathOptInterface (https://github.com/jump-dev/MathOptInterface.jl)."
    )
end
export CbcSolver

end
