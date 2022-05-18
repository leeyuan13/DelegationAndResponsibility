% main_task_script.m
% Script to run delegation task and gambling task.
% Displays payoffs from each block at the end of the experiment.
% Includes experiment-specific information (cookies, donations, etc.).

% Written by:
%  Yuan Lee
%  May 2022

close all;
clc;
clear;

% global gender age program;

subno  = input('Subject number? ', 's');
gender = input('Gender? (M/F/Other) ', 's');
age = input('Age? ', 's');
program = input('BSE program? ', 's');

% Information.
DATAf.subno = subno;
DATAf.gender = gender;
DATAf.age = age;
DATAf.program = program;

% Which treatment?
DATAf.treatment_type = rem(str2double(subno), 3);

DATAf.skip_metachoice = 0; % whether to skip delegation task
DATAf.skip_risk_loss = 0; % whether to skip gambling task

mkdir(['data\Sub' subno]); % create folder where data will be saved

if DATAf.skip_metachoice == 0
    DATA1 = metachoice_task(subno,gender,age,program);
elseif DATAf.skip_metachoice == 1
    DATA1 = load(['data\Sub' subno '\' sprintf('metachoiceTask_sub%s_finalQs', subno)], 'DATA').DATA;
end

close all;
clc;

if DATAf.skip_risk_loss == 0
    DATA2 = risk_loss_task(subno,gender,age,program);
elseif DATAf.skip_risk_loss == 1
    DATA2 = load(['data\Sub' subno '\' sprintf('Data_loss_risk_aversion_Sub%s.mat',subno)], 'DATA').DATA;
end

%% Collect payoffs

% Payoffs.
DATAf.risk_loss_av_payoffs = [DATA2.Outcomes.Average];
%DATAf.risk_loss_av_payoffs = [0];
DATAf.metachoice_av_payoffs = DATA1.samples.sampled_payoffs;

%% Set up cogent

% Display parameters.
% TODO: adjust fullscreen, set screen resolution
% If using fullscreen, make sure the screen is set to the appropriate 
% resolution (e.g. 5 = 1280 x 1024).
screenMode = 0;                 % 0 for small window, 1 for full screen, 2 for second screen if attached
screenRes = 4;                  % screen resolution
white = [1 1 1];                % foreground colour
black = [0 0 0];                % background colour
fontName = 'Arial';         % font parameters
fontSize = 32;
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

%% Start cogent
start_cogent;

%% Display payoffs

preparestring('Thank you for participating in the experiment!',1,0,250);
preparestring('Please stay on this screen until the experimenter comes by',1,0,200);
preparestring('to record the following information,',1,0,150);

if DATAf.treatment_type == 0
    preparestring('which are your payoffs for the two parts of the experiment.', 1,0,100);
elseif DATAf.treatment_type == 1
    preparestring('which are your individual payoffs for the two parts of the experiment.', 1,0,100);
elseif DATAf.treatment_type == 2
    preparestring('which are your individual payoffs for the two parts of the experiment.', 1,0,100);
end

preparestring(['For the first part: ' num2str(mean(DATAf.metachoice_av_payoffs,'omitnan')) ' euros'],1,0,0)
preparestring(['For the second part: ' num2str(mean(DATAf.risk_loss_av_payoffs,'omitnan')) ' euros'],1,0,-50)

if DATAf.treatment_type == 1
    preparestring('Note that these may not be the payoffs you receive if you are',1,0,-150);
    preparestring('not ultimately held responsible for your group.',1,0,-200);
    preparestring('Subsequently we will announce your group payoff.',1,0,-250);
elseif DATAf.treatment_type == 2
    preparestring('Note that these may not be the payoffs you receive if you are',1,0,-150);
    preparestring('not ultimately held responsible for your group.',1,0,-200);
    preparestring('Subsequently we will announce your group payoff and ',1,0,-250);
    preparestring('the identity of the responsible party.',1,0,-300);
end

drawpict(1);

waitkeydown(inf,6); % f
waitkeydown(inf,9); % i
waitkeydown(inf,14); % n

clearpict(1);
clearpict;

preparestring('Please wait for further instructions',1,0,100);
preparestring('before pressing SPACE to continue.',1,0,50);
drawpict(1);
waitkeydown(inf,71);
clearpict(1);
clearpict;

preparestring('In the next screen, you will get to donate your payoff',1,0,200);
preparestring('from this experiment to us in exchange for a cookie.',1,0,150);
preparestring('If you wish to keep your payoff, please stay behind so that',1,0,100);
preparestring('we can collect your IBAN.',1,0,50);
preparestring('If you wish to donate your payoff, you may come forward to',1,0,0);
preparestring('collect your cookie immediately after the experiment concludes.',1,0,-50);
preparestring('- PRESS ANY KEY TO CONTINUE -',1,0,-350);
drawpict(1);
waitkeydown(inf);
clearpict(1);
clearpict;

stop_loop = 0;

while stop_loop == 0
    preparestring('Would you like to donate your payoff in exchange for a cookie?',1,0,100);
    preparestring('Press "D" to donate your payoff or "K" to keep your payoff.',1,0,50);
    drawpict(1);
    [key,~] = waitkeydown(inf,[4 11]);
    if key == 4 % d
        preparestring('Thank you! Press "N" to confirm your donation or "B" to enter a different response.',1,0,-50);
    elseif key == 11 % k
        preparestring('Press "N" to confirm your choice or "B" to enter a different response.',1,0,-50);
    end
    drawpict(1);
    [nextkey,~] = waitkeydown(inf,[2 14]);
    if nextkey == 14
        stop_loop = 1;
        if key == 4
            DATAf.donate = 1;
        elseif key == 11
            DATAf.donate = 0;
        end
    end
    clearpict(1);
    clearpict;
end

datafile = sprintf('summary_sub%s_donation', subno);
save(['data\Sub' subno '\' datafile],'DATAf');
fprintf('Data saved in %s\n', datafile);


preparestring('We have come to the conclusion of the experiment.',1,0,50);
if DATAf.donate == 1
    preparestring('Thank you for your participation and your donation!',1,0,-50)
elseif DATAf.donate == 0
    preparestring('Thank you for your participation!',1,0,-50)
end
drawpict(1);

waitkeydown(inf,6); % f
waitkeydown(inf,9); % i
waitkeydown(inf,14); % n

clearpict(1);
clearpict;

stop_cogent;
