using DSP
using BenchmarkTools
using Underscores

function read_input(path::String="day11/input.txt")
    lines = readlines(path)
    (n, m) = length(lines), length(lines[1])
    out = Matrix{Char}(undef, n, m)
    for i in 1:n
        for (j, c) in enumerate(lines[i])
            out[i, j] = c
        end
    end
    return out
end

function update!(not_floors::BitArray{2}, occupied::BitArray{2}, kernel::BitArray{2})::Array{Int8,2}    
    prev = similar(occupied)
    i = 0
    while prev != occupied
        i += 1
        copyto!(prev, occupied)
        changes::Array{Int8,2} = conv2(occupied, kernel)[2:end - 1, 2:end - 1]
        for i in eachindex(occupied)
            if changes[i] == zero(Int8)
                occupied[i] = 1
            elseif changes[i] >= 4
                occupied[i] = 0
            end
        end
        occupied = occupied .* not_floors
    end
    return occupied
end

function enumerate_seen_seats(A::Array{Int8,2})::Dict{CartesianIndex{2},Vector{CartesianIndex{2}}}
    seen_seats::Dict{CartesianIndex{2},Vector{CartesianIndex{2}}} = Dict()
    directions = [CartesianIndex((i, j)) for (i, j) in [(1, 1), (0, 1), (1, 0), (-1, -1), (-1, 0), (0, -1), (1, -1), (-1, 1)]]
    R = CartesianIndices(A)
    Ifirst, Ilast = first(R), last(R)
    for I in R
        if A[I] != 0
            seen_curr = []
            for d in directions
                for i in 1:Ilast[1]
                    idx = I + i * d
                    if Ifirst[1] <= idx[1] <= Ilast[1] && Ifirst[2] <= idx[2] <= Ilast[2]
                        @inbounds if A[idx] == one(Int8)
                            push!(seen_curr, idx)
                            break
                        end
                    else
                        break
                    end
                end
            end 
            seen_seats[I] = seen_curr
        end
    end
    seen_seats
end

function update!(seats::Array{Int8,2})::Array{Int8,2}
    R = CartesianIndices(seats)
    seen_seats = enumerate_seen_seats(seats)
    prev = similar(seats)
    while seats != prev
        copyto!(prev, seats)
        for i in keys(seen_seats)
            @inbounds occupants = sum(prev[seen_seats[i]] .== 2)
            if occupants == zero(Int8)
                seats[i] = 2
            elseif occupants >= 5
                seats[i] = one(Int8)
            end
        end
    end
    return seats
end

function count_seats(seats)::Int
    not_floors = seats .!= '.'
    occupied = seats .== '#'
    kernel = trues(3, 3)
    kernel[2, 2] = 0
    occupied = update!(not_floors, occupied, kernel)
    for i in eachindex(seats)
        if occupied[i] == one(Int8)
            seats[i] = '#'
        end
    end
    # display(seats)
    return sum(occupied)
end

function count_seats_2(seats)::Int
    seat_to_int::Dict{Char,Int8} = Dict('.' => 0, 'L' => 1, '#' => 2)
    seats_int::Array{Int8,2} = @_ map(seat_to_int[_], seats)
    seats_int = update!(seats_int)
    # display(seats_int)
    return sum(seats_int .== 2)
end

function main1(path)
    seats = read_input(path)
    count_seats(seats)
end

function main2(path)
    seats = read_input(path)
    count_seats_2(seats)
end

main1("day11/input_sample.txt")
@btime main1("day11/input.txt")
main2("day11/input_sample.txt")
@btime main2("day11/input.txt")