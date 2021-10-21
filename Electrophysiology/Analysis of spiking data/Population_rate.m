%%population rate for each timebin
figure
for i_trial = 1:7
    pop_rate{i_trial} = sum(synced_spikes{i_trial});
    %pop_rate{i_trial} = smoothdata(pop_rate{i_trial});
    subplot(7,1,i_trial)
    plot(pop_rate{i_trial})
    title(['Trial' num2str(i_trial)])
    axis([0 10800 0 200]);
end
