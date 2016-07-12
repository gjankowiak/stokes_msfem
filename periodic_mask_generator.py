# coding: utf-8
from __future__ import division

Lx, Ly = 2.0, 1.0
eps = 5e-2
factor = int(Ly/eps)
factor += 1&factor
eps = 1/factor

print("Adjusted epsilon: {0}".format(eps))

r = 0.125/2

ny = factor
nx = ny

padding = Ly/(2*ny)

x_min, x_max = (Lx-Ly)/2, (Lx+Ly)/2

# s = ""
# for i in range(nx):
    # x = x_min + (2*i+1)*padding
    # for j in range(ny):

        # y = (2*j+1)*padding

        # hole_cond = "(((X-{0})^2 + (Y-{1})^2) < radiusfactor*{2})".format(x,y,r*r)

        # if not s:
            # s += "func bat = "+hole_cond
        # else:
            # s += " || "+hole_cond

# s += ";\n"

s = """func bat = (X > {0} && X < {1} && (({2}*X-int({2}*X)-0.5)*({2}*X-int({2}*X)-0.5)
     + ({2}*Y-int({2}*Y)-0.5)*({2}*Y-int({2}*Y)-0.5)) < {3}*{3});""".format(x_min, x_max, factor, r)

open("periodic_holes.edp", "w").write(s)
