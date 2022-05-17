function DATA = risk_loss_task(subno,gender,age,program)
% Loss and risk aversion task using Cogent for stimuli presentation.

% Script written by Caroline Charpentier in 2015, used in
%  Charpentier et al. (2016). "Models of affective decision making: How do
%  feelings predict choice?" Psychological Science, 27(6), 763–775.

% Requires Select_outcomes_combined.m, loss_risk_aversion_estimation.m,
% loss_aversion_estimation.m, risk_aversion_estimation.m

% Slightly modified by:
%  Yuan Lee
%  May 2022

%% Setup and Instructions

dir=pwd; 
cd(dir)

%Add COGENT to path

DATA.Subject.Number   = subno;
DATA.Subject.Gender   = gender;
DATA.Subject.Age      = age;
DATA.Subject.Program  = program;

DATA.Subject.TreatmentType = rem(str2double(subno),3);

% mkdir(['data\Sub' subno]); %create folder where data will be saved

stream = RandStream('mt19937ar','seed',sum(100*clock)); %Set random number generator seed to clock (so that random permutations are different each time Matlab starts)
RandStream.setGlobalStream(stream);

% COGENT configuration
% display parameters
screenMode = 0;                 % 0 for small window, 1 for full screen, 2 for second screen if attached
screenRes = 3;                  % 1=640x480, 2=800x600, 3=1024x768, 4=1152x864, 5=1280x1024, 6=1600x1200
white = [1 1 1];                % foreground colour
black = [0 0 0];                % background colour
fontName = 'Helvetica';         % font parameters
fontSize = 30;
number_of_buffers = 5;          % how many offscreen buffers to create

%Screen dimension
sc_width = 1024;
sc_height = 768;

% call config_... to set up cogent environment, before starting cogent
config_display(screenMode, screenRes, black ,white, fontName, fontSize, number_of_buffers);   % open graphics window
config_keyboard;                % this enables collection of keyboard responses

% Set cogent up to log events.
% Log will be saved at 'Cogent-YYYY-MMDD-HH-MM-SS.log'.
config_log;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start_cogent;

%Write instructions on screen
cgtext('Welcome to the second part of the experiment!',0,320);
cgtext('You will have to make a series of choices between',0,220);
cgtext('two options presented on the screen. One option is a gamble',0,160);
cgtext('in which you can win or lose each amount of money with a 50%',0,100);
cgtext('probability (like a coin toss), and the other option is a',0,40);
cgtext('sure amount of money',0,-20);
cgtext('The choices are of two types.',0,-80);
cgtext('Press space to continue.',0,-180);
cgflip(0,0,0)

cgtext('In the first type of choice, if you choose the gamble (left button), you will',0,320);
cgtext('have 50% chance to win the amount written in green, and 50% chance',0,290);
cgtext('to lose the amount in red - ie either win 15 euros or lose 5 euros in a coin toss',0,260);
cgtext('If you choose the sure option (right button), then you get 0 euros for this trial.',0,230);
cgalign ('c', 'c');                     %center alignment
cgpencol (1, 1, 1);                     %white on grey background
cgpenwid(5);                            %set pen width
cgellipse(-256, 0, 300, 300);           %draw circles
cgellipse(256, 0, 300, 300);
cgfont ('Helvetica', 45)
cgtext(['EUR ' '0'], 256, 0);
cgdraw(-256, 150, -256, -150);    %draw vertical line for gamble
cgfont ('Helvetica', 40)
cgpencol(1, 0, 0);                      %make red pen for lose
cgtext('LOSE', -181, 25);
cgtext(['EUR ' '5'], -181, -25);
cgpencol(0, 1, 0);                      %make green pen for gain
cgtext('WIN', -331, 25);
cgtext(['EUR ' '15'], -331, -25);
cgpencol (1, 1, 1); 
cgfont ('Helvetica', 30)
cgtext('Press space to continue.',0,-250);
waitkeydown(inf,71);
cgflip(0,0,0)

cgtext('In the second type of choice, if you choose the gamble (right button this time),',0,320);
cgtext('you can either win 15 euros or win 0 euros (50% change of each/coin toss).',0,290);
cgtext('If you choose the sure option (left button here), then you win 10 euros for this trial',0,260);
cgalign ('c', 'c');                     %center alignment
cgpencol (1, 1, 1);                     %white on grey background
cgpenwid(5);                            %set pen width
cgellipse(-256, 0, 300, 300);           %draw circles
cgellipse(256, 0, 300, 300);
cgdraw(256, 150, 256, -150);    %draw vertical line for gamble
cgfont ('Helvetica', 40)
cgpencol(0, 1, 0);                      %make green pen for gain
cgtext('WIN', -256, 25);
cgtext(['EUR ' '10'], -256, -25);
cgtext('WIN', 331, 25);
cgtext(['EUR ' '15'], 331, -25);
cgfont ('Helvetica', 45)
cgpencol (1, 1, 1);
cgtext(['EUR ' '0'], 181, 0);
cgfont ('Helvetica', 30)
cgtext('Press space to continue.',0,-250);
waitkeydown(inf,71);
cgflip(0,0,0)

cgtext('Importantly, the probability to win and lose never changes (always 50%,',0,200);
cgtext('similar to flipping a coin). Only the amounts you can win or lose will change',0,140);
cgtext('on every trial. Therefore you have to pay attention to these amounts before',0,80);
cgtext('you decide if you want to choose the gamble or the sure option.',0,20);
cgtext('Press space to continue.',0,-100);
waitkeydown(inf,71);
cgflip(0,0,0)

if DATA.Subject.TreatmentType == 0
    cgtext('The payment will work as follows. At the end of the session',0,300);
    cgtext('the computer will randomly select 10 trials across all the choices you played.',0,240);
    cgtext('Your final earnings will then be calculated by',0,180); 
    cgtext('averaging the amount won/lost across those 10 trials.',0,120);
    cgtext('You will only receive the final amount at the end of the session,',0,60);
    cgtext('but any gamble from now on can be one of the 10 selected at the end.',0,0);
    cgtext('Press space to see which keys to press.',0,-60);
    waitkeydown(inf,71);
    cgflip(0,0,0);
