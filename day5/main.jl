using PrettyPrinting

function get_passes(path::String)::Vector{String}
    passes = readlines(path)
    return passes
end

function get_sample()
    return get_passes("day5/input_sample.txt")
end

function get_input()
    return get_passes("day5/input.txt")
end

decode_map = Dict(
    'F' => '0',
    'B' => '1',
    'L' => '0',
    'R' => '1',
)

function decode_char(c::Char)::Char
    decode_map[c]
end

function decode_pass(s::String)::Tuple{Int,Int,Int}
    s2 = map(decode_char, s)
    row = parse(Int, s2[1:7], base=2)
    col = parse(Int, s2[8:10], base=2)
    id = parse(Int, s2, base=2)
    return row, col, id
end

function main_sample()::Vector{Tuple{Int,Int,Int}}
    passes = get_sample()
    out::Vector{Tuple{Int,Int,Int}} = []
    max::Int = -1
    for pass in passes
        println("Pass: $pass")
        (row, col, id) = decode_pass(pass)
        println("Row: $row")
        println("Col: $col")
        println("id: $id")
        push!(out, (row, col, id))
        if id > max
            max = id
        end
    end
    println("Passes for sample: ")
    pprint(out)
    println()
    println("Max seat ID: $max")
    return out
end


function main()::Int
    passes = get_input()
    out::Vector{Tuple{Int,Int,Int}} = []
    max::Int = -1
    for pass in passes
        (_, _, id) = decode_pass(pass)
        if id > max
            max = id
        end
    end
    println("Max seat ID: $max")
    return max
end

function main2()::Int
    passes = get_input()

    prev = 0
    curr = 0

    ids = [id for (_, _, id)=map(decode_pass, passes)]

    ids = sort!(ids)
    for id in ids
        prev = curr
        curr = id

        if curr - prev == 2
            if curr == 2
                continue
            end
            println(curr-1)
            return curr-1
        end
    end
end


@time main_sample()
@time main()
@time main2()