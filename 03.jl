using Test
using Base.Iterators: flatten

function lookaround(x::Int, w::Int)::NTuple{8, Int}
    (
        x - 1, x + 1,
        x - w, x + w,
        x - w - 1, x - w + 1,
        x + w - 1, x + w + 1,
    )
end

function solve(path::String)::Tuple{Int, Int}
    w = length(readline(path))
    input = replace(read(path, String), '\n' => "")

    nums = eachmatch(r"\d+", input)
    vals = [parse(Int, num.match) for num in nums]
    rngx = [range(num.offset, length=length(num.match)) for num in nums]

    syms = collect(eachmatch(r"[^\d.]", input))
    neighbors = map(x -> lookaround(x.offset, w), syms)
    part_sum = sum(vals[findall(x -> !isdisjoint(x, flatten(neighbors)), rngx)])

    adjstars = neighbors[findall(m -> '*' in m.match, syms)]
    c = [!isdisjoint(a, r) for a in adjstars, r in rngx]
    gear_ratio = sum(prod(vals[i]) for i in eachrow(c) if sum(i) == 2)

    return part_sum, gear_ratio
end

@test solve("examples/03.txt") == (4361, 467835)
@test solve("data/03.txt") == (551094, 80179647)
@time solve("data/03.txt")
@time solve("data/03.txt")