elseif DATA.Subject.TreatmentType == 1
    cgtext('You are still grouped with the three other people sitting in your row.',0,240);
    cgtext('As before, the randomly selected responsible party will determine',0,180);
    cgtext('the group''s payoffs. If you are the responsible party,',0,120);
    cgtext('your decisions will determine both your own and your group members'' payoffs.',0,60);
    cgtext('Your group members will not be told that you are responsible for their outcomes.',0,0);
    cgtext('Press space to continue',0,-60);
    waitkeydown(inf,71);
    cgflip(0,0,0);

    cgtext('The payment will work as follows. At the end of the session',0,300);
    cgtext('the computer will randomly select 10 trials across all the choices you played.',0,240);
    cgtext('Your final earnings will then be calculated by',0,180); 
    cgtext('averaging the amount won/lost across those 10 trials.',0,120);
    cgtext('You will only receive the final amount at the end of the session,',0,60);
    cgtext('but any gamble from now on can be one of the 10 selected at the end.',0,0);
    cgtext('Press space to see which keys to press.',0,-60);
    waitkeydown(inf,71);
    cgflip(0,0,0);
elseif DATA.Subject.TreatmentType == 2
    cgtext('You are still grouped with the three other people sitting in your row.',0,240);
    cgtext('As before, the randomly selected responsible party will determine',0,180);
    cgtext('the group''s payoffs. If you are the responsible party,',0,120);
    cgtext('your decisions will determine both your own and your group members'' payoffs.',0,60);
    cgtext('Your group members will be told that you are responsible for their outcomes.',0,0);
    cgtext('Press space to continue',0,-60);
    waitkeydown(inf,71);
    cgflip(0,0,0);

    cgtext('The payment will work as follows. At the end of the session',0,300);
    cgtext('the computer will randomly select 10 trials across all the choices you played.',0,240);
    cgtext('Your final earnings will then be calculated by',0,180); 
    cgtext('averaging the amount won/lost across those 10 trials.',0,120);
    cgtext('You will only receive the final amount at the end of the session,',0,60);
    cgtext('but any gamble from now on can be one of the 10 selected at the end.',0,0);
    cgtext('Press space to see which keys to press.',0,-60);
    waitkeydown(inf,71);
    cgflip(0,0,0);
end

cgtext('Press left arrow if you want to choose the option on the left',0,150);
cgtext('and right arrow to choose the option on the right.',0,90);
cgtext('Be careful, you only have 3 seconds to indicate your choice.',0,30);
cgtext('Press space when you are ready to start.',0,-100);
waitkeydown(inf,71);
cgflip(0,0,0)
waitkeydown(inf,71);

