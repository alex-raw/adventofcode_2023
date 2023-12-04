using Test
using Base.Iterators

function surrounding_coords(x::Int, w::Int)::Vector{Int}
    [
        x - 1; x + 1;
        x - w; x + w;
        x - w - 1; x - w + 1;
        x + w - 1; x + w + 1;
    ]
end

function solve(path::String)::Tuple{Int, Int}
    isfile(path) || error("File not found: $path")
    w = length(readline(path))
    nums = Vector{Pair{Int, UnitRange{Int}}}()
    symbols = Dict{Char, Array{Int}}()

    for (i, line) in enumerate(eachline(path))
        for m in eachmatch(r"\d+", line)
            num = parse(Int, m.match)
            push!(nums, num => range(m.offset + (i - 1) * w, length=length(m.match)))
        end
        for m in eachmatch(r"[^\d.]", line)
            char = only(m.match)
            haskey(symbols, char) || push!(symbols, char => [])
            push!(symbols[char], m.offset + (i - 1) * w)
        end
    end

    neighbors = surrounding_coords.(Iterators.flatten(values(symbols)), w)
    part_sum = sum(val for (val, r) in nums if any(any.(∈(r), neighbors)))

    all_ranges = [i for (_, i) in nums]
    gear_ratio = 0

    for val in symbols['*']
        c = sum(x -> issubset.(x, all_ranges), surrounding_coords(val, w)) .!= 0
        if sum(c) == 2
            gear_ratio += prod(val for (val, _) in nums[c])
        end
    end

    return part_sum, gear_ratio
end

@test solve("examples/03.txt") == (4361, 467835)
@test solve("data/03.txt") == (551094, 80179647)
