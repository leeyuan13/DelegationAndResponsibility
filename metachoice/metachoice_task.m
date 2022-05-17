function DATA = metachoice_task(subNo,gender,age,program)
% Script for an experiment to measure the intrinsic value of decision rights.
% This experiment replicates and extends that in
%  Bobadilla-Suarez, Sunstein and Sharot (2017). "The intrinsic value of
%  choice: The propensity to under-delegate in the face of potential gains 
%  and losses." Journal of Risk and Uncertainty, 54(3), 187-202.

% Based on a script written by Sebastian Bobadilla-Suarez.
% In turn loosely based on a script from Benedetto De Martino & Steve
% Fleming.

% Requires the cogent package, visang.m (not our code), experts4.m, & the stimuli 

% Modified by:
%  Yuan Lee
%  May 2022

addpath(genpath(cd));
fprintf('Configuring Cogent and setting up experiment parameters...\n');
rng(sum(100*clock));

%% Demographics
DATA.params.subNo = subNo;
DATA.params.age = age;
DATA.params.gender = gender;
DATA.params.program = program;

if randi(2)==1 % alternatively, if subNo is even start with rewards
    rewardFirst_prac = 1; 
    rewardSecond_prac = -1;
else
    rewardFirst_prac = -1; 
    rewardSecond_prac = 1;
end

% Number of testing (i.e. non-learning) stages.
DATA.numTestStages = 1;
% Decide order of blocks.
% Gains / loss / treatment type (0 = control, 1,2 = treatment).
% Either randomly assign treatment, ...
% type_perm = reshape(randperm(3), 3, 1) - 1;
% Or assign treatment based on randomly assigned subject numbers.
type_perm = rem(str2double(subNo), 3);
gl_perm = randi(2, DATA.numTestStages, 1)*2-3;
DATA.block_order = [gl_perm, -gl_perm, type_perm(1:DATA.numTestStages)];
% Example: if block_order is
%       [1 -1 2; -1 1 0]
% this means that in the first testing stage, the subject will do treatment
% 2 with the gain block first, and in the second testing stage, the subject
% will do the control with the loss block first.

DATA.reward_val = 1000; % reward/loss on every trial, 10 euros = 1000 p

DATA.params.scrdist_mm = 750; % default to this distance if left blank
DATA.params.scrwidth = 520; % screen width in mm? need to be measured
DATA.params.scrwidth_deg = visang(DATA.params.scrdist_mm, [], DATA.params.scrwidth); % horizontal screen dimension in degrees
DATA.params.pixperdeg = 1600/DATA.params.scrwidth_deg; % assuming a resolution of 1280 pixels CHECK THIS!!

%% Cogent configuration
% Display parameters.
% TODO: adjust fullscreen, set screen resolution
% If using fullscreen, make sure the screen is set to the appropriate 
% resolution (e.g. 5 = 1280 x 1024).
screenMode = 0;                 % 0 for small window, 1 for full screen, 2 for second screen if attached
screenRes = 4;                  % screen resolution
white = [1 1 1];                % foreground colour
black = [0 0 0];                % background colour
red = [1 0 0];
fontName = 'Arial';         % font parameters
fontSize = 32;
DATA.fontSize = fontSize;
number_of_buffers = 20;          % how many offscreen buffers to create

% Set up cogent environment, before starting cogent.
% Open graphics window.
config_display(screenMode, screenRes, white, black, fontName, fontSize, number_of_buffers);
% Alternative:
% config_display(screenMode, screenRes, black, white, fontName, fontSize, number_of_buffers);

% Collect keyboard responses.
config_keyboard(100, 5, 'nonexclusive');

% Set cogent up to log events.
% Log will be saved at 'Cogent-YYYY-MMDD-HH-MM-SS.log'.
config_log;

%% Store parameters
DATA.keys.left = 26;
DATA.keys.right = 24;
DATA.keys.you = 25;
DATA.keys.advisor = 1;
DATA.keys.next = 14;
DATA.keys.back = 2;
DATA.keys.enter = 59;
DATA.keys.backspace = 55;

DATA.times.confirm = 1000;
DATA.times.fix = 500;
DATA.times.choice = inf; % 2 second response time deadline, now changed to inf
DATA.times.wait = 5000; % minimum wait time

% A block can be a gain block or a loss block in any given stage.
% The block length must be an even number.
DATA.params.numBlocks = 2*(DATA.numTestStages+1);
DATA.params.blockLength = 30; % change for debugging, max 60
% Number of trials.
DATA.params.alltrials = DATA.params.blockLength*DATA.params.numBlocks; 
% Two stimuli per trial.
DATA.params.randStim = randperm(DATA.params.alltrials*2);
DATA.params.randStim = reshape(DATA.params.randStim,DATA.params.blockLength,DATA.params.numBlocks*2);

% In which of the learning rounds will the player win?
prac1wins = [zeros(DATA.params.blockLength/2, 1); ones(DATA.params.blockLength/2, 1)];
prac1wins = prac1wins(randperm(length(prac1wins)));
prac2wins = [zeros(DATA.params.blockLength/2, 1); ones(DATA.params.blockLength/2, 1)];
prac2wins = prac2wins(randperm(length(prac2wins)));
DATA.params.pracwins = [prac1wins, prac2wins];
% No need to choose winning rounds in the non-learning stage.
% For the non-learning rounds, choose in real time.

% Generate expert accuracies and costs.
% 4 is the minimum for experts4 function.
[ DATA.params.experts_test1, DATA.params.expertsEV_test1 ] = experts4( DATA.params.blockLength);
[ DATA.params.experts_test2, DATA.params.expertsEV_test2 ] = experts4( DATA.params.blockLength);

%% Save payoffs in array
% In each block, select a sample of trials and average the payoffs from the
% sample.
% Append that average payoff to the following array.
DATA.samples.sampled_payoffs = [];
% Number of trials to select per block.
DATA.samples.samplesPerBlock = min(10, DATA.params.blockLength);

