using ACSets, Decapodes
import HTTP
{{ var_name|default("model") }} = parse_json_acset(SummationDecapode{String, String, String}, String(HTTP.get("{{ model_url }}").body))
