function get_lines()::Vector{String}
    f = open("day2/input.txt")
    lines = readlines(f)
    return lines
end

function count_char(s::AbstractString)::Dict{Char,Int64}
    res::Dict{Char,Int64} = Dict()

    for c in s
        if haskey(res, c)
            res[c] += 1
        else
            res[c] = 1
        end
    end
    return res
end

function is_valid_min_max(s::String)::Bool
    if length(s) == 0
        return false
    end

    rule, pass = split(s, ": ", limit=2)
    minmax, char = split(rule, limit=2)
    min, max = parse.(Int64, split(minmax, "-", limit=2))
    char = first(char)
    counts = count_char(pass)
    if haskey(counts, char)
        if min<=counts[char]<=max
            return true
        end
    end
    return false
end

function is_valid_positional(s::String)::Bool
    if length(s) == 0
        return false
    end

    rule, pass = split(s, ": ", limit=2)
    positions, char = split(rule, limit=2)
    positions = parse.(Int64, split(positions, "-", limit=2))
    char = first(char)

    count_matches::Int64 = 0

    for pos in positions
        if pass[pos] == char
            count_matches += 1
        end
    end
    if count_matches == 1
        return true
    else
        return false
    end
end


function main_1()::Int64
    valid_count::Int64 = 0
    lines = get_lines()

    for line in lines
        if is_valid_min_max(line)
            valid_count += 1
        end
    end
    return valid_count
end


function main_2()::Int64
    valid_count::Int64 = 0
    lines = get_lines()

    for line in lines
        if is_valid_positional(line)
            valid_count += 1
        end
    end
    return valid_count
end



@time a = main_1()
@time b = main_2()
println(a)
println(b)
