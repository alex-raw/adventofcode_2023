using Test
using Base.Iterators: cycle

function walk(network::Dict, dirs::String, init::AbstractString, isend::Function)::Int
    for (steps, i) in enumerate(cycle(dirs))
        init = network[init][i == 'L' ? 1 : 2]
        isend(init) && return steps
    end
end

function solve(path::String)::Tuple{Int, Int}
    dirs, _, nw... = readlines(path)
    nw = Dict(node => (L, R) for (node, L, R) in eachsplit.(nw, r"\W+"))
    part1 = walk(nw, dirs, "AAA", ==("ZZZ"))
    part2 = [walk(nw, dirs, init, endswith('Z')) for init in filter(endswith('A'), keys(nw))]
    return part1, lcm(part2)
end

@test solve("examples/08.txt") == (6, 6)
@test solve("data/08.txt") == (22411, 11188774513823)
@time solve("data/08.txt"); @time solve("data/08.txt")
