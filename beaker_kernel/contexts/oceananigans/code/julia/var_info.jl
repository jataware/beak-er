using Oceananigans
_result = Dict()
_var_syms = names(Main)

_oceananigans_types = [
    Oceananigans.AbstractGrid,
    Oceananigans.Simulation,
    Oceananigans.AbstractModel,
    Oceananigans.TurbulenceClosures.AbstractTurbulenceClosure,
    Oceananigans.Grids.AbstractTopology,
]


for _var_sym in _var_syms
    _var = eval(_var_sym)
    if any(_type -> isa(_var, _type), _oceananigans_types)
        _result["$(_var_sym)"] = Dict(
            "type" => typeof(_var),
            "value" => string(_var),
        )
    end
end

JSON3.write(_result) |> DisplayAs.unlimited
