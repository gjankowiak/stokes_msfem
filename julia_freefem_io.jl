function ff2julia_mat(filename)
    f = open(filename)
    readline(f)
    readline(f)
    readline(f)
    meta = split(readline(f), ' ')
    n, m = parse(Int, meta[1]), parse(Int, meta[2])
    x = readdlm(f)
    I, J, V = convert(Array{Int64,1}, x[:,1]), convert(Array{Int64,1}, x[:,2]), x[:,3]
    return sparse(I, J, V, m, n)
end

function ff2julia_vec(filename)
    println("Opening ", filename)
    f = open(filename)
    println("Parsing size")
    firstline = readline(f)
    println("-", firstline, "-")
    n = parse(Int, firstline)
    println("Reading data")
    x = readdlm(f)
    println("Read file, converting")
    res = Array{Float64, 1}(n)
    d, r = divrem(n, 5)
    i = 0
    for i in 1:d
        res[(i-1)*5 + 1:i*5] = x[i,:]
    end
    println("tail...")
    res[i*5+1:n] = x[i*5+1:n]
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
