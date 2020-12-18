using DSP
using BenchmarkTools

function read_input(path, ndims)
    lines = readlines(path)
    n = length(lines)
    dims = ntuple(i -> n, ndims)
    out = Array{Char}(undef, dims)
    fill!(out, '.')
    mid = div(n, 2) + 1
    mid_idx = CartesianIndex(ntuple(i -> mid, ndims - 2))
    for i in 1:n
        for (j, c) in enumerate(lines[i])
            out[i, j, mid_idx] = c
        end
    end
    return out
end


function make_output(cycles, active, start_size, ndims)
    a = cycles * 2
    m = falses(ntuple(i -> start_size + a, ndims))
    r = cycles + 1:cycles + start_size
    m[CartesianIndices(ntuple(i -> r, ndims))] = active
    m
end


function update!(active, kernel, cycles, ndims)
    n = size(active)[1]
    inner = 2:n + 1
    inners = CartesianIndices(ntuple(i -> inner, ndims))
    for j in 1:cycles
        c::Array{Int,ndims} = conv(active, kernel)[inners]
        for i in eachindex(active)
            if active[i] == 1
                if !(c[i] == 2 || c[i] == 3)
                    active[i] = 0
                end
            else
                if c[i] == 3
                    active[i] = 1
                end
            end
        end
    end
    active
end


function conway(m, cycles, ndims)
    active = m .== '#'
    om = make_output(cycles, active, size(m)[1], ndims)
    dims = ntuple(i -> 3, ndims)
    kernel = trues(dims)
    kernel[CartesianIndex(ntuple(i -> 2, ndims))] = 0
    om = update!(om, kernel, cycles, ndims)
    sum(om)
end

function main1(path)
    ndims = 3
    cycles = 6
    m = read_input(path, ndims)
    conway(m, cycles, ndims)
end


function main2(path)
    ndims = 4
    cycles = 6
    m = read_input(path, ndims)
    conway(m, cycles, ndims)
end


main1("day17/input_sample.txt")
@btime main1("day17/input.txt")
@btime main2("day17/input.txt")