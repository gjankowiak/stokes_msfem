# coding: utf-8
from __future__ import division, print_function
from numpy import random, arctan

pi = 3.14151926

x_min, x_max = 0.04, 1.96
y_min, y_max = 0.02, 0.98
r_min, r_max = 0.0125, 0.05

scale_w = 1
scale_h = 1

n_holes = 20

s = ""
for n in range(n_holes):
    x = (random.rand()*(x_max - x_min)+x_min)*scale_w
    y = (random.rand()*(y_max - y_min)+y_min)*scale_h
    if r_min == r_max:
        r = r_min
    else:
        r = (random.uniform(0, 1)**3*(r_max - r_min)+r_min)*min(scale_w, scale_h)

    [x, y, r] = map(lambda c:round(c,4), [x, y, r])

    hole_cond = "(((X-{0})^2 + (Y-{1})^2) < radiusfactor*{2})".format(x,y,r*r)

    if not s:
        s += "func bat = "+hole_cond
    else:
        s += " || "+hole_cond

s += ";\n"

open("holes.edp", "w").write(s)