%% Data and variables
nt_LA1 = 25; %number of trials
parameters.LA.nt1 = nt_LA1;
nt_RA1 = 15;
parameters.RA.nt1 = nt_RA1;
nt1 = nt_LA1 + nt_RA1;
parameters.nt1 = nt1;
trial_ord = [randperm(nt1)' [ones(nt_LA1,1); 2*ones(nt_RA1,1)]];
trial_ord = sortrows(trial_ord,1);
parameters.trial_ord = trial_ord; %1 for loss aversion trial, 2 for risk aversion trial

%gain loss matrix
gains = [6;7;8;9;10;12;14;16;18;20;22;24];
parameters.LA.gains1 = gains;
losses = [-12;-11;-10;-9;-8;-7;-6;-5;-4;-3;-2;-1];
parameters.LA.losses1 = losses;
nb_asso = length(gains)*length(losses);

%compute gambles associations (all possible pairs of gains and losses)
k=1;
gamble_pairs=zeros(nb_asso,2);
for i=1:length(losses)
    for j=1:length(gains)
        gamble_pairs(k,1)=losses(i);
        gamble_pairs(k,2)=gains(j);
        gamble_pairs(k,3)=0.5*losses(i)+0.5*gains(j);
        k=k+1;
    end
end
gamble_pairs = sortrows(gamble_pairs,3);
parameters.LA.gamble_pairs1 = gamble_pairs;
gamble_pairs(:,4) = gamble_pairs(:,3);
%expected values to start with
EV_low = -2;
EV_high = 10;
parameters.LA.EVlow = EV_low;
parameters.LA.EVhigh = EV_high;

DATA.Trials1.LA = []; %matrix to store data from each trial
DATA.Trials1.RA = [];
DATA.TrialsCombined1 = [];

%compute gamble / sure option associations for risk aversion part
high_gain = [6;8;10;12;14;16;18;20;22;26;30;34];
parameters.RA.highgain1 = high_gain;
sure_option = [1;2;3;4;5;6;7;8;9;10;11;12];
parameters.RA.sure1 = sure_option;
nb_asso_RA = length(high_gain)*length(sure_option);

k=1;
gamble_pairs_RA1=zeros(nb_asso_RA,2);
for i=1:length(sure_option)
    for j=1:length(high_gain)
        gamble_pairs_RA1(k,1)=sure_option(i);
        gamble_pairs_RA1(k,2)=high_gain(j);
        gamble_pairs_RA1(k,3)=0.5*high_gain(j)-sure_option(i); %EV difference between gamble and sure option
        k=k+1;
    end
end
gamble_pairs_RA1 = sortrows(gamble_pairs_RA1,3);
parameters.RA.gamble_pairs1 = gamble_pairs_RA1;
diffEV_low = -6;
diffEV_high = 12;
parameters.RA.diffEVlow = diffEV_low;
parameters.RA.diffEVhigh = diffEV_high;

filename = sprintf('Data_loss_risk_aversion_Sub%s.mat',subno);
save(['data\Sub' subno '\' filename],'parameters','DATA');
 
%% Prepare fixation cross

cgmakesprite(3, sc_width, sc_height, 0,0,0);
cgsetsprite(3);
cgalign('c','c');
cgpencol (1, 1, 1);
cgfont ('Helvetica', 50);
cgtext('+',0,20);
cgfont ('Helvetica', 35);

cgsetsprite(0);
cgflip(0,0,0);

cgdrawsprite(3,0,0);
t_fix = cgflip(0,0,0);


%% Main trial loop for rough estimation

startSecs = time; %read time (0 for start)
LA = 1; %start with a loss aversion value of 1

for j=1:nt1 %80 trials for the staircase in this version

    %first determine if trial is for loss aversion or risk aversion
    if trial_ord(j,2) == 1 %loss aversion trial
        %first, group gambles with extreme EV to make sure at least 5 per group
        if EV_low <= -2
            gambles_low = gamble_pairs(gamble_pairs(:,3)<=-2,:);
        elseif EV_low > -2 && EV_low <= -1
            gambles_low = gamble_pairs(gamble_pairs(:,3)>-2 & gamble_pairs(:,3)<=-1,:);
        elseif EV_low >= 8 && EV_low < 9
            gambles_low = gamble_pairs(gamble_pairs(:,3)>=8 & gamble_pairs(:,3)<9,:);
        elseif EV_low >= 9 && EV_low < 10
            gambles_low = gamble_pairs(gamble_pairs(:,3)>=9 & gamble_pairs(:,3)<10,:);
        elseif EV_low >= 10
            gambles_low = gamble_pairs(gamble_pairs(:,3)>=10,:);
        else
            gambles_low = gamble_pairs(gamble_pairs(:,3)<=EV_low+0.25 & gamble_pairs(:,3)>=EV_low-0.25,:);
        end
        if isempty(gambles_low)==1
            gambles_low = gamble_pairs(gamble_pairs(:,3)<=EV_low+0.5 & gamble_pairs(:,3)>=EV_low-0.5,:);
        end
        if isempty(gambles_low)==1 && EV_low<min(gamble_pairs(:,3))  %this will avoid the staircase from crashes when it reaches the extreme values
            gambles_low = gamble_pairs(1:6,:);
        end
    
        if EV_high <= -2
            gambles_high = gamble_pairs(gamble_pairs(:,3)<=-2,:);
        elseif EV_high > -2 && EV_high <= -1
            gambles_high = gamble_pairs(gamble_pairs(:,3)>-2 & gamble_pairs(:,3)<=-1,:);
        elseif EV_high >= 8 && EV_high < 9
            gambles_high = gamble_pairs(gamble_pairs(:,3)>=8 & gamble_pairs(:,3)<9,:);
        elseif EV_high >= 9 && EV_high < 10
            gambles_high = gamble_pairs(gamble_pairs(:,3)>=9 & gamble_pairs(:,3)<10,:);
        elseif EV_high >= 10
            gambles_high = gamble_pairs(gamble_pairs(:,3)>=10,:);
        else
            gambles_high = gamble_pairs(gamble_pairs(:,3)<=EV_high+0.25 & gamble_pairs(:,3)>=EV_high-0.25,:);
        end
        if isempty(gambles_high)==1
            gambles_high = gamble_pairs(gamble_pairs(:,3)<=EV_high+0.5 & gamble_pairs(:,3)>=EV_high-0.5,:);
        end
        if isempty(gambles_high)==1 && EV_high>max(gamble_pairs(:,3)) %this will avoid the staircase from crashes when it reaches the extreme values
            gambles_high = gamble_pairs(end-5:end,:);
        end
        
        l_l = [randperm(length(gambles_low(:,3)))' gambles_low]; %pick random 1 loss values from the list
        l_l = sortrows(l_l,1);
        list_low = [l_l(1,2:3) 1]; %1 for low EV trial
        l_h = [randperm(length(gambles_high(:,3)))' gambles_high]; %pick random 5 loss values from the list of 10
        l_h = sortrows(l_h,1);
        list_high = [l_h(1,2:3) 2];  %2 for high EV trial
    
        trial_list = [randperm(2)'+2*j-2 [list_low;list_high]];
        trial_list = sortrows(trial_list,1);
    
        for i=1:2
            %extract trial characteristics for trial i
            loss = trial_list(i,2); %loss value
            gain = trial_list(i,3); %gain value
        
            wait(1000); % wait 1 sec while fixation cross is on
        
            cgsetsprite(0);
            cgflip(0,0,0);
        
            posg=floor(2*rand+1); %randomized left/right position of gamble vs sure option
            parameters.gamblepos1(2*j+i-2,1)=posg;
            pos=floor(2*rand+1); %randomized left/right position of gain and loss
            parameters.gainlosspos1(2*j+i-2,1)=pos;
            if posg==1 %gamble on the left
                sgamble=-256;
                if pos==1
                    sloss=-331; %display loss on the left hemicircle
                    sgain=-181; %display gain on the right hemicircle
                elseif pos==2
                    sloss=-181; %display loss on the right hemicircle
                    sgain=-331; %display gain on the left hemicircle
                end
            elseif posg==2 %gamble on the right
                sgamble=256;
                if pos==1
                    sloss=181; %display loss on the left hemicircle
                    sgain=331; %display gain on the right hemicircle
                elseif pos==2
                    sloss=331; %display loss on the right hemicircle
                    sgain=181; %display gain on the left hemicircle
                end
            end
        
            %draw circle and line in which to display the gamble
            cgmakesprite (2, sc_width, sc_height, 0,0,0);    %make black ratesprite
            cgdrawsprite(2,0,0);                    %ready sprite to draw into
            cgalign ('c', 'c');                     %center alignment
            cgpencol (1, 1, 1);                     %white on grey background
            cgpenwid(5);                            %set pen width
            cgellipse(-256, 0, 300, 300);           %draw circles
            cgellipse(256, 0, 300, 300);
            cgfont ('Helvetica', 45)
            cgtext(['EUR ' '0'], -sgamble, 0);
            cgdraw(sgamble, 150, sgamble, -150);    %draw vertical line for gamble
            cgfont ('Helvetica', 40)
            cgpencol(1, 0, 0);                      %make red pen for lose
            cgtext('LOSE', sloss, 25);
            cgtext(['EUR ' num2str(abs(loss))], sloss, -25);
            cgpencol(0, 1, 0);                      %make green pen for gain
            cgtext('WIN', sgain, 25);
            cgtext(['EUR ' num2str(gain)], sgain, -25);
       
            t_gamble = cgflip(0,0,0);
            trial_list(i,5) = t_gamble; %record onset of the gamble
        
            clearkeys;
            no_response=1;
            while no_response==1
                readkeys;
                wait(5);
                logkeys;
                [keyout,buttontime,npress] = getkeydown;
                t1=time;
                if (t1 - t_gamble*1000) > 3000 % if more than 3 sec has elapsed, move on
                    Resp = -999;
                    buttontime = t_gamble*1000 + 3000;
                    no_response = 0;
                    break
                elseif isempty(keyout)==1 %if no button is pressed, do nothing and continue looping
                elseif keyout==97 %left arrow pressed
                    if posg==1 %gamble also on the left, ie accepted
                        Resp=1;
                        no_response=0;
                        break
                    elseif posg==2 %gamble on the right, ie rejected
                        Resp=0;
                        no_response=0;
                        break
                    end
                elseif keyout==98 %right arrow pressed
                    if posg==1 %gamble rejected
                        Resp=0;
                        no_response=0;
                        break
                    elseif posg==2 %gamble accepted
                        Resp=1;
                        no_response=0;
                        break
                    end
                end
            end
            Resp_time = buttontime/1000-t_gamble; %calculate reaction time in secs
            
            trial_list(i,6) = Resp; %record response in trial_list matrix, column 6
            trial_list(i,7) = Resp_time; %record reaction time in trial_list matrix, column 7
            trial_list(i,8) = 0.5*loss + 0.5*gain; %record expected value of the gamble
        
            cgdrawsprite(3,0,0);
            t_fix = cgflip(0,0,0);
        end
        
        DATA.Trials1.LA = [DATA.Trials1.LA; trial_list];
        all_t = DATA.Trials1.LA;
        
        %calculate lambda after each mini-block of 2 trials in order to
        %adjust staircase based on subjective EV (rather than EV)
        if j>2 %only start doing this on the third mini block
            [b_LG,d,s] = glmfit(all_t(all_t(:,6)~=-999,2:3),all_t(all_t(:,6)~=-999,6),'binomial','link','logit','constant','off');
            if s.p(1)<=0.05 && s.p(2)<=0.05
                LA = b_LG(1)/b_LG(2);
                gamble_pairs(:,3) = 0.5*LA*gamble_pairs(:,1) + 0.5*gamble_pairs(:,2);
                gamble_pairs = sortrows(gamble_pairs,3);
                parameters.LA.gamble_pairs1 = gamble_pairs;
            end
        end
                       
        %apply the adjustment for the next 2 trials
        if trial_list(trial_list(:,4)==1,6)==0
            EV_low = EV_low + 0.5; %if low EV gamble rejected increase EV by 0.5
        elseif trial_list(trial_list(:,4)==1,6)==1
            EV_low = EV_low - 0.5;
        end
    
        if trial_list(trial_list(:,4)==2,6)==1
            EV_high = EV_high - 0.5; %if high EV gamble accepted decrease EV by 0.5
        elseif trial_list(trial_list(:,4)==2,6)==0
            EV_high = EV_high + 0.5;
        end
        
    
    elseif trial_ord(j,2) == 2 %risk aversion trial
        gambles_low = gamble_pairs_RA1(gamble_pairs_RA1(:,3)==diffEV_low,1:2);
        if isempty(gambles_low)==1  %this will avoid the staircase from crashing when it reaches the extreme values
            gambles_low = gamble_pairs_RA1(1:6,1:2);
        end
        gambles_high = gamble_pairs_RA1(gamble_pairs_RA1(:,3)==diffEV_high,1:2);
        if isempty(gambles_high)==1  %this will avoid the staircase from crashing when it reaches the extreme values
            gambles_high = gamble_pairs_RA1(end-5:end,1:2);
        end
        
        l_l = [randperm(length(gambles_low(:,1)))' gambles_low]; %pick random 1 loss values from the list
        l_l = sortrows(l_l,1);
        list_low = [l_l(1,2:3) 1]; %1 for low EV trial
        l_h = [randperm(length(gambles_high(:,1)))' gambles_high]; %pick random 5 loss values from the list of 10
        l_h = sortrows(l_h,1);
        list_high = [l_h(1,2:3) 2];  %2 for high EV trial
    
        trial_list_RA = [randperm(2)'+2*j-2 [list_low; list_high]];
        trial_list_RA = sortrows(trial_list_RA,1);
        
        for i=1:2
            val = trial_list_RA(i,3); 
            sure = trial_list_RA(i,2);
           
            wait(1000); % wait 1 sec while fixation cross is on
        
            cgsetsprite(0);
            cgflip(0,0,0);
        
            posg=floor(2*rand+1); %randomized left/right position of gamble vs sure option
            parameters.gamblepos1(2*j+i-2,1)=posg;
            pos=floor(2*rand+1); %randomized left/right position of gain and 0 in the gamble
            parameters.gainlosspos1(2*j+i-2,1)=pos;
            if posg==1 %gamble on the left
                sgamble=-256;
                if pos==1
                    szero=-331; %display loss on the left hemicircle
                    sgain=-181; %display gain on the right hemicircle
                elseif pos==2
                    szero=-181; %display loss on the right hemicircle
                    sgain=-331; %display gain on the left hemicircle
                end
            elseif posg==2 %gamble on the right
                sgamble=256;
                if pos==1
                    szero=181; %display loss on the left hemicircle
                    sgain=331; %display gain on the right hemicircle
                elseif pos==2
                    szero=331; %display loss on the right hemicircle
                    sgain=181; %display gain on the left hemicircle
                end
            end
            
            %draw circle and line in which to display the gamble
            cgmakesprite (2, sc_width, sc_height, 0,0,0);    %make black ratesprite
            cgdrawsprite(2,0,0);                    %ready sprite to draw into
            cgalign ('c', 'c');                     %center alignment
            cgpencol (1, 1, 1);                     %white on grey background
            cgpenwid(5);                            %set pen width
            cgellipse(-256, 0, 300, 300);           %draw circles
            cgellipse(256, 0, 300, 300);
            cgdraw(sgamble, 150, sgamble, -150);    %draw vertical line for gamble
            cgfont ('Helvetica', 40)
            cgpencol(0, 1, 0);                      %make green pen for gain
            cgtext('WIN', -sgamble, 25);
            cgtext(['EUR ' num2str(sure)], -sgamble, -25);
            cgtext('WIN', sgain, 25);
            cgtext(['EUR ' num2str(val)], sgain, -25);
            cgpencol(1, 1, 1); 
            cgfont ('Helvetica', 45)
            cgtext(['EUR ' '0'], szero, 0);
            cgfont ('Helvetica', 40)
                   
            t_gamble = cgflip(0,0,0);
            trial_list_RA(i,5) = t_gamble; %record onset of the gamble
        
            clearkeys;
            no_response=1;
            while no_response==1
                readkeys;
                wait(5);
                logkeys;
                [keyout,buttontime,npress] = getkeydown;
                t1=time;
                if (t1 - t_gamble*1000) > 3000 % if more than 3 sec has elapsed, move on
                    Resp = -999;
                    buttontime = t_gamble*1000 + 3000;
                    no_response = 0;
                    break
                elseif isempty(keyout)==1 %if no button is pressed, do nothing and continue looping
                elseif keyout==97 %left arrow pressed
                    if posg==1 %gamble also on the left, ie gamble chosen
                        Resp=1;
                        no_response=0;
                        break
                    elseif posg==2 %gamble on the right, ie sure option chosen
                        Resp=0;
                        no_response=0;
                        break
                    end
                elseif keyout==98 %right arrow pressed
                    if posg==1 %sure option chosen
                        Resp=0;
                        no_response=0;
                        break
                    elseif posg==2 %gamble chosen
                        Resp=1;
                        no_response=0;
                        break
                    end
                end
            end
            Resp_time = buttontime/1000-t_gamble; %calculate reaction time in secs
            
            trial_list_RA(i,6) = Resp; %record response in trial_list matrix, column 6
            trial_list_RA(i,7) = Resp_time; %record reaction time in trial_list matrix, column 7
            trial_list_RA(i,8) = 0.5*val - sure; %record expected value difference between the gamble and the sure option
        
            cgdrawsprite(3,0,0);
            t_fix = cgflip(0,0,0);
        end
        
        %apply the adjustment for the next 2 trials
        if trial_list_RA(trial_list_RA(:,4)==1,6)==0
            diffEV_low = diffEV_low + 1; %if low gain gamble rejected increase diffEV by 1
        elseif trial_list_RA(trial_list_RA(:,4)==1,6)==1
            diffEV_low = diffEV_low - 1;
        end
    
        if trial_list_RA(trial_list_RA(:,4)==2,6)==1
            diffEV_high = diffEV_high - 1; %if high gain gamble accepted decrease diffEV by 1
        elseif trial_list_RA(trial_list_RA(:,4)==2,6)==0
            diffEV_high = diffEV_high + 1;
        end

        DATA.Trials1.RA = [DATA.Trials1.RA; trial_list_RA];
        
    end
    
end

save(['data\Sub' subno '\' filename],'DATA','parameters');

DATA.Missed1 = sum(DATA.Trials1.LA(:,6)==-999)+sum(DATA.Trials1.RA(:,6)==-999);
missed = DATA.Missed1;

DATA.Trials1.LA(:,9) = 0.5*LA*DATA.Trials1.LA(:,2) + 0.5*DATA.Trials1.LA(:,3);

%% Rough estimation of parameters

%model loss aversion
all_trials = DATA.Trials1.LA;
all_trials(all_trials(:,6)==-999,:)=[];
[b_LG,d_LG,stats_LG]=glmfit(all_trials(:,2:3),all_trials(:,6),'binomial','link','logit','constant','off');
[b_EV,d_EV,stats_EV]=glmfit(all_trials(:,8),all_trials(:,6),'binomial','link','logit');

LA = b_LG(1)/b_LG(2);
IP = -b_EV(1)/b_EV(2);

p_loss = stats_LG.p(1);
p_gain = stats_LG.p(2);

DATA.BaselineLA.Betas = b_LG;
DATA.BaselineLA.Dev = d_LG;
DATA.BaselineLA.Stats = stats_LG;
DATA.BaselineLA.LA = LA;
DATA.BaselineLA.IP = IP;
DATA.BaselineLA.EVlow = EV_low;
DATA.BaselineLA.EVhigh = EV_high;

%model risk aversion
all_trials_RA = DATA.Trials1.RA;
all_trials_RA(all_trials_RA(:,6)==-999,:)=[];
% all_trials_RA(all_trials_RA(:,6)==-1,6)=0;
[b_RA,d_RA,stats_RA]=glmfit(all_trials_RA(:,8),all_trials_RA(:,6),'binomial','link','logit');

IP_RA = -b_RA(1)/b_RA(2)
p_RA = stats_RA.p(2)

DATA.BaselineRA.Betas = b_RA;
DATA.BaselineRA.Dev = d_RA;
DATA.BaselineRA.Stats = stats_RA;
DATA.BaselineRA.IP = IP_RA;
DATA.BaselineRA.DiffEV = IP_RA-sure_option;

DATA.TrialsCombined1 = [all_trials(:,1) zeros(length(all_trials(:,1)),1) all_trials(:,2:8); all_trials_RA(:,1:2) zeros(length(all_trials_RA(:,1)),1) all_trials_RA(:,3:8)];
DATA.TrialsCombined1 = sortrows(DATA.TrialsCombined1,1);

%% Determine indifference points to build fixed matrix for 2nd part of the task
IPlr = floor(IP);
%select closest rounded indifference point at 0.5 precision
if IP - IPlr <= 0.25
    indiff_l = IPlr;
elseif IP-IPlr > 0.25 && IP-IPlr < 0.75
    indiff_l = IPlr + 0.5;
elseif IP-IPlr >=0.75
    indiff_l = IPlr +1;
end
if indiff_l < -0.5
    indiff_l = -0.5; %indifference point cannot be lower than 0.5 otherwise gains will become negative values
end
if indiff_l > 10
    indiff_l = 10; %indifference point cannot be higher than 10 otherwise gain will become higher than 30 and main task will crash
end
DATA.BaselineLA.IProunded = indiff_l;

IPrr = floor(IP_RA);
if IP_RA - IPrr <= 0.25
    indiff_r = IPrr;
elseif IP_RA-IPrr > 0.25 && IP_RA-IPrr < 0.75
    indiff_r = IPrr + 0.5;
elseif IP_RA-IPrr >=0.75
    indiff_r = IPrr +1;
end
if indiff_r < -2
    indiff_r = -2; %indifference point cannot be lower than 0.5 otherwise high gain will become (much) lower than sure option
end
if indiff_r > 8
    indiff_r = 8; %indifference point cannot be higher than 8 otherwise high gain will become higher than 30 and main task will crash
end
DATA.BaselineRA.IProunded = indiff_r;

save(['data\Sub' subno '\' filename],'DATA','parameters');

recap_trials = DATA.TrialsCombined1(:,[2,3,4,9,7]);
recap_trials(recap_trials(:,1)<0,:)=[];
recap_trials(recap_trials(:,3)<0,:)=[];
recap_trials(recap_trials(:,2)>0,:)=[];
DATA.RecapTrialsEndPart1 = recap_trials;
DATA.ModelPart1.LossRiskAversion = [];

%estimate risk and loss aversion parameters after staircase
%Setup solver opt 
opts= optimset('Algorithm','interior-point',...
    'MaxIter',400,...                                              % maximum number of tries before stoping 
    'MaxFunEvals',200,...                                          % number of tries of the model per parameter set
    'TolFun',0.001,...                                             % convergence threshold for likelihood fcn
    'TolX',0.001...                                                % parameter increments 
    );
params_rand=[];       % Create empty array to sort parameters
for i_rand=1:10 %run each model 20 times with different starting point to find best parameter estimates
    start = [rand()+0.5 2*rand()+1 rand()+0.2];
    [paramtracker1, lltracker1, ex1,~,~,~,H] = fmincon(@loss_risk_aversion_estimation, [start], [],[],[],[],[0 0 0],[+Inf +Inf +Inf],[],opts,recap_trials);
    params_rand=[params_rand; paramtracker1 lltracker1 ex1 sqrt(diag(inv(H)))' sqrt(diag(inv(H)))'.*1.96];
end
bad_fit = params_rand(:,5)==0 | params_rand(:,5)==-1 | params_rand(:,5)==-2;
if sum(bad_fit)<10
    params_rand(bad_fit,:)=[];
end
[~,ids] = sort(params_rand(:,4));
best_params = params_rand(ids(1),:);
npar = 3;
ntrials = length(recap_trials(:,1));
BIC = 2*best_params(4) + npar*log(ntrials);
pseudoR2 = 1 + best_params(4)/(log(0.5)*ntrials);
DATA.ModelPart1.LossRiskAversion = [{'mu' 'lambda' 'rho' 'loglikelihood' 'BIC' 'pseudoR2' 'exit flag' 'invH mu' 'invH lambda' 'invH rho'}; ...
    [num2cell(best_params(1:4)) {BIC} {pseudoR2} num2cell(best_params(5:8))]];


%preparestring('You can take a break.',1,0,100);
preparestring('Press any key to continue.',1,0,0);
drawpict(1);
waitkeydown(inf);
clearpict(1);

%% Build gamble matrix for second part

LA = DATA.ModelPart1.LossRiskAversion{2,2};
Rho = DATA.ModelPart1.LossRiskAversion{2,3};

%CONSTRUCT TRIAL MATRIX (8 by 8) FOR LOSS AVERSION
losses = [-10;-8;-6;-5;-4;-3;-2;-1];
gains = round(exp(log(LA)/Rho+log(-losses)));
DATA.SEVmatrix.LA = 1;
if min(gains)<=0 || max(gains)>30  
    indiff = DATA.BaselineLA.IProunded;
    gains = 2*(indiff - 0.5*losses);
    DATA.SEVmatrix.LA = 0;
end
nb_asso = length(gains)*length(losses);
DATA.FinalMatrix.LossesLA = losses;
DATA.FinalMatrix.GainsLA = gains;

k=1;
gamble_pairs=zeros(nb_asso,2);
for i=1:length(losses)
    for j=1:length(gains)
        gamble_pairs(k,1)=0; %sure option
        gamble_pairs(k,2)=losses(i);
        gamble_pairs(k,3)=gains(j);
        if DATA.SEVmatrix.LA == 0
            gamble_pairs(k,4)=0.5*gains(j)+0.5*losses(i)-indiff; %subjective expected value based on IP
        else gamble_pairs(k,4)=0.5*gains(j)^Rho-0.5*LA*(-losses(i))^Rho; %subjective expected value
        end
        gamble_pairs(k,5)=0.5*losses(i)+0.5*gains(j); %objective expected value
        k=k+1;
    end
end
gamble_pairs = sortrows(gamble_pairs,4);

%CONSTRUCT TRIAL MATRIX (6 by 6) FOR RISK AVERSION
sure = [2;3;4;5;6;7];
gain_high = round(exp(log(2)/Rho+log(sure)));
DATA.SEVmatrix.RA = 1;
if min(gain_high-sure)<=0 || max(gain_high)>30 
    indiffr = DATA.BaselineRA.IProunded;
    gain_high = 2*(indiffr + sure);
    DATA.SEVmatrix.RA = 0;
end
nb_asso_RA = length(sure)*length(gain_high);
DATA.FinalMatrix.SureOptionRA = sure;
DATA.FinalMatrix.HighGainsRA = gain_high;

k=1;
gamble_sure_asso=zeros(nb_asso_RA,4);
for i=1:length(sure)
    for j=1:length(gain_high)
        gamble_sure_asso(k,1)=sure(i);
        gamble_sure_asso(k,3)=gain_high(j);
        if DATA.SEVmatrix.RA == 0
            gamble_sure_asso(k,4)=0.5*gain_high(j)-sure(i)-indiffr; %SEV difference based on IP
        else gamble_sure_asso(k,4)=0.5*gain_high(j)^Rho-sure(i)^Rho; %SEV difference
        end
        gamble_sure_asso(k,5)=0.5*gain_high(j)-sure(i);
        k=k+1;
    end
end
gamble_sure_asso = sortrows(gamble_sure_asso,4);

gamble_pairs_all = [gamble_pairs;gamble_sure_asso];
nt2 = length(gamble_pairs_all(:,1));

parameters.nt2 = nt2;
trial_list2 = [randperm(nt2)' gamble_pairs_all];
trial_list2 = sortrows(trial_list2,1);
parameters.trial_list2 = trial_list2;
save(['data\Sub' subno '\' filename],'DATA','parameters');

%% Trial loop part 2

cgsetsprite(0);
cgflip(0,0,0);

cgdrawsprite(3,0,0);
t_fix = cgflip(0,0,0);

for j=1:nt2

    %extract trial characteristics for trial i
    sure = trial_list2(j,2); %sure option value
    loss = trial_list2(j,3); %loss value
    gain = trial_list2(j,4); %gain value

    wait(1000); % wait 1 sec while fixation cross is on
    cgsetsprite(0);
    cgflip(0,0,0);
        
    if trial_list2(j,2) == 0 %loss aversion trial (no sure option)
        posg=floor(2*rand+1); %randomized left/right position of gamble vs sure option
        parameters.gamblepos2(j,1)=posg;
        pos=floor(2*rand+1); %randomized left/right position of gain and loss
        parameters.gainlosspos2(j,1)=pos;
        if posg==1 %gamble on the left
            sgamble=-256;
            if pos==1
                sloss=-331; %display loss on the left hemicircle
                sgain=-181; %display gain on the right hemicircle
            elseif pos==2
                sloss=-181; %display loss on the right hemicircle
                sgain=-331; %display gain on the left hemicircle
            end
        elseif posg==2 %gamble on the right
            sgamble=256;
            if pos==1
                sloss=181; %display loss on the left hemicircle
                sgain=331; %display gain on the right hemicircle
            elseif pos==2
                sloss=331; %display loss on the right hemicircle
                sgain=181; %display gain on the left hemicircle
            end
        end

        %draw circle and line in which to display the gamble
        cgmakesprite (2, sc_width, sc_height, 0,0,0);    %make black ratesprite
        cgdrawsprite(2,0,0);                    %ready sprite to draw into
        cgalign ('c', 'c');                     %center alignment
        cgpencol (1, 1, 1);                     %white on grey background
        cgpenwid(5);                            %set pen width
        cgellipse(-256, 0, 300, 300);           %draw circles
        cgellipse(256, 0, 300, 300);
        cgfont ('Helvetica', 45)
        cgtext(['EUR ' '0'], -sgamble, 0);
        cgdraw(sgamble, 150, sgamble, -150);    %draw vertical line for gamble
        cgfont ('Helvetica', 40)
        cgpencol(1, 0, 0);                      %make red pen for lose
        cgtext('LOSE', sloss, 25);
        cgtext(['EUR ' num2str(abs(loss))], sloss, -25);
        cgpencol(0, 1, 0);                      %make green pen for gain
        cgtext('WIN', sgain, 25);
        cgtext(['EUR ' num2str(gain)], sgain, -25);

    elseif trial_list2(j,3) == 0 %risk aversion trial (no loss)

        posg=floor(2*rand+1); %randomized left/right position of gamble vs sure option
        parameters.gamblepos2(j,1)=posg;
        pos=floor(2*rand+1); %randomized left/right position of gain and 0 in the gamble
        parameters.gainlosspos2(j,1)=pos;
        if posg==1 %gamble on the left
            sgamble=-256;
            if pos==1
                szero=-331; %display loss on the left hemicircle
                sgain=-181; %display gain on the right hemicircle
            elseif pos==2
                szero=-181; %display loss on the right hemicircle
                sgain=-331; %display gain on the left hemicircle
            end
        elseif posg==2 %gamble on the right
            sgamble=256;
            if pos==1
                szero=181; %display loss on the left hemicircle
                sgain=331; %display gain on the right hemicircle
            elseif pos==2
                szero=331; %display loss on the right hemicircle
                sgain=181; %display gain on the left hemicircle
            end
        end

        %draw circle and line in which to display the gamble
        cgmakesprite (2, sc_width, sc_height, 0,0,0);    %make black ratesprite
        cgdrawsprite(2,0,0);                    %ready sprite to draw into
        cgalign ('c', 'c');                     %center alignment
        cgpencol (1, 1, 1);                     %white on grey background
        cgpenwid(5);                            %set pen width
        cgellipse(-256, 0, 300, 300);           %draw circles
        cgellipse(256, 0, 300, 300);
        cgdraw(sgamble, 150, sgamble, -150);    %draw vertical line for gamble
        cgfont ('Helvetica', 40)
        cgpencol(0, 1, 0);                      %make green pen for gain
        cgtext('WIN', -sgamble, 25);
        cgtext(['EUR ' num2str(sure)], -sgamble, -25);
        cgtext('WIN', sgain, 25);
        cgtext(['EUR ' num2str(gain)], sgain, -25);
        cgpencol(1, 1, 1); 
        cgfont ('Helvetica', 45)
        cgtext(['EUR ' '0'], szero, 0);
        cgfont ('Helvetica', 40)
    end

    t_gamble = cgflip(0,0,0);
    trial_list2(j,7) = t_gamble; %record onset of the gamble

    clearkeys;
    no_response=1;
    while no_response==1
        readkeys;
        wait(5);
        logkeys;
        [keyout,buttontime,npress] = getkeydown;
        t1=time;
        if (t1 - t_gamble*1000) > 3000 % if more than 3 sec has elapsed, move on
            Resp = -999;
            buttontime = t_gamble*1000 + 3000;
            no_response = 0;
            break
        elseif isempty(keyout)==1 %if no button is pressed, do nothing and continue looping
        elseif keyout==97 %left arrow pressed
            if posg==1 %gamble also on the left, ie accepted
                Resp=1;
                no_response=0;
                break
            elseif posg==2 %gamble on the right, ie rejected
                Resp=0;
                no_response=0;
                break
            end
        elseif keyout==98 %right arrow pressed
            if posg==1 %gamble rejected
                Resp=0;
                no_response=0;
                break
            elseif posg==2 %gamble accepted
                Resp=1;
                no_response=0;
                break
            end
        end
    end
    Resp_time = buttontime/1000-t_gamble; %calculate reaction time in secs

    trial_list2(j,8) = Resp; %record response in trial_list matrix, column 6
    trial_list2(j,9) = Resp_time; %record reaction time in trial_list matrix, column 7

    cgdrawsprite(3,0,0);
    t_fix = cgflip(0,0,0);

end

DATA.Missed2 = sum(trial_list2(:,8)==-999);
DATA.TrialsCombined2 = trial_list2;
DATA.TrialsCombined2(DATA.TrialsCombined2(:,8)==-999,:)=[];
DATA.Trials2.LA = trial_list2(trial_list2(:,2)==0,:);
DATA.Trials2.RA = trial_list2(trial_list2(:,2)~=0,:);
save(['data\Sub' subno '\' filename],'DATA','parameters');

good_trials = [DATA.TrialsCombined1(:,[2:4 9 7]);DATA.TrialsCombined2(:,[2:4 6 8])];
DATA.AllTrials = good_trials;
% Determine outcome from 10 randomly selected trials.
%[outcomes, av_outcome, total, sel_trials]=Show_outcomes_combined(good_trials,sc_width,sc_height); 
[outcomes, av_outcome, ~]=Select_outcomes_combined(good_trials);
DATA.Outcomes.List    = outcomes;
DATA.Outcomes.Average = av_outcome;
save(['data\Sub' subno '\' filename],'DATA','parameters');

stop_cogent

%% Run modelling of risk and loss aversion on second part on the task only
recap_trials2 = DATA.TrialsCombined2(:,[2,3,4,6,8,5]);
recap_trials2(recap_trials2(:,1)<0,:)=[];
recap_trials2(recap_trials2(:,3)<0,:)=[];
recap_trials2(recap_trials2(:,2)>0,:)=[];
DATA.ModelPart2.LossRiskAversion = [];
DATA.ModelPart2.LossAversionOnly = [];
DATA.ModelPart2.RiskAversionOnly = [];
ntrials = length(recap_trials2(:,1));

%estimate loss and risk aversion in same model
params_rand=[];       % Create empty array to sort parameters
for i_rand=1:20 %run each model 20 times with different starting point to find best parameter estimates
    start = [rand()+0.5 2*rand()+1 rand()+0.2];
    [paramtracker1, lltracker1, ex1,~,~,~,H] = fmincon(@loss_risk_aversion_estimation, [start], [],[],[],[],[0 0 0],[+Inf +Inf +Inf],[],opts,recap_trials2);
    params_rand=[params_rand; paramtracker1 lltracker1 ex1 sqrt(diag(inv(H)))' sqrt(diag(inv(H)))'.*1.96];
end
bad_fit = params_rand(:,5)==0 | params_rand(:,5)==-1 | params_rand(:,5)==-2;
if sum(bad_fit)<10
    params_rand(bad_fit,:)=[];
end
[~,ids] = sort(params_rand(:,4));
best_params = params_rand(ids(1),:);
npar = 3;
BIC = 2*best_params(4) + npar*log(ntrials);
pseudoR2 = 1 + best_params(4)/(log(0.5)*ntrials);
DATA.ModelPart2.LossRiskAversion = [{'mu' 'lambda' 'rho' 'loglikelihood' 'BIC' 'pseudoR2' 'exit flag' 'invH mu' 'invH lambda' 'invH rho'}; ...
    [num2cell(best_params(1:4)) {BIC} {pseudoR2} num2cell(best_params(5:8))]];

%estimate loss aversion only
params_rand=[];       % Create empty array to sort parameters
for i_rand=1:20 %run each model 20 times with different starting point to find best parameter estimates
    start = [rand()+0.5 2*rand()+1];
    [paramtracker1, lltracker1, ex1,~,~,~,H] = fmincon(@loss_aversion_estimation, [start], [],[],[],[],[0 0],[+Inf +Inf],[],opts,recap_trials2);
    params_rand=[params_rand; paramtracker1 lltracker1 ex1 sqrt(diag(inv(H)))' sqrt(diag(inv(H)))'.*1.96];
end
bad_fit = params_rand(:,4)==0 | params_rand(:,4)==-1 | params_rand(:,4)==-2;
if sum(bad_fit)<10
    params_rand(bad_fit,:)=[];
end
[~,ids] = sort(params_rand(:,3));
best_params = params_rand(ids(1),:);
npar = 2;
BIC = 2*best_params(3) + npar*log(ntrials);
pseudoR2 = 1 + best_params(3)/(log(0.5)*ntrials);
DATA.ModelPart2.LossAversionOnly = [{'mu' 'lambda' 'loglikelihood' 'BIC' 'pseudoR2' 'exit flag' 'invH mu' 'invH lambda'}; ...
    [num2cell(best_params(1:3)) {BIC} {pseudoR2} num2cell(best_params(4:6))]];

%estimate risk aversion only
params_rand=[];       % Create empty array to sort parameters
for i_rand=1:20 %run each model 20 times with different starting point to find best parameter estimates
    start = [rand()+0.5 rand()+0.2];
    [paramtracker1, lltracker1, ex1,~,~,~,H] = fmincon(@risk_aversion_estimation, [start], [],[],[],[],[0 0],[+Inf +Inf],[],opts,recap_trials2);
    params_rand=[params_rand; paramtracker1 lltracker1 ex1 sqrt(diag(inv(H)))' sqrt(diag(inv(H)))'.*1.96];
end
bad_fit = params_rand(:,4)==0 | params_rand(:,4)==-1 | params_rand(:,4)==-2;
if sum(bad_fit)<10
    params_rand(bad_fit,:)=[];
end
[~,ids] = sort(params_rand(:,3));
best_params = params_rand(ids(1),:);
npar = 2;
BIC = 2*best_params(3) + npar*log(ntrials);
pseudoR2 = 1 + best_params(3)/(log(0.5)*ntrials);
DATA.ModelPart2.RiskAversionOnly = [{'mu' 'rho' 'loglikelihood' 'BIC' 'pseudoR2' 'exit flag' 'invH mu' 'invH rho'}; ...
    [num2cell(best_params(1:3)) {BIC} {pseudoR2} num2cell(best_params(4:6))]];

%% Run modelling of risk and loss aversion on all trials (part 1 + part 2)
DATA.ModelAll.LossRiskAversion = [];
DATA.ModelAll.LossAversionOnly = [];
DATA.ModelAll.RiskAversionOnly = [];
ntrials = length(good_trials(:,1));

%estimate loss and risk aversion in same model
params_rand=[];       % Create empty array to sort parameters
for i_rand=1:20 %run each model 20 times with different starting point to find best parameter estimates
    start = [rand()+0.5 2*rand()+1 rand()+0.2];
    [paramtracker1, lltracker1, ex1,~,~,~,H] = fmincon(@loss_risk_aversion_estimation, [start], [],[],[],[],[0 0 0],[+Inf +Inf +Inf],[],opts,good_trials);
    params_rand=[params_rand; paramtracker1 lltracker1 ex1 sqrt(diag(inv(H)))' sqrt(diag(inv(H)))'.*1.96];
end
bad_fit = params_rand(:,5)==0 | params_rand(:,5)==-1 | params_rand(:,5)==-2;
if sum(bad_fit)<10
    params_rand(bad_fit,:)=[];
end
[~,ids] = sort(params_rand(:,4));
best_params = params_rand(ids(1),:);
npar = 3;
BIC = 2*best_params(4) + npar*log(ntrials);
pseudoR2 = 1 + best_params(4)/(log(0.5)*ntrials);
DATA.ModelAll.LossRiskAversion = [{'mu' 'lambda' 'rho' 'loglikelihood' 'BIC' 'pseudoR2' 'exit flag' 'invH mu' 'invH lambda' 'invH rho'}; ...
    [num2cell(best_params(1:4)) {BIC} {pseudoR2} num2cell(best_params(5:8))]];

%estimate loss aversion only
params_rand=[];       % Create empty array to sort parameters
for i_rand=1:20 %run each model 20 times with different starting point to find best parameter estimates
    start = [rand()+0.5 2*rand()+1];
    [paramtracker1, lltracker1, ex1,~,~,~,H] = fmincon(@loss_aversion_estimation, [start], [],[],[],[],[0 0],[+Inf +Inf],[],opts,good_trials);
    params_rand=[params_rand; paramtracker1 lltracker1 ex1 sqrt(diag(inv(H)))' sqrt(diag(inv(H)))'.*1.96];
end
bad_fit = params_rand(:,4)==0 | params_rand(:,4)==-1 | params_rand(:,4)==-2;
if sum(bad_fit)<10
    params_rand(bad_fit,:)=[];
end
[~,ids] = sort(params_rand(:,3));
best_params = params_rand(ids(1),:);
npar = 2;
BIC = 2*best_params(3) + npar*log(ntrials);
pseudoR2 = 1 + best_params(3)/(log(0.5)*ntrials);
DATA.ModelAll.LossAversionOnly = [{'mu' 'lambda' 'loglikelihood' 'BIC' 'pseudoR2' 'exit flag' 'invH mu' 'invH lambda'}; ...
    [num2cell(best_params(1:3)) {BIC} {pseudoR2} num2cell(best_params(4:6))]];

%estimate risk aversion only
params_rand=[];       % Create empty array to sort parameters
for i_rand=1:20 %run each model 20 times with different starting point to find best parameter estimates
    start = [rand()+0.5 rand()+0.2];
    [paramtracker1, lltracker1, ex1,~,~,~,H] = fmincon(@risk_aversion_estimation, [start], [],[],[],[],[0 0],[+Inf +Inf],[],opts,good_trials);
    params_rand=[params_rand; paramtracker1 lltracker1 ex1 sqrt(diag(inv(H)))' sqrt(diag(inv(H)))'.*1.96];
end
bad_fit = params_rand(:,4)==0 | params_rand(:,4)==-1 | params_rand(:,4)==-2;
if sum(bad_fit)<10
    params_rand(bad_fit,:)=[];
end
[~,ids] = sort(params_rand(:,3));
best_params = params_rand(ids(1),:);
npar = 2;
BIC = 2*best_params(3) + npar*log(ntrials);
pseudoR2 = 1 + best_params(3)/(log(0.5)*ntrials);
DATA.ModelAll.RiskAversionOnly = [{'mu' 'rho' 'loglikelihood' 'BIC' 'pseudoR2' 'exit flag' 'invH mu' 'invH rho'}; ...
    [num2cell(best_params(1:3)) {BIC} {pseudoR2} num2cell(best_params(4:6))]];

save(['data\Sub' subno '\' filename],'DATA','parameters');

return
