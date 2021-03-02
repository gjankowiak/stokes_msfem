import Printf:@printf
import DelimitedFiles:readdlm
import SparseArrays:sparse

function ff2julia_mat(filename)
    f = open(filename)
    readline(f)
    readline(f)
    meta = split(readline(f), ' ')
    n, m = parse(Int, meta[1]), parse(Int, meta[2])
    println("n:", n, ", m:", m)
    x = readdlm(f)
    I, J, V = convert(Array{Int64,1}, x[:,1]) .+ 1, convert(Array{Int64,1}, x[:,2]) .+ 1, x[:,3]
    println("min/max I: ", extrema(I))
    println("min/max J: ", extrema(J))
    return sparse(I, J, V, m, n)
end

function parse_line(l::String, T=Float64)
    return map(x -> parse(T, x), filter!(x -> x != "", split(l, "\t")))
end

function ff2julia_vec(filename)
    println("Opening ", filename)
    f = open(filename)
    print("Parsing size... ")
    firstline = readline(f)
    n = parse(Int, firstline)
    println(n)
    println("Reading data")

    res = Array{Float64, 1}(undef, n)
    d, r = divrem(n, 5)

    for i in 1:d
        l = readline(f)
        res[(i-1)*5 + 1:i*5] = parse_line(l)
    end

    println("tail...")
    if r > 0
        res[d*5+1:n] = parse_line(readline(f))
    end
    println("done")
    return res;
end

function dump2ff_vec(filename, v)
    f = open(filename, "w")
    @printf(f, "%d\n", length(v))
    d, r = divrem(length(v), 5)
    for i in 1:d
        @printf(f, "\t%.10g\t%.10g\t%.10g\t%.10g\t%.10g\n", v[(i-1)*5+1:(i-1)*5+5]...)
    end
    for i in 1:r
        if i == 1
            @printf(f, "\t")
        end
        @printf(f, "%.10g\t", v[d*5+i])
    end
    @printf(f, "\n")
    close(f)
end
