%%simulation
t = 1:1:7560;
f = 0.0006;
a = 4;
simulation_var = a*sin(2*pi*f*t);

[IT_matrix, var_entropy] = Mutual_information_analysis(simulation_var, binned_spikes(301,:), 10,10)