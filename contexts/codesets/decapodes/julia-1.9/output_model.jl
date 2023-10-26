using Decapodes
import JSON3, DisplayAs

{{ var_name|default("model") }} |> DisplayAs.unlimited ∘ JSON3.write ∘ Decapodes.Term