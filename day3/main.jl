function read_chars()::Array{Char,2}
    lines = map(collect, readlines("day3/input.txt"))
    arr = permutedims(hcat(lines...))
    return arr
end

function count_char(char::Char, arr::Array{Char,2}, step_row::Int64, step_col::Int64)::Int64
    count = 0
    (rows, cols) = size(arr)

    i = 1
    j = 1
    while i < rows
        i += step_row
        j += step_col
        if arr[i,mod1(j, cols)] == char
            count += 1
        end
    end
    return count
end


function main1()::Int64
    map = read_chars()
    step_row = 1
    step_col = 3
    tree_count = count_char('#', map, step_row, step_col)

    return tree_count
end

function main2()::Int64
    map = read_chars()

    routes = [(1, 1), (1, 3), (1, 5), (1, 7), (2, 1)]

    acc = 1
    for (step_row, step_col) in routes
        acc *= count_char('#', map, step_row, step_col)
    end
    return acc
end


@time main1()
@time main2()