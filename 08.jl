using Test
using Base.Iterators: countfrom, cycle

function walk(network::Dict, instr::Vector{Int}, init::AbstractString, isend::Function)::Int
    for (steps, i) in zip(countfrom(1), cycle(instr))
        init = network[init][i]
        isend(init) && return steps
    end
end

function solve(path::String)::Tuple{Int, Int}
    instr, network = split(read(path, String), "\n\n")
    instr = findfirst.(collect(instr), "LR")
    network = map(eachsplit(network, "\n", keepempty=false)) do line
        node, c1, c2 = eachsplit(line, r"\W+", keepempty=false)
        node => (c1, c2)
    end |> Dict

    part1 = walk(network, instr, "AAA", ==("ZZZ"))
    part2 = map(collect(filter(endswith('A'), keys(network)))) do init
        walk(network, instr, init, endswith('Z'))
    end |> lcm
    return part1, part2
end

@test solve("examples/08.txt") == (6, 6)
@test solve("data/08.txt") == (22411, 11188774513823)
@time solve("data/08.txt")
