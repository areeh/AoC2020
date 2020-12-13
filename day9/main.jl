using DelimitedFiles
using BenchmarkTools

function read_numbers(path::String="day9/input.txt")::Array{Int,1}
    arr = readdlm(path)[:]
end

function read_sample()::Array{Int,1}
    read_numbers("day9/input_sample.txt")
end

function first_not_valid(arr::Array{Int,1}, preamble_size::Int=25)::Int
    window = sort!(arr[1:preamble_size])
    for i in preamble_size+1:length(arr)
        new = arr[i]

        left_i = 1
        right_i = preamble_size

        valid = false
        while left_i < right_i
            left = window[left_i]
            right = window[right_i]
            s = left+right
            if new == s
                valid = true
                break
            elseif new < s
                right_i -= 1
            elseif new > s
                left_i += 1
            end
        end

        if valid
            new_loc = searchsortedfirst(window, new)
            insert!(window, new_loc, new)
            
            old = arr[i - preamble_size]
            old_loc = searchsortedfirst(window, old)
            deleteat!(window, old_loc)
        else
            return new
        end
    end
end

function first_not_valid_memo(arr::Array{Int,1}, preamble_size::Int=25)::Int
    window_memo::Dict{Int,Int} = Dict()
    for v in arr[1:preamble_size]
        if haskey(window_memo, v)
            window_memo[v] += 1
        else
            window_memo[v] = 1
        end
    end

    for i in preamble_size+1:length(arr)
        new = arr[i]

        valid = false
        for num in keys(window_memo)
            if haskey(window_memo, new - num) && !(new-num==num)
                valid = true
                if haskey(window_memo, new)
                    window_memo[new] += 1
                else
                    window_memo[new] = 1
                end
                old = arr[i - preamble_size]
                window_memo[old] -= 1
                if window_memo[old] == 0
                    delete!(window_memo, old)
                end
                break
            end
        end
        if !valid
            return new
        end
    end
end

function cont_sum(arr::Array{Int,1},target::Int=18272118)
    tail = 1
    head = 2
    s = arr[tail]+arr[head]
    while s != target
        if s < target
            head += 1
            s += arr[head]
        elseif s > target
            s -= arr[tail]
            tail += 1
        end
    end
    return minimum(arr[tail:head]) + maximum(arr[tail:head])
end

function main1_sample()
    numbers = read_sample()
    num = first_not_valid(numbers, 5)
    #println(num)
end

function main1()
    numbers = read_numbers()
    num = first_not_valid(numbers)
    #println(num)
end

function main1_memo()
    numbers = read_numbers()
    num = first_not_valid_memo(numbers)
    #println(num)
end

function main2_sample()
    numbers = read_sample()
    cont_sum(numbers, 127)
end

function main2()
    numbers = read_numbers()
    cont_sum(numbers)
end

@btime main1_sample()
@btime main1()
@btime main1_memo()
@btime main2_sample()
@btime main2()