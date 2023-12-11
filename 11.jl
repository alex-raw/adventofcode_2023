using Test

function solve(path::String; add=1_000_000)::Tuple{Int, Int}
    grid = reduce(hcat, map.(==('#'), collect.(eachline(path))))
    idx = findall(grid)
    r0, c0 = findall(iszero, eachrow(grid)), findall(iszero, eachcol(grid))
    part1, part2 = 0, 0
    for a in idx, b in idx
        a < b || continue              # ensures ay < by, discards duplicates
        (ax, ay), (bx, by) = a.I, b.I  # fields of CartesianIndex
        ax, bx = minmax(ax, bx)        # ensures ax < bx
        nr, nc = sum(ax .< r0 .< bx), sum(ay .< c0 .< by)
        dist = abs(ax - bx) + abs(ay - by)
        part1 += dist + nr + nc
        part2 += dist + nr * (add - 1) + nc * (add - 1)
    end
    return part1, part2
end

@testset "distances" begin
    @test solve("examples/11.txt", add=10) == (374, 1030)
    @test solve("examples/11.txt", add=100) == (374, 8410)
    @test solve("data/11.txt") == (9556712, 678626199476)
end

@time solve("data/11.txt"); @time solve("data/11.txt")
@time solve("data/11.txt"); @time solve("data/11.txt")
