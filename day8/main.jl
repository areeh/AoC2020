using DelimitedFiles

opcodes = Dict(
    "nop" => 0,
    "acc" => 1,
    "jmp" => 2,
)

function nop(idx::Int, acc::Int, arg::Int)::Tuple{Int, Int, Int}
    idx += 1
    return idx, acc, arg
end

function acc(idx::Int, acc::Int, arg::Int)::Tuple{Int, Int, Int}
    acc += arg
    idx += 1
    return idx, acc, arg
end

function jmp(idx::Int, acc::Int, arg::Int)::Tuple{Int, Int, Int}
    idx += arg
    return idx, acc, arg
end

ops = Dict(
    0 => nop,
    1 => acc,
    2 => jmp,
)

function read_program(path::String)::Array{Int,2}
    prog = readdlm(path)
    prog[:, 1] = map(x -> opcodes[x], prog[:, 1])
    return prog
end

function run_program_no_loop(prog::Array{Int,2})::Tuple{Int, Set{Int}}
    visited = Set()
    idx = 1
    acc = 0
    while true
        if idx in visited
            return acc, visited
        end
        push!(visited, idx)
        (op, arg) = prog[idx, :]
        idx, acc, arg = ops[op](idx, acc, arg)
        curr_ops = ops[op]
    end
end

function run_program(prog::Array{Int,2})::Int
    idx = 1
    acc = 0
    num_lines = size(prog)[1]
    while idx < num_lines + 1
        (op, arg) = prog[idx, :]
        idx, acc, arg = ops[op](idx, acc, arg)
        curr_ops = ops[op]
    end
    #print("final idx: $idx, num_lines: $num_lines")
    return acc
end

function find_fix(prog::Array{Int,2})::Tuple{Int,Int}
    _, entrances = run_program_no_loop(prog)
    num_lines = size(prog)[1]
    exits = Set(num_lines+1)
    prev_size = 0
    #println("num_lines: $num_lines")
    while prev_size < length(exits)
        prev_size = length(exits)
        for i in 1:num_lines
            (opcode, arg) = prog[i, :]
            
            idx, _, arg = ops[opcode](i, 0, arg)
            if idx in exits
                push!(exits, i)
            end

            if !(i in exits) && i in entrances && opcode != 1
                idx_nop, _, arg_nop = nop(i, 0, arg)
                if idx_nop in exits
                    #println("using op nop to get from $i to path to exit $idx_nop")
                    return opcodes["nop"], i
                end

                idx_jmp, _, arg_jmp = jmp(i, 0, arg)
                if idx_jmp in exits
                    #println("using op jmp to get from $i to path to exit $idx_jmp with arg $arg")
                    return opcodes["jmp"], i
                end
            end
        end
    end
end

function descend(start::Int, jmp_map::Dict{Int,Set{Int}})::Set{Int}
    visited::Set{Int} = Set()
    to_visit::Vector{Int} = [start]
    while !isempty(to_visit)
        i = pop!(to_visit)
        push!(visited, i)
        
        if haskey(jmp_map, i)
            srcs = jmp_map[i]
            append!(to_visit, setdiff(srcs, visited))
        end
    end
    return visited
end

function find_fix_sp(prog::Array{Int,2})::Tuple{Int,Int}
    _, entrances = run_program_no_loop(prog)
    num_lines = size(prog)[1]
    jmp_map::Dict{Int,Set{Int}} = Dict()
    #println("num_lines: $num_lines")
    for i in 1:num_lines
        (opcode, arg) = prog[i, :]
        idx, _, arg = ops[opcode](i, 0, arg)
        if !haskey(jmp_map, idx)
            jmp_map[idx] = Set(i)
        else
            push!(jmp_map[idx], i)
        end
    end
    exits = descend(num_lines+1, jmp_map)
    for i in entrances
        (opcode, arg) = prog[i, :]
        if opcode != 1
            idx_nop, _, arg_nop = nop(i, 0, arg)
            if idx_nop in exits
                #println("using op nop to get from $i to path to exit $idx_nop")
                return opcodes["nop"], i
            end

            idx_jmp, _, arg_jmp = jmp(i, 0, arg)
            if idx_jmp in exits
                #println("using op jmp to get from $i to path to exit $idx_jmp with arg $arg")
                return opcodes["jmp"], i
            end
        end
    end
end

function run_program_repair(prog::Array{Int,2})::Int
    (fix_op, fix_idx) = find_fix(prog)
    #println("fix op: $fix_op, fix_idx: $fix_idx")
    prog[fix_idx, 1] = fix_op 
    run_program(prog)
end

function run_program_repair_sp(prog::Array{Int,2})::Int
    (fix_op, fix_idx) = find_fix_sp(prog)
    #println("fix op: $fix_op, fix_idx: $fix_idx")
    prog[fix_idx, 1] = fix_op 
    run_program(prog)
end

function main_sample()
    prog = read_program("day8/input_sample.txt")
    run_program_no_loop(prog)
end

function main()
    prog = read_program("day8/input.txt")
    run_program_no_loop(prog)
end

function main2_sample()
    prog = read_program("day8/input_sample.txt")
    acc = run_program_repair(prog)
end

function main2()
    prog = read_program("day8/input.txt")
    run_program_repair(prog)
end

function main2_sp()
    prog = read_program("day8/input.txt")
    run_program_repair_sp(prog)
end

@time main_sample()
@time main()
@time main2_sample()

@time main2_sp()

println("timings")
@time main2_sp()
@time main2_sp()
@time main2_sp()
@time main2_sp()
@time main2()
@time main2()
@time main2()
@time main2()