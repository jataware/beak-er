using ACSets, Decapodes
import HTTP, JSON, DisplayAs
_decapode = JSON.parse(String(HTTP.get("{{ model_url }}").body))["model"]
{{ var_name|default("model") }} = parse_json_acset(SummationDecapode{String, String, String}, _decapode)
Dict(["var_name" => "{{ var_name|default("model") }}"]) |> DisplayAs.unlimited # TODO: Fix 'Unable to parse result' false error
