using ACSets, Decapodes, SyntacticModels
import HTTP, JSON3, DisplayAs
_amr = JSON3.read(String(HTTP.get("{{ model_url }}").body), SyntacticModels.ASKEMDecapodes.ASKEMDecaExpr)
{{ var_name|default("model") }} = Decapodes.SummationDecapode(_amr.model)
# Dict(["var_name" => "{{ var_name|default("model") }}"]) |> DisplayAs.unlimited # TODO: Fix 'Unable to parse result' false error
