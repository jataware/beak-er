using SyntacticModels, Decapodes, Catlab
import JSON3, DisplayAs

function expr_to_svg(expr)
    io = IOBuffer()
    Catlab.Graphics.Graphviz.run_graphviz(io, to_graphviz(Decapodes.SummationDecapode(expr)), format="svg")
    String(take!(io))
end
print(_expr)

_response = Dict(
    "application/json" => _expr,
    "image/svg" => expr_to_svg(_expr) 
)
print(_response)
_response |> DisplayAs.unlimited ∘ JSON3.write
