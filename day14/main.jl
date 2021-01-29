using BenchmarkTools
using Underscores

const n_bits = 36

function make_masks(s)
    one_mask = falses(n_bits)
    one_mask[findall(isequal('1'), s)] .= 1
    zero_mask = falses(n_bits) 
    zero_mask[findall(isequal('0'), s)] .= 1
    (one_mask = reverse(one_mask), zero_mask = reverse(zero_mask))
end


function make_combinations(n)
    """All combinations of n 0s, 1s with replacement"""
    reverse.(Iterators.product(fill(0:2 - 1, n)...))[:]
end

function make_masks2(s)
    one_mask = falses(n_bits)
    one_mask[findall(isequal('1'), s)] .= 1
    xs = findall(isequal('X'), s)
    var_mask = falses(n_bits)
    var_mask[xs] .= 1
    variations = make_combinations(length(xs))
    (one_mask = reverse(one_mask), var_mask = reverse(var_mask), variations = variations)
end

function to_int(A::Array{Bool,1})
    sum([A[k] * 2^(k - 1) for k = 1:length(A)])
end


function main1(path)
    lines = readlines(path)
    memory::Dict{Int,Int} = Dict()
    m = nothing
    for l in lines
        (typ, _, val) = split(l)
        if typ == "mask"
            m = make_masks(val)
        else
            i = @_ typ |> split(__, ('[', ']')) |> parse(Int, __[2])
            v = @_ val |> parse(Int, __) |> digits(Bool, __, base=2, pad=n_bits)
            v[m.one_mask] .= 1
            v[m.zero_mask] .= 0
            memory[i] = to_int(v)
        end
    end
    sum(values(memory))
end


function main2(path)
    lines = readlines(path)
    memory::Dict{Int,Int} = Dict()
    m = nothing
    for l in lines
        (typ, _, val) = split(l)
        if typ == "mask"
            m = make_masks2(val)
        else
            i = @_ typ |> split(__, ('[', ']')) |> parse(Int, __[2]) |> digits(Bool, __, base=2, pad=n_bits)
            v = parse(Int, val)
            i[m.one_mask] .= 1
            
            for var in m.variations
                i[m.var_mask] = BitArray(var)
                memory[to_int(i)] = v
            end
        end
    end
    sum(values(memory))
end

@btime main1("day14/input.txt")
@btime main2("day14/input.txt")
