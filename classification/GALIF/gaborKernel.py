import numpy
import math
import matplotlib.pyplot as plt
import scipy.io

line_width  = 0.01
lamb        = 0.1
w           = 0.13

sigma_x = line_width * w
sigma_y = sigma_x / lamb

num_thetas = 8

thetas = numpy.linspace(0, math.pi, num_thetas + 1)
filter_path = "F:\\gabor\\kernel\\"
for theta_index in range(num_thetas):

    theta = thetas[theta_index]
    
    R = numpy.array([[math.cos(theta), -math.sin(theta)], [math.sin(theta), math.cos(theta)]])
    
    u = numpy.arange(-100, 100)
    v = numpy.arange(-100, 100)
    
    (U, V) = numpy.meshgrid(u, v)
    
    U_theta = (U * R[0,0]) + (V * R[0,1])
    V_theta = (U * R[1,0]) + (V * R[1,1])
    
    g = numpy.exp(-2*(math.pi**2)*((U_theta - w)**2*(sigma_x**2) + (V_theta**2)*(sigma_y**2)))

    scipy.io.savemat("%stheta=%02d.mat" % (filter_path, theta_index), {"g":g}, oned_as="column")

    #clf();
    #plt.imshow(g, interpolation="nearest");
    #plt.show()
    #colorbar();
    #savefig("%stheta=%02d.png" % (debug_path, theta_index));
    #clf();
