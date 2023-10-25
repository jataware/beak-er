using ACSets, Decapodes, SyntacticModels
import HTTP, JSON3, DisplayAs
# _decapode = JSON.parse(String(HTTP.get("{{ model_url }}").body))["model"]
# {{ var_name|default("model") }} = parse_json_acset(SummationDecapode{String, String, String}, _decapode)
# Dict(["var_name" => "{{ var_name|default("model") }}"]) |> DisplayAs.unlimited # TODO: Fix 'Unable to parse result' false error
_amr = HTTP.get("{{ model_url }}").body |> JSON.parse ∘ String
{{ var_name|default("model") }} = _amr |> Decapodes.SummationDecapode ∘ SyntacticModels.AMR.amr_to_expr
