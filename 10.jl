using Test
using Base: prompt
using Base.Iterators: countfrom

const →, ↑, ←, ↓, ∅ = CartesianIndex.(((1, 0), (0, -1), (-1, 0), (0, 1), (0, 0)))
const PIPES = Dict(
        Int('|') => (↑, ↓), Int('-') => (←, →), Int('L') => (↑, →),
        Int('J') => (↑, ←), Int('7') => (↓, ←), Int('F') => (↓, →),
    )

firstpipe(tiles, S) = first(filter((↑, ↓, ←, →)) do Δ
        checkbounds(Bool, tiles, S + Δ) &&
        tiles[S + Δ] != Int('.') &&
        -Δ in PIPES[tiles[S + Δ]]
    end)

function walk(tiles::Matrix, xy::CartesianIndex)::Tuple{Int, BitMatrix}
    visited = falses(size(tiles))
    Δ = firstpipe(tiles, xy)
    for i in countfrom(1)
        visited[xy] = true
        xy += Δ
        if tiles[xy] == Int('S')
            return ceil(i / 2), visited
        end
        a, b = PIPES[tiles[xy]]
        Δ = a == -Δ ? b : a
    end
end

function solve(filename::String)::Tuple{Int, Int}
    tiles = reduce(hcat, collect.(Int, eachline(filename)))
    start = findfirst(==(Int('S')), tiles)
    part1, visited = walk(tiles, start)
    part2 = 0
    return part1, part2
end

# @test solve("examples/10-2.txt") == (70, 8)
# @test solve("examples/10-3.txt") == (80, 10)
# @test solve("data/10.txt") == (6907, 0)
@time solve("data/10.txt"); @time solve("data/10.txt")
