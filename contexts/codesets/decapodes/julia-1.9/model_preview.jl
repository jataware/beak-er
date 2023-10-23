# TODO: Use nice table that is available in REPL
io = IOBuffer()
print(io,{{ var_name }})
io |> String ∘ take!
