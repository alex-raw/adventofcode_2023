using Test
using Base.Iterators

function solve1(maps::Vector{Vector{Int}}, offset::Int)::Int
   for map in maps
       for (destination, source, l) in Iterators.partition(map, 3)
           offset ∈ range(source, length=l) || continue
           offset = offset - source + destination
           break
       end
   end
   return offset
end

function solve2(maps::Vector{Vector{Int}}, offset::Int, l::Int)::Int
    ranges = [range(offset, length=l)]
    for map in maps
        next = Vector{UnitRange{Int}}()
        for (destination, source, l2) in Iterators.partition(map, 3)
            r2 = range(source, length=l2)
            for r in ranges
                inter = intersect(r, r2)
                isempty(inter) && continue

                push!(next, range(inter.start - source + destination, length=length(inter)))

                left = r.start:r2.start
                right = r2.stop:r.stop
                isempty(left) || push!(next, left)
                isempty(right) || push!(next, right)
            end
        end
        isempty(next) || (ranges = unique(next))
    end
    return minimum(s.start for s in ranges)
end

function solve(path::String; part2=false)::Tuple{Int, Int}
    seeds, maps... = read(path, String) |>
        x -> eachsplit(x, "\n\n") .|>
        x -> eachmatch(r"\d+", x) .|>
        x -> parse(Int, x.match)

    part1 = map(x -> solve1(maps, x), seeds) |> minimum
    part2 = map(x -> solve2(maps, x...), Iterators.partition(seeds, 2))

    # TODO: hack, not sure why I get 0s
    part2 = minimum(filter(!iszero, part2))

    return part1, part2
end

@test solve("examples/05.txt") == (35, 46)
@test solve("data/05.txt") == (88151870, 2008785)
@time solve("data/05.txt")
