function [outcomes, av_outcome, total, sel_trials]=Show_outcomes_combined(good_trials,sc_width,sc_height)

preparestring('Now the program will randomly select 10 trials from',1,0,140);
preparestring('the task, show you which option you chose and',1,0,60);
preparestring('the corresponding outcomes.',1,0,-20);
preparestring('Press space to start.',1,0,-180);
drawpict(1);
waitkeydown(inf,71);
clearpict(1);

%%

rand_trials = randperm(length(good_trials)); %randomly select 10 trial numbers
sel_trials  = rand_trials(1:10);
outcomes    = zeros(10,1);

cgsetsprite(0);
cgflip(0,0,0);

for i=1:10

    sel_trial_data = good_trials(sel_trials(i),:);
    sure   = sel_trial_data(1);
    loss   = sel_trial_data(2);
    gain   = sel_trial_data(3);
    choice = sel_trial_data(5);
        
    posg=floor(2*rand+1); %randomized left/right position of gamble vs sure option
    pos=floor(2*rand+1); %randomized left/right position of gain and loss
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
    if sure == 0 %if sure option is 0, then loss aversion trial
        cgtext('$0', -sgamble, 0);
        cgdraw(sgamble, 150, sgamble, -150);    %draw vertical line for gamble
        cgfont ('Helvetica', 40)
        cgpencol(1, 0, 0);                      %make red pen for lose
        cgtext('LOSE', sloss, 25);
        cgtext(['$' num2str(abs(loss))], sloss, -25);
        cgpencol(0, 1, 0);                      %make green pen for gain
        cgtext('WIN', sgain, 25);
        cgtext(['$' num2str(gain)], sgain, -25);
    else %risk aversion trial
        cgfont ('Helvetica', 45)
        cgtext('$0', sloss, 0);
        cgdraw(sgamble, 150, sgamble, -150);    %draw vertical line for gamble
        cgfont ('Helvetica', 40)
        cgpencol(0,1,0)
        cgtext('WIN', -sgamble, 25);
        cgtext(['$' num2str(sure)], -sgamble, -25);
        cgtext('WIN', sgain, 25);
        cgtext(['$' num2str(gain)], sgain, -25);
    end
    cgpencol (1, 1, 1); 
    cgfont ('Helvetica', 35)
    cgtext([num2str(i) '/10'], -450, 330);
    if choice == 1
        cgtext('You chose the GAMBLE', 0, -200);
    elseif choice == 0
        cgtext('You chose the SURE OPTION', 0, -200);
    end
    cgfont ('Helvetica', 30)
    cgtext('Press space to see outcome',0,-250);
        
    cgflip(0,0,0);
    waitkeydown(inf,71);
        
    cgfreesprite(3)
    cgmakesprite(3, sc_width, sc_height, 0,0,0);
    cgsetsprite(3);
    cgpencol(1,1,1);
    cgfont ('Helvetica', 40)
    if choice == 0
        cgtext([num2str(i) '/10'], -450, 330);
        cgtext('Trial outcome =', 0, 120);
        if sure == 0
            cgtext('$0', 0, 20);
        else cgpencol(0,1,0)
            cgtext(['WIN $ ' num2str(sure)],0,20);
            cgpencol(1,1,1)
        end
        outcomes(i)=sure;
        cgtext('Press space for next trial', 0, -150);
    elseif choice == 1
        r=randperm(2);
        gamb=(r(1));
        if gamb==1 %win
            cgtext([num2str(i) '/10'], -450, 330);
            cgtext('Trial outcome =', 0, 120);
            cgpencol(0, 1, 0);
            cgtext(['WIN $ ' num2str(gain)], 0, 20);
            cgpencol(1, 1, 1)
            cgtext('Press for space next trial', 0, -150);
            outcomes(i)=gain;
        elseif gamb==2 %lose
            cgtext([num2str(i) '/10'], -450, 330);
            cgtext('Trial outcome =', 0, 120);
            if loss == 0
                cgtext('$0',0,20)
            else cgpencol(1, 0, 0);
                cgtext(['LOSE $ ' num2str(abs(loss))], 0, 20);
                cgpencol(1, 1, 1);
            end
            cgtext('Press space for next trial', 0, -150);
            outcomes(i)=loss;
        end
    end
    cgsetsprite(0)
    cgflip(0,0,0)
    cgdrawsprite(3,0,0);
    cgflip(0,0,0);   
    waitkeydown(inf,71);
end


av_outcome = mean(outcomes);
cgpencol(1,1,1);
cgtext('Average outcome of 10 trials:',0,120);
if av_outcome>0
    cgpencol(0,1,0);
    cgtext(['+ $ ' num2str(av_outcome)],0,20);
elseif av_outcome<0
    cgpencol(1,0,0);
    cgtext(['- $ ' num2str(abs(av_outcome))],0,20);
elseif av_outcome==0
    cgpencol(1,1,1);
    cgtext('$ 0',0,20);
end

if av_outcome>0
    total=20+av_outcome;
else
    total=20+av_outcome;
end

cgpencol(1,1,1);
cgtext(['Total earnings:  $ ' num2str(total)],0,-100);
cgflip(0,0,0);
wait(3000);
waitkeydown(inf);

cgfreesprite(3)
cgsetsprite(0)
cgflip(0,0,0)

end