using Test
using BenchmarkTools

decode(seq) = reduce((n, c) -> 17(n + Int(c)) % 256, seq, init=0)
focusing_power(id_vec) = sum(id_vec[1] .* id_vec[2] .* eachindex(id_vec[2]))

function solve(path::String)::Tuple{Int, Int}
    input = split(readchomp(path), ',')
    labels = [String[] for _ in 1:256]
    focals = [Int[] for _ in 1:256]
    for seq in input
        label, focal = split(seq, r"[=-]")
        i = decode(label) + 1
        focal = tryparse(Int, focal)
        imatch = findfirst(==(label), labels[i])

        if isnothing(imatch) && !isnothing(focal)
            push!(labels[i], label)
            push!(focals[i], focal)
        elseif !isnothing(imatch) && isnothing(focal)
            deleteat!(labels[i], imatch)
            deleteat!(focals[i], imatch)
        elseif !isnothing(imatch) && !isnothing(focal)
            setindex!(focals[i], focal, imatch)
        end
    end
    part1 = sum(decode, input)
    part2 = sum(focusing_power, enumerate(focals))
    return part1, part2
end

@test solve("examples/15.txt") == (1320, 145)
@test solve("data/15.txt") == (507291, 296921)
@btime solve("data/15.txt")
