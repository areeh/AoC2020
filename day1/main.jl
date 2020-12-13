num_iter = 5000

function get_numbers()::Vector{Int32}
    f = open("day1/input.txt")
    lines = readlines(f)
    numbers::Vector{Int32} = parse.(Int32, lines)
    return numbers
end


function bin_last(v::Vector{Int32}, x::Int32)
    index = searchsortedlast(v, x)
    if index > lastindex(v) || v[index] != x
        return 0
    else
        return index
    end
end

function twosum_search(target::Int32, numbers::Vector{Int32})::Int32
    numbers = sort!(numbers)
    for i in eachindex(numbers)
        index = bin_last(numbers, target-numbers[i])
        if index > 0
            return numbers[i] * numbers[index]
        end
    end
end

function twosum_shrink_iter(target::Int32, numbers::Vector{Int32})::Int32
    for i in eachindex(numbers)
        for j in eachindex(reverse(numbers))
            if numbers[i] + numbers[j] == target
                return numbers[i]*numbers[j]
            end
        end
    end
end

function twosum_lookup(target::Int32, numbers::Vector{Int32})::Int32
    d::Dict{Int32,Int32} = Dict()
    for i in eachindex(numbers)
        res = target - numbers[i]
        if haskey(d, res)
            return res*numbers[i]
        else
            d[numbers[i]] = i
        end
    end
end

function threesum_lookup(target::Int32, numbers::Vector{Int32})::Int32
    d::Dict{Int32,Int32} = Dict()
    for i in eachindex(numbers)
        for j in eachindex(numbers)
            res = target - numbers[i] - numbers[j]
            if haskey(d, res)
                return res*numbers[i]*numbers[j]
            else
                d[numbers[i]] = i
            end
        end
    end
end

function threesum_brute(target::Int32, numbers::Vector{Int32})::Int32
    for num1 in numbers
        for num2 in numbers
            for num3 in numbers
                if num1+num2+num3 == target
                    return num1*num2*num3
                end
            end
        end
    end
end


function bench_twosum_search()
    numbers = get_numbers()
    target::Int32 = 2020

    for i in 1:num_iter
        twosum_search(target, numbers)
    end
end

function bench_twosum_shrink_iter()
    numbers = get_numbers()
    target::Int32 = 2020

    for i in 1:num_iter
        twosum_shrink_iter(target, numbers)
    end
end

function bench_twosum_lookup()
    numbers = get_numbers()
    target::Int32 = 2020

    for i in 1:num_iter
        twosum_lookup(target, numbers)
    end
end

function bench_threesum_brute()
    numbers = get_numbers()
    target::Int32 = 2020

    for i in 1:num_iter
        threesum_brute(target, numbers)
    end
end

function bench_threesum_lookup()
    numbers = get_numbers()
    target::Int32 = 2020

    for i in 1:num_iter
        threesum_lookup(target, numbers)
    end
end

function print_results()
    numbers = get_numbers()
    target::Int32 = 2020

    println(twosum_search(target, numbers))
    println(twosum_shrink_iter(target, numbers))
    println(twosum_lookup(target, numbers))
    println(threesum_brute(target, numbers))
    println(threesum_lookup(target, numbers))
end


@time bench_twosum_search()
@time bench_twosum_shrink_iter()
@time bench_twosum_lookup()
@time bench_threesum_brute()
@time bench_threesum_lookup()

print_results()


