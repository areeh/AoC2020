using BenchmarkTools
using Underscores

const action_to_int = Dict(
    'N' => 1,
    'E' => 2,
    'S' => 3,
    'W' => 4,
    'L' => 5,
    'R' => 6,
    'F' => 7,
)

const directions = [
    (-1, 0), 
    (0, 1), 
    (1, 0), 
    (0, -1),
]

const sin = Dict(
    90 => 1,
    180 => 0,
    270 => -1,
)

const cos = Dict(
    90 => 0,
    180 => -1,
    270 => 0,
)


function read_input(path::String)
    @_ map((action_to_int[_[1]], parse(Int, _[2:end])), readlines(path))
end

function forward(val::Int, rot_id::Int, pos::Tuple{Int,Int})::Tuple{Int,Int}
    pos = pos .+ (directions[rot_id] .* val)
end

function forward(val::Int, bp::Tuple{Int,Int}, wp::Tuple{Int,Int})::Tuple{Int,Int}
    bp = bp .+ (wp .* val)
end


function rotate(val::Int, rot_id::Int, d::Int)::Int
    rot_val = mod(div(val, 90), 4)
    rot_val *= d
    new_rot_id = mod1(rot_id + rot_val, 4)
end

function rotate(wp::Tuple{Int,Int}, val::Int, d::Int)::Tuple{Int,Int}
    rot = mod1(val, 360)
    if d == -1 rot = 360 - rot end

    (wy, wx) = wp
    nx = cos[rot] * wx - sin[rot] * wy
    ny = sin[rot] * wx + cos[rot] * wy
    return ny, nx
end

function main1(path::String="day12/input.txt")
    actions = read_input(path)
    facing::Int = 2
    pos = (0, 0)
    for a in actions
        if 1 <= a[1] <= 4
            pos = forward(a[2], a[1], pos)
        elseif a[1] == 5
            facing = rotate(a[2], facing, -1)
        elseif a[1] == 6
            facing = rotate(a[2], facing, 1)
        elseif a[1] == 7
            pos = forward(a[2], facing, pos)
        end
    end
    # display(pos)
    return sum(abs.(pos))
end

function main2(path::String="day12/input.txt")
    actions = read_input(path)
    bp = (0, 0)
    wp = (-1, 10)
    for a in actions
        if 1 <= a[1] <= 4
            wp = forward(a[2], a[1], wp)
        elseif a[1] == 5
            wp = rotate(wp, a[2], -1)
        elseif a[1] == 6
            wp = rotate(wp, a[2], 1)
        elseif a[1] == 7
            bp = forward(a[2], bp, wp)
        end
    end
    # display(bp)
    return sum(abs.(bp))
end

println(main1("day12/input_sample.txt"))
println(@btime main1())
println(main2("day12/input_sample.txt"))
println(@btime main2())

