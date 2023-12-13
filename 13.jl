using Test
using BenchmarkTools

parse_line(line) = collect(line) .== '#'
parse_block(block) = mapreduce(parse_line, hcat, eachsplit(chomp(block), '\n'))
parse_input(path) = map(parse_block, eachsplit(read(path, String), "\n\n"))

function isreflection(i::Int, grid::AbstractMatrix; dim=1, tol=0)::Bool
    n = size(grid, dim)
    i + 1 > n && return false
    for (a, b) in zip(i:-1:1, i+1:n)
        slice1, slice2 = selectdim(grid, dim, a), selectdim(grid, dim, b)
        deviation = sum(slice1 .⊻ slice2)
        deviation > tol && return false
        tol ⊻= deviation > 0  # 'smudge' already assumed, no tolerance for the rest
    end
    return tol == 0           # no deviation means only reflecting without 'smudge'
end

function refl_index(grid::AbstractMatrix; tol=0)::Int
    r, c = axes(grid)
    x = findfirst(i -> isreflection(i, grid, dim=1, tol=tol), r)
    y = findfirst(i -> isreflection(i, grid, dim=2, tol=tol), c)
    return @something x 100y
end

function solve(path::String)::Tuple{Int, Int}
    grids = parse_input(path)
    part1 = sum(refl_index, grids)
    part2 = sum(grid -> refl_index(grid, tol=1), grids)
    return part1, part2
end

@test solve("examples/13.txt") == (405, 400)
@test solve("data/13.txt") == (34889, 34224)
@btime solve("data/13.txt")