%% Start cogent
start_cogent;

%% Introduction

preparestring('Experiment instructions:',1,0,340);
preparestring('Thank you for agreeing to participate in this experiment!',1,0,290);
preparestring('You will be compensated based on the rewards (or losses) ',1,0,250);
preparestring('you accumulate in the experiment.',1,0,210);
preparestring('The first part of the experiment has 4 sessions and should ',1,0,170);
preparestring('take approximately twenty minutes.',1,0,130);
preparestring('- PRESS ANY KEY TO CONTINUE -',1,0,-380);

drawpict(1);
clearpict(1);
clearpict;

waitkeydown(inf);

%% Learning stage

% Two blocks for the learning stage, with similar structure.
for j = 1:2

    DATA.training = 1;
    DATA.treatment_type = 0;

    if j == 1
        DATA.trialList = DATA.params.randStim(:,1:2);
        DATA.reward_prac = rewardFirst_prac;
        DATA.roundNum = [0, 1]; % [stage, block]
        DATA.prac_wins = DATA.params.pracwins(:, 1);
    elseif j == 2
        DATA.trialList = DATA.params.randStim(:,3:4);
        DATA.reward_prac = rewardSecond_prac;
        DATA.roundNum = [0, 2];
        DATA.prac_wins = DATA.params.pracwins(:, 2);
    end

    % Instructions.
    preparestring('On each trial two figures will appear simultaneously on the screen, e.g.:',1,0,360);
    loadpict('practice_stim9s.bmp',1,-200,220); loadpict('practice_stim13s.bmp',1,200,220);
    preparestring('Every pair of figures will be different on every trial. ',1,0,70);
    if (rewardFirst_prac == 1 && j == 1) || (rewardSecond_prac == 1 && j == 2)
        preparestring('Your task is to find patterns that may make some figures more likely to WIN you money.',1,0,-30);
        preparestring('For each pair, one of the figures, but not the other, can WIN you 10 euros.',1,0,-80);
        preparestring('Your task is to try and select the WINNING figure by',1,0,-130);
    else
        preparestring('Your task is to find patterns that may make some figures more likely to LOSE you money.',1,0,-30);
        preparestring('For each pair, one of the figures, but not the other, can LOSE you 10 euros.',1,0,-80);
        preparestring('Your task is to try and select the figure that AVOIDS LOSING by',1,0,-130);
    end
    preparestring('pressing the "Z" key to select the symbol on the left,', 1, 0, -180);
    preparestring('and the "X" key to select the symbol on the right.',1,0,-230);
    preparestring('At the end of the experiment we will sample 10 trials at random',1,0,-280);
    preparestring('and your earnings will be the average of these trials.',1,0,-330);
    preparestring('- PRESS ANY KEY TO CONTINUE -',1,0,-380);
    drawpict(1);
    waitkeydown(inf);
    clearpict(1);
    clearpict;
    
    if (rewardFirst_prac == 1 && j == 1) || (rewardSecond_prac == 1 && j == 2)
        preparestring('Try to pick the symbol that you find to have the highest chance of WINNING',1,0,50);
    else
        preparestring('Try to pick the symbol that you find to have the highest chance of NOT LOSING',1,0,50);
    end
    preparestring('in order to maximize your earnings.',1,0,0);
    preparestring('At first you may be confused, but don''t worry, you''ll have plenty of practice!',1,0,-50);
    preparestring('- PRESS ANY KEY TO START -',1,0,-350);
    drawpict(1);
    waitkeydown(inf);
    clearpict(1);
    clearpict;
    
    DATA = runTrials(DATA);
    datafile = sprintf('metachoiceTask_sub%s_trainBlock%d', subNo, j);
    save(['data\Sub' subNo '\' datafile],'DATA');
    fprintf('Data saved in %s\n',datafile);

end

%% Testing stage

clearpict;

preparestring('End of the training phase. Well done!',1,0,0);
preparestring('- PRESS ANY KEY TO CONTINUE -', 1, 0, -350);
drawpict(1);
waitkeydown(inf);
clearpict(1);
clearpict;

% As before, there are two blocks per stage.
for stageNum = 1:DATA.numTestStages
    DATA.training = 0;
    DATA.treatment_type = DATA.block_order(stageNum, 3);
    if DATA.treatment_type == 0 % control
        preparestring('The task is the same as for the training sessions with two differences:',1,0,200);
        preparestring('1. You have the option to select the figure yourself out of the pair,',1,0,100)
        preparestring('or ask an "advisor" to select for you.',1,0,50);
        preparestring('On each trial there will be a different advisor.',1,0,0);
        preparestring('Each advisor has a different rate of success on this task.',1,0,-50);
        preparestring('Each advisor was generated by a computer algorithm ',1,0,-100);
        preparestring('and the answers from that algorithm were stored previously.',1,0,-150);
        preparestring('You will be told the success rate of the advisor and the charges for picking the figure.',1,0,-200);       
        preparestring('- PRESS ANY KEY TO CONTINUE -',1,0,-350);
        drawpict(1);
        waitkeydown(inf);
        clearpict(1);
        clearpict;
        
        preparestring('For example, let''s say you are offered an advisor with',1,0,100);
        preparestring('a 90% success rate of selecting figures correctly who charges 5 euros.',1,0,50);
        preparestring('You decide to "hire" the advisor and the advisor picks correctly,',1,0,0);
        preparestring('you will thus receive 5 euros (10 euros - 5 euros).',1,0,-50);        
        preparestring('- PRESS ANY KEY TO CONTINUE -',1,0,-350);
        drawpict(1);
        waitkeydown(inf);
        clearpict(1);
        clearpict;
         
        preparestring('2. There will be no feedback in this session so you will not know',1,0,100);
        preparestring('until the very end of the session whether your choices were good ones.',1,0,50);
        preparestring('- PRESS ANY KEY TO CONTINUE -',1,0,-250);
        drawpict(1);
        waitkeydown(inf);
        clearpict(1);
        clearpict;

        preparestring('NOTE: Use the "Y" key or the "A" key"',1,0,150);
        preparestring('to determine who will make the choice, you ("Y") or the advisor ("A").',1,0,100);
        preparestring('If you want to make the choice yourself, then choosing between figures is the same as before.',1,0,50);
        preparestring('Use the "Z" key for left and the "X" key for right.',1,0,0);
        preparestring('After completing the test phase you will be told',1,0,-50);
        preparestring('how much money you have earned.',1,0,-100);
        preparestring('Therefore, it is in your best interest to make choices that would maximise your payoff.',1,0,-150);
        preparestring('- PRESS ANY KEY TO START -',1,0,-350);
        drawpict(1);
        waitkeydown(inf);
        clearpict(1);
        clearpict;

    elseif DATA.treatment_type == 1

        preparestring('The task is the same as for the training sessions with three differences:',1,0,200);
        preparestring('1. You have the option to select the figure yourself out of the pair,',1,0,100)
        preparestring('or ask an "advisor" to select for you.',1,0,50);
        preparestring('On each trial there will be a different advisor.',1,0,0);
        preparestring('Each advisor has a different rate of success on this task.',1,0,-50);
        preparestring('Each advisor was generated by a computer algorithm ',1,0,-100);
        preparestring('and the answers from that algorithm were stored previously.',1,0,-150);
        preparestring('You will be told the success rate of the advisor and the charges for picking the figure.',1,0,-200);       
        preparestring('- PRESS ANY KEY TO CONTINUE -',1,0,-350);
        drawpict(1);
        waitkeydown(inf);
        clearpict(1);
        clearpict;
        
        preparestring('For example, let''s say you are offered an advisor with',1,0,100);
        preparestring('a 90% success rate of selecting figures correctly who charges 5 euros.',1,0,50);
        preparestring('You decide to "hire" the advisor and the advisor picks correctly,',1,0,0);
        preparestring('you will thus receive 5 euros (10 euros - 5 euros).',1,0,-50);        
        preparestring('- PRESS ANY KEY TO CONTINUE -',1,0,-350);
        drawpict(1);
        waitkeydown(inf);
        clearpict(1);
        clearpict;
         
        preparestring('2. There will be no feedback in this session so you will not know',1,0,100);
        preparestring('until the very end of the session whether your choices were good ones.',1,0,50);
        preparestring('- PRESS ANY KEY TO CONTINUE -',1,0,-350);
        drawpict(1);
        waitkeydown(inf);
        clearpict(1);
        clearpict;
        
        preparestring('3. You are now grouped with the three other people sitting in your row.',1,0,100);
        preparestring('Silently take a look to your right and left without standing up.',1,0,50);
        preparestring('After this phase one of you will be randomly selected',1,0,0);
        preparestring('to be held responsible for the other three people.',1,0,-50);
        preparestring('That is, your decision will determine both your own and your group members payoffs.',1,0,-100);
        preparestring('Your group members will not be told that you are responsible for their outcomes.',1,0,-150);
        preparestring('- PRESS ANY KEY TO CONTINUE -',1,0,-350);
        drawpict(1);
        waitkeydown(inf);
        clearpict(1);
        clearpict;
        % change height
        preparestring('NOTE: Use the "Y" key or the "A" key"',1,0,150);
        preparestring('to determine who will make the choice, you ("Y") or the advisor ("A").',1,0,100);
        preparestring('If you want to make the choice yourself, then choosing between figures is the same as before.',1,0,50);
        preparestring('Use the "Z" key for left and the "X" key for right.',1,0,0);
        preparestring('After completing the test phase you will be told',1,0,-50);
        % maybe adjust “test”
        preparestring('how much money each group member has earned.',1,0,-100);
        preparestring('This is equal to the payoffs of the responsible party.', 1, 0, -150)
        preparestring('Therefore, it is in your best interest to make choices that would maximise your group''s pay.',1,0,-200);
        preparestring('- PRESS ANY KEY TO START -',1,0,-350);
        drawpict(1);
        waitkeydown(inf);
        clearpict(1);
        clearpict;

    elseif DATA.treatment_type == 2
        preparestring('The task is the same as for the training sessions with three differences:',1,0,200);
        preparestring('1. You have the option to select the figure yourself out of the pair,',1,0,100)
        preparestring('or ask an "advisor" to select for you.',1,0,50);
        preparestring('On each trial there will be a different advisor.',1,0,0);
        preparestring('Each advisor has a different rate of success on this task.',1,0,-50);
        preparestring('Each advisor was generated by a computer algorithm ',1,0,-100);
        preparestring('and the answers from that algorithm were stored previously.',1,0,-150);
        preparestring('You will be told the success rate of the advisor and the charges for picking the figure.',1,0,-200);       
        preparestring('- PRESS ANY KEY TO CONTINUE -',1,0,-350);
        drawpict(1);
        waitkeydown(inf);
        clearpict(1);
        clearpict;
        
        preparestring('For example, let''s say you are offered an advisor with',1,0,100);
        preparestring('a 90% success rate of selecting figures correctly who charges 5 euros.',1,0,50);
        preparestring('You decide to "hire" the advisor and the advisor picks correctly,',1,0,0);
        preparestring('you will thus receive 5 euros (10 euros - 5 euros).',1,0,-50);        
        preparestring('- PRESS ANY KEY TO CONTINUE -',1,0,-350);
        drawpict(1);
        waitkeydown(inf);
        clearpict(1);
        clearpict;

        preparestring('2. There will be no feedback in this session so you will not know',1,0,100);
        preparestring('until the very end of the session whether your choices were good ones.',1,0,50);
        preparestring('- PRESS ANY KEY TO CONTINUE -',1,0,-350);
        drawpict(1);
        waitkeydown(inf);
        clearpict(1);
        clearpict;

        preparestring('3. You are now grouped with the three other people sitting in your row.',1,0,100);
        preparestring('Silently take a look to your right and left without standing up.',1,0,50);
        preparestring('After this phase one of you will be randomly selected ',1,0,0);
        preparestring('to be held responsible for the other three people.',1,0,-50);
        preparestring('That is, your decision will determine both your own and your group members payoffs.',1,0,-100);
        preparestring('All group members will be told who was responsible for the group''s outcomes.', 1,0,-150);
        preparestring('- PRESS ANY KEY TO CONTINUE -',1,0,-350);
        drawpict(1);
        waitkeydown(inf);
        clearpict(1);
        clearpict;

        preparestring('NOTE: Use the "Y" key or the "A" key"',1,0,150);
        preparestring('to determine who will make the choice, you ("Y") or the advisor ("A").',1,0,100);
        preparestring('If you want to make the choice yourself, then choosing between figures is the same as before.',1,0,50);
        preparestring('Use the "Z" key for left and the "X" key for right.',1,0,0);
        preparestring('After completing the test phase you will be told',1,0,-50);
        % maybe adjust “test”
        preparestring('how much money each group member has earned and who the responsible party was.',1,0,-100);
        preparestring('Earnings are equal to the payoffs of the responsible party.',1,0,-150);
        preparestring('Therefore, it is in your best interest to make choices that would maximise your group''s pay.',1,0,-200);         
        preparestring('- PRESS ANY KEY TO CONTINUE -',1,0,-350);
        drawpict(1);
        waitkeydown(inf);
        clearpict(1);
        clearpict;

    end

    for j = 1:2
        DATA.roundNum = [stageNum, j];
        DATA.trialList = DATA.params.randStim(:, 4*stageNum+2*j-1:4*stageNum+2*j);

        if j == 1
            DATA.expAcc = DATA.params.experts_test1(:,1);
            DATA.expCharge = DATA.params.experts_test1(:,2);
        elseif j == 2
            DATA.expAcc = DATA.params.experts_test2(:,1);
            DATA.expCharge = DATA.params.experts_test2(:,2);
        end

        DATA.reward = DATA.block_order(stageNum, j);

        if DATA.block_order(stageNum,j) == -1
            preparestring('In this block you will have only trials with LOSSES.',1,0,150);
            preparestring('Try to make the choices that best avoid your LOSSES.',1,0,100);
            preparestring('Remember to use the "Y" key for you and the "A" key for the advisor.',1,0,50);
            preparestring('If you want to make the choice yourself, then choosing between figures is the same as before.',1,0,0);
            preparestring('Use the "Z" key for left and the "X" key for right.',1,0,-50);
            preparestring('- PRESS ANY KEY TO START -',1,0,-350);
            drawpict(1);
            waitkeydown(inf);
            clearpict(1);
            clearpict;
        elseif DATA.block_order(stageNum,j) == 1
            preparestring('In this block you will have only trials with REWARDS.',1,0,150);
            preparestring('Try to make the choices that best maximize your earnings.',1,0,100);
            preparestring('Remember to use the "Y" key for you and the "A" key for the advisor.',1,0,50);
            preparestring('If you want to make the choice yourself, then choosing between figures is the same as before.',1,0,0);
            preparestring('Use the "Z" key for left and the "X" key for right.',1,0,-50);
            preparestring('- PRESS ANY KEY TO START -',1,0,-350);
            drawpict(1);
            waitkeydown(inf);
            clearpict(1);
            clearpict;
        end

        DATA = runTrials(DATA);

        % Compute average payoff for this block.
        indices_to_sample = randperm(DATA.params.blockLength, DATA.samples.samplesPerBlock);
        payoff_samples = NaN(DATA.params.blockLength, 1);
        for ii = indices_to_sample
            payoff_samples(ii) = DATA.rewardz(ii);
            % if DATA.metaChoice(ii) == 2
            %     if rand() < expAcc(ii)
            %         payoff_samples(ii) = DATA.reward_val*(1-expCharge(ii));
            %     else
            %         payoff_samples(ii) = -DATA.reward_val*expCharge(ii);
            %     end
            % elseif DATA.metaChoice(ii) == 1
            %     if rand() < 0.5
            %         payoff_samples(ii) = DATA.reward_val;
            %     else
            %         payoff_samples(ii) = 0;
            %     end
            % end
        end
        % Correct for gain/loss block.
        normalized_sample = mean(payoff_samples, 'omitnan')/100;
        DATA.samples.sampled_payoffs = [DATA.samples.sampled_payoffs, normalized_sample];

        datafile = sprintf('metachoiceTask_sub%s_testType%i_block%d', subNo, DATA.treatment_type, j);
        save(['data\Sub' subNo '\' datafile],'DATA');
        fprintf('Data saved in %s\n', datafile);

    end

end

%% Elicit self-assessment
% Should be done after all trials.
clearpict;

% Routine to extract numbers.
to_repeat = 1;
while to_repeat == 1
    index_to_change = 1;
    digits = [NaN, NaN];
    stoploop = 0;
    while stoploop == 0
        clearpict(1);
        preparestring('Before ending this part of the experiment, could you please provide',1,0,200);
        preparestring('an estimate of how accurate you think you were in choosing the CORRECT FIGURE?',1,0,150);
        preparestring('Please type in a number from 0% to 99%.',1,0,100);
        preparestring('There is no need to type the "%" sign. Please use the top number keys (not the side ones).',1,0,50);
        if index_to_change == 2
            preparestring(sprintf('%i', digits(1)),1,0,0);
        elseif index_to_change == 3
            preparestring(sprintf('%i%i', digits(1), digits(2)),1,0,0);
        end
        drawpict(1);
    
        [key,~] = waitkeydown(inf, [27:36, DATA.keys.enter, DATA.keys.backspace]); % wait for number keys
        
        if index_to_change ~= 1 && key == DATA.keys.enter
            stoploop = 1;
        elseif key == DATA.keys.backspace
            if index_to_change == 2
                index_to_change = 1;
                digits(1) = NaN;
            elseif index_to_change == 3
                index_to_change = 2;
                digits(2) = NaN;
            end
        elseif key >= 27 && key <= 36
            if index_to_change == 1
                digits(1) = key-27;
                index_to_change = 2;
            elseif index_to_change == 2
                digits(2) = key-27;
                index_to_change = 3;
            end
        end

    end

    if index_to_change == 2
        digitsnum = digits(1);
    elseif index_to_change == 3
        digitsnum = digits(1) * 10 + digits(2);
    end

    preparestring(sprintf('Are you sure this (%i%%) was your accuracy?', digitsnum),1,0,-50);
    preparestring('Press "N" to go on or "B" to put in a different number.',1,0,-100);
    drawpict(1);
    [key,~] = waitkeydown(inf, [DATA.keys.next, DATA.keys.back]);
    if key == DATA.keys.next
        to_repeat = 0;
        DATA.guessAcc = digitsnum;
        clearpict(1);
    end
end

to_repeat = 1;
while to_repeat == 1
    index_to_change = 1;
    digits = [NaN, NaN];
    stoploop = 0;
    while stoploop == 0
        clearpict(1);
        preparestring('Now, could you please provide an estimate of how accurate you think you were',1,0,200);%
        preparestring('in deciding whether to CHOOSE or to DEFER to the advisor?',1,0,150);
        preparestring('Please type in a number from 0% to 99%.',1,0,100);
        preparestring('There is no need to type the "%" sign. Please use the top number keys (not the side ones).',1,0,50);
        if index_to_change == 2
            preparestring(sprintf('%i', digits(1)),1,0,0);
        elseif index_to_change == 3
            preparestring(sprintf('%i%i', digits(1), digits(2)),1,0,0);
        end
        drawpict(1);
    
        [key,~] = waitkeydown(inf, [27:36, DATA.keys.enter, DATA.keys.backspace]); % wait for number keys
        
        if index_to_change ~= 1 && key == DATA.keys.enter
            stoploop = 1;
        elseif key == DATA.keys.backspace
            if index_to_change == 2
                index_to_change = 1;
                digits(1) = NaN;
            elseif index_to_change == 3
                index_to_change = 2;
                digits(2) = NaN;
            end
        elseif key >= 27 && key <= 36
            if index_to_change == 1
                digits(1) = key-27;
                index_to_change = 2;
            elseif index_to_change == 2
                digits(2) = key-27;
                index_to_change = 3;
            end
        end

    end

    if index_to_change == 2
        digitsnum = digits(1);
    elseif index_to_change == 3
        digitsnum = digits(1) * 10 + digits(2);
    end

    preparestring(sprintf('Are you sure this (%i%%) was your accuracy?', digitsnum),1,0,-50);
    preparestring('Press "N" to go on or "B" to put in a different number.',1,0,-100);
    drawpict(1);
    [key,~] = waitkeydown(inf, [DATA.keys.next, DATA.keys.back]);
    if key == DATA.keys.next
        to_repeat = 0;
        DATA.guessAcc_metachoice = digitsnum;
        clearpict(1);
    end
end

% preparestring('To go on to the next question, press any key to continue.',1,0,0);
% drawpict(1);
% waitkeydown(inf);
% clearpict(1);

preparestring('Just a couple of more questions...',1,0,200);%
preparestring('Which block made you happier? Losses or Gains?',1,0,100);
preparestring('Press 1 for Losses or 2 for Gains.',1,0,50);%null=1.5
drawpict(1);
[key,~] = waitkeydown(inf,28:29); % only accept 1 or 2
DATA.Qs.one = key-27;
clearpict(1);

preparestring('If you had to do one more block which one would you prefer, Losses or Gains?',1,0,100);%null=1.5
preparestring('Press 1 for Losses or 2 for Gains.',1,0,50);
drawpict(1);
[key,~] = waitkeydown(inf,28:29); % only accept 1 or 2
DATA.Qs.two = key-27;
clearpict(1);

to_repeat = 1;
while to_repeat == 1
    index_to_change = 1;
    digits = [NaN, NaN];
    stoploop = 0;
    while stoploop == 0
        clearpict(1);
        preparestring('How much would you pay to do the Gains block again?',1,0,100); % paired ttest with next question
        preparestring('Put in a number from 0 to 10 euros.',1,0,50);
        if index_to_change == 2
            preparestring(sprintf('%i', digits(1)),1,0,0);
        elseif index_to_change == 3
            preparestring(sprintf('%i%i', digits(1), digits(2)),1,0,0);
        end
        drawpict(1);
    
        [key,~] = waitkeydown(inf, [27:36, DATA.keys.enter, DATA.keys.backspace]); % wait for number keys
        
        if index_to_change ~= 1 && key == DATA.keys.enter
            stoploop = 1;
        elseif key == DATA.keys.backspace
            if index_to_change == 2
                index_to_change = 1;
                digits(1) = NaN;
            elseif index_to_change == 3
                index_to_change = 2;
                digits(2) = NaN;
            end
        elseif key >= 27 && key <= 36
            if index_to_change == 1
                digits(1) = key-27;
                index_to_change = 2;
            elseif index_to_change == 2
                digits(2) = key-27;
                index_to_change = 3;
            end
        end

    end

    if index_to_change == 2
        digitsnum = digits(1);
    elseif index_to_change == 3
        digitsnum = digits(1) * 10 + digits(2);
    end

    if digitsnum >= 0 && digitsnum <= 10
        to_repeat = 0;
        DATA.Qs.three = digitsnum;
        clearpict(1);
    elseif digitsnum < 0 || digitsnum > 10
        preparestring('Please enter a valid number from 0 to 10.',1,0,-50);
        preparestring('Press "B" to put in a different number.',1,0,-100);
        drawpict(1);
        waitkeydown(inf, DATA.keys.back);
    end
end

to_repeat = 1;
while to_repeat == 1
    index_to_change = 1;
    digits = [NaN, NaN];
    stoploop = 0;
    while stoploop == 0
        clearpict(1);
        preparestring('How much would you pay to do the Loss block again?',1,0,100);%
        preparestring('Put in a number from 0 to 10 euros.',1,0,50);
        if index_to_change == 2
            preparestring(sprintf('%i', digits(1)),1,0,0);
        elseif index_to_change == 3
            preparestring(sprintf('%i%i', digits(1), digits(2)),1,0,0);
        end
        drawpict(1);
    
        [key,~] = waitkeydown(inf, [27:36, DATA.keys.enter, DATA.keys.backspace]); % wait for number keys
        
        if index_to_change ~= 1 && key == DATA.keys.enter
            stoploop = 1;
        elseif key == DATA.keys.backspace
            if index_to_change == 2
                index_to_change = 1;
                digits(1) = NaN;
            elseif index_to_change == 3
                index_to_change = 2;
                digits(2) = NaN;
            end
        elseif key >= 27 && key <= 36
            if index_to_change == 1
                digits(1) = key-27;
                index_to_change = 2;
            elseif index_to_change == 2
                digits(2) = key-27;
                index_to_change = 3;
            end
        end

    end

    if index_to_change == 2
        digitsnum = digits(1);
    elseif index_to_change == 3
        digitsnum = digits(1) * 10 + digits(2);
    end

    if digitsnum >= 0 && digitsnum <= 10
        to_repeat = 0;
        DATA.Qs.four = digitsnum;
        clearpict(1);
    elseif digitsnum < 0 || digitsnum > 10
        preparestring('Please enter a valid number from 0 to 10.',1,0,-50);
        preparestring('Press "B" to put in a different number.',1,0,-100);
        drawpict(1);
        waitkeydown(inf, DATA.keys.back);
    end
end

preparestring('Congratulations! You just finished the first experiment!',1,0,100);
preparestring('Before the experiment ends and we give you your final compensation,',1,0,0);
preparestring('please go on to the next screens to do the second experiment.',1,0,-50);
preparestring('- PRESS ANY KEY TO CONTINUE -',1,0,-350);
drawpict(1);
waitkeydown(inf);
clearpict(1);
clearpict;

datafile = sprintf('metachoiceTask_sub%s_finalQs', subNo);
save(['data\Sub' subNo '\' datafile],'DATA');
fprintf('Data saved in %s\n', datafile);

stop_cogent;

return

%% Function to run trials
function DATA = runTrials(DATA)
%% type II response screen
pixperdeg = DATA.params.pixperdeg;
imsize= pixperdeg*DATA.params.scrwidth_deg;
cgmakesprite(2,imsize,imsize,0,0,0);
fig_pos = [-5,-3,-1,1,3,5] * pixperdeg;
cgfont('Arial',25);
cgsetsprite(2)
cgtext('1',fig_pos(1),0);
cgtext('2',fig_pos(2),0);
cgtext('3',fig_pos(3),0);
cgtext('4',fig_pos(4),0);
cgtext('5',fig_pos(5),0);
cgtext('6',fig_pos(6),0);

cwd = pwd;
for i = 1:size(DATA.trialList,1)
    % Prepare confidence selection square in buffer 4 - for some
    % annoying reason this needs to be put here again, otherwise cogent
    % forgets that the background needs to be trasnparent
    fontSize = DATA.fontSize;
    
    cgmakesprite(4,imsize,imsize,1,1,0);
    cgsetsprite(4)
    cgpenwid(pixperdeg*.1);
    cgpencol(1,0,0)
    cgdraw(-pixperdeg, -pixperdeg, pixperdeg, -pixperdeg);
    cgdraw(-pixperdeg, -pixperdeg, -pixperdeg, pixperdeg);
    cgdraw(-pixperdeg, pixperdeg, pixperdeg, pixperdeg);
    cgdraw(pixperdeg, pixperdeg, pixperdeg, -pixperdeg);
    cgtrncol(4,'y')
    cgpencol(1,1,1)
    
    clearkeys
    
    cgmakesprite(3,imsize,imsize,1,1,0);
    cgsetsprite(3)
    cgpenwid(.1*pixperdeg);
    cgpencol(1,0,0)
    cgdraw(-pixperdeg, -pixperdeg, pixperdeg, -pixperdeg);
    cgdraw(-pixperdeg, -pixperdeg, -pixperdeg, pixperdeg);
    cgdraw(-pixperdeg, pixperdeg, pixperdeg, pixperdeg);
    cgdraw(pixperdeg, pixperdeg, pixperdeg, -pixperdeg);
    cgtrncol(3,'y')   %% this sets background as yellow which will later be transparent so can see numbers through buffer.
    cgpencol(1,1,1)
    % Load pics into buffers 4
    clearpict(4);
    loadpict([sprintf('stim%d',DATA.trialList(i,1)) '.bmp'],4,-250,-200,300,300);
    loadpict([sprintf('stim%d',DATA.trialList(i,2)) '.bmp'],4,175,-200,300,300);
    cgfont('Arial',fontSize+10);
    cgtext('Who will choose?',0,300);
    cgtext('You       or       Advisor',0,250);
    
    yval = 100;
    cgtext('Advisor''s Accuracy: ',-350,yval);
    cgtext('Advisor''s Charge: ',150,yval);
    %clearpict(5)
    
    if DATA.training == 0
        DATA.rewardStruct(i) = DATA.reward_val*DATA.reward/100;
    else
        DATA.rewardStruct(i) = DATA.reward_val*DATA.reward_prac/100;
    end
    
    if DATA.training == 0
        
        expAcc = round(DATA.expAcc(i)*1000)/10;
        expCharge = round(DATA.expCharge(i)*DATA.reward_val);
        
        if DATA.reward == -1 %losses
            expert_textAcc = sprintf('%g%%', expAcc);
            expert_textChg = sprintf('%g ct', expCharge);
        elseif DATA.reward == 1 %gains
            expert_textAcc = sprintf('%g%%', expAcc);
            expert_textChg = sprintf('%g ct', expCharge);
        end
        cgpencol(1,0,0)
        cgtext(expert_textAcc, -100, yval);
        cgtext(expert_textChg, 375, yval);
        cgpencol(0,0,0)
    end
    
    %reward_text = sprintf('This trial is worth %d euros', DATA.rewardStruct(i));
    %cgtext(reward_text, 0, 400);
    
    clearpict(5);
    loadpict([sprintf('stim%d',DATA.trialList(i,1)) '.bmp'],5,-250,0,300,300);
    loadpict([sprintf('stim%d',DATA.trialList(i,2)) '.bmp'],5,175,0,300,300);
    cgfont('Arial',fontSize+10);
    %clearpict(5)
    cgtext('Which figure?',0,200);
    %reward_text = sprintf('This trial is worth %d euros', DATA.rewardStruct(i));
    %cgtext(reward_text, 0, 300);
    
    clearpict(6);
    loadpict([sprintf('stim%d',DATA.trialList(i,1)) '.bmp'],6,-250,0,300,300);
    loadpict([sprintf('stim%d',DATA.trialList(i,2)) '.bmp'],6,175,0,300,300);
    cgfont('Arial',fontSize+10);
    cgtext('Advisor is choosing...',0,200);
    
    
    if DATA.training == 0
        clearpict(7);
        %loadpict([sprintf('stim%d',DATA.trialList(i,1)) '.bmp'],7,-250,0,300,300);
        %loadpict([sprintf('stim%d',DATA.trialList(i,2)) '.bmp'],7,175,0,300,300);
        cgfont('Arial',fontSize+10);
        %cgtext(expert_text, 0, 350);
        cgtext('Who will choose?',0,300);
        cgtext('You       or       Advisor',0,250);
        cgtext('Advisor''s Accuracy: ',-350,0);
        cgtext('Advisor''s Charge: ',150,0);
        cgpencol(1,0,0)
        cgtext(expert_textAcc, -100, yval);
        cgtext(expert_textChg, 375, yval);
        cgpencol(0,0,0)
        % cgtext('Please wait 5 seconds.',0,200);
        
        clearpict(8);
        %loadpict([sprintf('stim%d',DATA.trialList(i,1)) '.bmp'],8,-250,0,300,300);
        %loadpict([sprintf('stim%d',DATA.trialList(i,2)) '.bmp'],8,175,0,300,300);
        cgfont('Arial',fontSize+10);
        
        cgtext('Who will choose?',0,300);
        cgtext('You       or       Advisor',0,250);
        cgtext('Advisor''s Accuracy: ',-350,0);
        cgtext('Advisor''s Charge: ',150,0);
        cgpencol(1,0,0)
        cgtext(expert_textAcc, -100, yval);
        cgtext(expert_textChg, 375, yval);
        cgpencol(0,0,0)
        cgtext('Choose',0,-200);
        
        
        
    end
    cgfont('Arial',fontSize);
    cd(cwd);
    
    %% Display stimuli
    cgsetsprite(0);
    clearkeys;
    cgfont('Arial',fontSize);
    cgtext('+',0,0);
    cgflip(1,1,1);
    wait(DATA.times.fix);
        
    % Log choice, redraw screen with choice indicator
    if DATA.training == 0 %if training == 0 go to test phase
        
        tChoice = time;

        cgdrawsprite(4,0,0);
        logstring('Y/A displayed');
        cgflip(1,1,1);
        [key,t] = waitkeydown(DATA.times.choice,[DATA.keys.you DATA.keys.advisor]); %25=y 1=a
        
        if ~isempty(key)
            
            if key == DATA.keys.you %yes
                DATA.metaChoice(i) = 1; DATA.metaChoice_RT(i) = t(1) - tChoice;
                cgdrawsprite(5,0,0);
                tChoice = time;
                logstring('Stimulus displayed');
                cgflip(1,1,1);
                clearkeys;
                [key,t] = waitkeydown(inf,[DATA.keys.left, DATA.keys.right]);
                
                if ~isempty(key)
                    
                    if key == DATA.keys.left
                        cgdrawsprite(5,0,0);
                        cgtext('*',-250,200);
                        DATA.choice.codeI(i) = 1;
                        DATA.choice_RT(i) = t(1) - tChoice;
                        DATA.choice.codeII(i) = DATA.trialList(i,1);
                        DATA.outcome(i) = randi(2)-1; %save the hypothetical outcomes for the final payoff
                        if DATA.outcome(i)==1
                            if DATA.reward == 1
                                DATA.rewardz(i) = DATA.reward_val;
                            else
                                DATA.rewardz(i) = 0;
                            end
                        else
                            if DATA.reward == 1
                                DATA.rewardz(i) = 0;
                            else
                                DATA.rewardz(i) = -DATA.reward_val;
                            end
                        end
                    elseif key == DATA.keys.right
                        cgdrawsprite(5,0,0);
                        cgtext('*',250,200);
                        DATA.choice.codeI(i) = 2;
                        DATA.choice_RT(i) = t(1) - tChoice;
                        DATA.choice.codeII(i) = DATA.trialList(i,2);
                        DATA.outcome(i) = randi(2)-1; %save the hypothetical outcomes for the final payoff
                        
                        if DATA.outcome(i)==1
                            if DATA.reward == 1
                                DATA.rewardz(i) = DATA.reward_val;
                            else
                                DATA.rewardz(i) = 0;
                            end
                        else
                            if DATA.reward == 1
                                DATA.rewardz(i) = 0;
                            else
                                DATA.rewardz(i) = -DATA.reward_val;
                            end
                        end
                    end
                    
                else
                    
                    DATA.choice.codeI(i) = -7;
                    DATA.choice_RT(i) = -7; %-7 means missed response on actual choice
                    DATA.choice.codeII(i) = -7;
                    %DATA.choice.correct(i) = -7;
                    DATA.outcome(i) = -10; %-10p for missed response
                    cgtext('Oops! Missed response!',0,0);
                    wait(500)
                end
                
            elseif key == DATA.keys.advisor %negative answer for the metachoice
                %cgflip(1,1,1);
                
                expert_wait = 2000; % 2 seconds
                wait_noise = randi(1000)-500;
                DATA.expert_wait(i) = expert_wait + wait_noise;
                %wait(DATA.expert_wait(i))
                %chunks = 3;
                %chunk_time = DATA.expert_wait/chunks;
                
                %  for w = 1:(chunks/3)
                %                 cgdrawsprite(6,0,0);
                %                 cgflip(1,1,1);
                %                 wait(chunk_time)
                %                 cgdrawsprite(7,0,0);
                %                 cgflip(1,1,1);
                %                 wait(chunk_time)
                cgdrawsprite(6,0,0);
                cgflip(1,1,1);
                wait(DATA.expert_wait(i))
                %end
                
                DATA.metaChoice(i) = 2;
                DATA.metaChoice_RT(i) = t(1) - tChoice;
                
                % DATA.outcome(i) = randi(2)-1; %save the hypothetical outcomes for the final payoff
                
                if expAcc>randi(100)
                    DATA.outcome(i) = 1;
                    if DATA.reward == 1
                        DATA.rewardz(i) = DATA.reward_val-expCharge;
                    else
                        DATA.rewardz(i) = -expCharge;
                    end
                else
                    DATA.outcome(i) = 0;
                    if DATA.reward == 1
                        DATA.rewardz(i) = 0;
                    else
                        DATA.rewardz(i) = -DATA.reward_val;
                    end
                end
                
                DATA.choice.codeI(i) = -5;
                DATA.choice_RT(i) = -5; %-5 means subject defaulted
                DATA.choice.codeII(i) = -5;
                %DATA.choice.correct(i) = -5;
            end
            
        else
            DATA.metaChoice(i) = -6;
            DATA.metaChoice_RT(i) = -6; %-6 means missed response on metachoice
            DATA.choice.codeI(i) = -6;
            DATA.choice_RT(i) = -6;
            DATA.choice.codeII(i) = -6;
            %DATA.choice.correct(i) = -6;
            DATA.outcome(i) = -10; %-10p for missed response
            cgtext('Oops! Missed response!',0,0);
            wait(500)
        end
        
        
    elseif DATA.training == 1 %if training == 1 go to training
        cgdrawsprite(5,0,0);
        tChoice = time;
        logstring('Practice stimulus displayed');
        cgflip(1,1,1);
        [key,t] = waitkeydown(inf,[26 24]);

        train_wait_time = 1000; % change for testing
        
        if ~isempty(key)
            
            if key == DATA.keys.left
                cgdrawsprite(5,0,0);
                cgtext('*',-250,200);
                DATA.choice.codeI(i) = 1;
                DATA.choice_RT(i) = t(1) - tChoice;
                DATA.choice.codeII(i) = DATA.trialList(i,1);
                %DATA.choice.correct(i) = max(DATA.trialList(i,:)) == DATA.trialList(i,1);
                
                if DATA.prac_wins(i)==0
                    DATA.outcome(i) = 0; %no win
                    DATA.rewardz(i) = DATA.reward_val*DATA.reward_prac;
                    cgflip(1,1,1);
                    cgfont('Arial',fontSize+10);
                    if DATA.reward_prac == 1
                        cgtext('0 euros',0,0);
                    elseif DATA.reward_prac == -1
                        cgtext('-10 euros',0,0);
                    end
                    wait(train_wait_time)
                else
                    DATA.outcome(i) = 1; %win!
                    DATA.rewardz(i) = DATA.reward_val*DATA.reward_prac;
                    cgflip(1,1,1);
                    cgfont('Arial',fontSize+10);
                    if DATA.reward_prac == 1
                        cgtext('+10 euros',0,0);
                    elseif DATA.reward_prac == -1
                        cgtext('0 euros',0,0);
                    end
                    wait(train_wait_time)
                end
                
            elseif key == DATA.keys.right
                cgdrawsprite(5,0,0);
                DATA.choice.codeI(i) = 2;
                DATA.choice_RT(i) = t(1) - tChoice;
                DATA.choice.codeII(i) = DATA.trialList(i,2);
                %DATA.choice.correct(i) = max(DATA.trialList(i,:)) == DATA.trialList(i,2);
                cgtext('*',250,200);
                
                if DATA.prac_wins(i)==0
                    DATA.outcome(i) = 0; %no win
                    DATA.rewardz(i) = DATA.reward_val*DATA.reward_prac;
                    cgflip(1,1,1);
                    cgfont('Arial',fontSize+10);
                    if DATA.reward_prac == 1
                        cgtext('0 euros',0,0);
                    elseif DATA.reward_prac == -1
                        cgtext('-10 euros',0,0);
                    end
                    wait(train_wait_time)
                else
                    DATA.outcome(i) = 1; %win!
                    DATA.rewardz(i) = DATA.reward_val*DATA.reward_prac;
                    cgflip(1,1,1);
                    cgfont('Arial',fontSize+10);
                    if DATA.reward_prac == 1
                        cgtext('+10 euros',0,0);
                    elseif DATA.reward_prac == -1
                        cgtext('0 euros',0,0);
                    end
                    wait(train_wait_time)
                end
            end
            
        else
            DATA.choice.codeI(i) = -7;
            DATA.choice_RT(i) = -7; %-7 means missed response on actual choice
            DATA.choice.codeII(i) = -7;
            %DATA.choice.correct(i) = -7;
            DATA.outcome(i) = -10; %-10p for missed response
            cgtext('Oops! Missed response!',0,0);
            wait(500)
        end
    end
    
    cgfont('Arial',fontSize);
    cgflip(1,1,1);
    wait(DATA.times.confirm);
    
end
clearpict(1);
preparestring('End of block.',1,0,0);
preparestring('- PRESS ANY KEY TO CONTINUE -',1,0,-350);
drawpict(1);
% Wait for keypress before continuing
waitkeydown(inf);
clearpict
clearpict(1);
return
