println("welcome to juliacompare")

if VERSION.major > 0
    import LinearAlgebra
    norm = LinearAlgebra.norm
end

include("julia_freefem_io.jl")

println("IO routines imported")

if length(ARGS) < 2
    println("Usage: julia_compare.jl x1.txt x2.txt")
    println
    println("x1.txt, x2.txt: Freefem text file holding vectors to be compared")
    exit(1)
end

println("Reading x1 (", ARGS[1], ")")
x1 = ff2julia_vec(ARGS[1]);

println("Reading x2 (", ARGS[1], ")")
x2 = ff2julia_vec(ARGS[2]);

err = norm(x1 - x2)
rel_err = err/norm(x1)

println("|x1 - x2|₂ = ", err)
println("|x1 - x2|₂/|x1|₂ = ", rel_err)

println("Done and done")
