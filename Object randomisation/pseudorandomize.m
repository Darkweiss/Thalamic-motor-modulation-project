function[schedule] = pseudorandomize(n_days,n_trials)
%%% returns orders of numbers that never repeat 
schedule = zeros(n_days,n_trials);
trial = 1:n_trials;
schedule(1,:) = trial(randperm(length(trial)));
for i = 2:n_days
    equal = 1;
    while equal
        schedule(i,:) = trial(randperm(length(trial)));
        for n = 1:(i-1)
           if isequal(schedule(i,:), schedule(n,:))
               equal = 1;
               break
           else
               equal = 0;
           end
        end
        if equal == 0
            break
        end
    end
end
end