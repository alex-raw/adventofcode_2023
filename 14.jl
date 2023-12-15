using Test
using BenchmarkTools
using Base.Iterators

function tilt!(plane, rocks, Δ=CartesianIndex(0, -1))
    for (i, rock) in enumerate(rocks)
        plane[rock] = false
        while checkbounds(Bool, plane, rock + Δ) && !plane[rock + Δ]
            rock += Δ
        end
        plane[rock] = true
        rocks[i] = rock
    end
end

tilt!(plane, rocks, Δ::Tuple) = tilt!(plane, rocks, CartesianIndex(Δ))

function cycle_tilt!(plane, rocks, cycles=1e9)
    dirx = (
        west  = false => (-1,  0),
        south = true  => ( 0,  1),
        east  = true  => ( 1,  0),
        north = false => ( 0, -1),
    )  # sort reverse => direction
    history = Dict{UInt64, Int}()
    ilast = Inf
    for (i, (rev, Δ)) in enumerate(Iterators.cycle(dirx))
        ilast == i && return

        sort!(rocks, rev=rev)
        tilt!(plane, rocks, Δ)
        i % 4 == 0  || continue
        ilast == Inf || continue

        offset = get(history, hash(rocks), nothing)
        if !isnothing(offset)
            ilast = i + (cycles - offset) % (i ÷ 4 - offset) * 4
        end
        history[hash(rocks)] = i ÷ 4
    end
end

function solve(path::String)::Tuple{Int, Int}
    nx, ny = countlines(path), length(readline(path))
    input = collect(UInt8, filter(!isspace, read(path, String)))
    input = reshape(input, nx, ny)
    plane = map(==(Int('#')), input)
    rocks = findall(==(Int('O')), input)

    tilt!(plane, rocks) # north by default
    part1 = sum(xy -> ny + 1 - xy.I[2], rocks)
    cycle_tilt!(plane, rocks, 1e9)
    part2 = sum(xy -> ny + 1 - xy.I[2], rocks)
    return part1, part2
end

@test solve("examples/14.txt") == (136, 64)
@test solve("data/14.txt") == (113424, 96003)
@btime solve("data/14.txt")
