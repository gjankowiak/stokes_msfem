#!/home/gjankowiak/tmp/julia-0.4.2/julia

println("welcome to juliasolve")

include("julia_freefem_io.jl")

println("IO routines imported")

if length(ARGS) < 3
    println("Usage: juliasolve.jl A.txt b.txt x.txt")
    println
    println("A.txt: Freefem text file holding a sparse matrix")
    println("b.txt: Freefem text file holding a compatible vector")
    println("x.txt: destination file for the solution of A x = b,")
    println("       will be written in Freefem format")
    exit(1)
end

println("Reading matrix (", ARGS[1], ")")
A = ff2julia_mat(ARGS[1]);

println("Reading right hand side (", ARGS[2], ")")
b = ff2julia_vec(ARGS[2]);

println("Solving")
x_julia = A\b;

println("Dumping result")
dump2ff_vec(ARGS[3], x_julia)

println("Done and done")
