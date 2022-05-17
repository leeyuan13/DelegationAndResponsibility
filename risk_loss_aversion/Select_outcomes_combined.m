function [outcomes, av_outcome, sel_trials]=Select_outcomes_combined(good_trials)

% Same as Show_outcomes_combined.m, but doesn't display results.

rand_trials = randperm(length(good_trials)); %randomly select 10 trial numbers
sel_trials  = rand_trials(1:10);
outcomes    = zeros(10,1);

for i=1:10

    sel_trial_data = good_trials(sel_trials(i),:);
    sure   = sel_trial_data(1);
    loss   = sel_trial_data(2);
    gain   = sel_trial_data(3);
    choice = sel_trial_data(5);
        
    if choice == 0
        outcomes(i)=sure;
    elseif choice == 1
        r=randperm(2);
        gamb=(r(1));
        if gamb==1 %win
            outcomes(i)=gain;
        elseif gamb==2 %lose
            outcomes(i)=loss;
        end
    end
end


av_outcome = mean(outcomes);

end