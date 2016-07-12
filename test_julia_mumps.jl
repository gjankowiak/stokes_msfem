import MUMPS
import MPI
MPI.Init()
A = sprand(10, 10, .2) + speye(10); rhs = rand(10);
x = MUMPS.solve(A, rhs);  # Mumps object is created and destroyed
norm(x - A \ rhs) / norm(x)
MPI.Finalize();     # if you're finished
