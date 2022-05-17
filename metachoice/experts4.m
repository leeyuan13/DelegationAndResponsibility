function [ experts, expertsEV ] = experts4(blockLength)
% Generates advisor/bot parameters over a range of expected values.
% Returns experts = array of advisor parameters,
%         and expertsEV = array of advisor expected values.
% Each row of experts (or expertsEV) refers to a single advisor.
%  experts(:, 1) = advisor's accuracy
%  experts(:, 2) = advisor's cost
%  experts(:, 3) = whether the advisor has an accuracy > 0.5
%  experts(:, 4) = whether the advisor has an expected value > 0.5
% Note that the players' expected value is always 0.5.

% Based on a script written by Sebastian Bobadilla-Suarez.

% Modified by:
%  Yuan Lee
%  May 2022

err = 1750;

targetEV1 = linspace(501, 999, blockLength/2)/10;
accs1 = NaN(1, length(targetEV1));
for i = 1:length(targetEV1)
    accs_temp = (targetEV1(i):0.1:100)/100; %good experts    
    accs1(i) = datasample(accs_temp,1);
end

costs1_max = 1-(targetEV1./100./accs1);
costs1=floor(costs1_max*10000);
costs1_res = NaN(1, length(costs1));
for i = 1:length(costs1)
    if costs1(i)==0
        cost_temp = 0;
    else
        cost_temp = datasample(1:costs1(i),1);
    end
    costs1_res(i) = (costs1(i)-cost_temp)/10000;
    costs1(i) = cost_temp/10000;
end

costs_res_temp1 = sum(floor(costs1_res*10000));

targetEV2 = linspace(1, 500, blockLength/4)/10;
accs2 = NaN(1, length(targetEV2));
for i = 1:length(targetEV2)
    if targetEV2(i)<50.1
        accs_temp = (50.1:0.1:100)/100; %good experts
    else
        accs_temp = (targetEV2(i):0.1:100)/100; %good experts
    end
    accs2(i) = datasample(accs_temp,1);
end
costs2_min = 1-(targetEV2./100./accs2);
costs2=ceil(costs2_min*10000);

for i = 1:length(costs2)
    noise=randi(err);
cost_temp = datasample(1:(costs_res_temp1/4 + noise),1);
costs_res_temp1 = costs_res_temp1-cost_temp+ noise;
costs2(i) =(costs2(i)+cost_temp)/10000;
if costs2(i)>1
    costs_res_temp1 = costs_res_temp1 + (1-costs2(i));
    costs2(i)=1;
end
end

targetEV3 = linspace(1, 500, blockLength/4)/10;
accs3 = NaN(1, length(targetEV3));
for i = 1:length(targetEV3)
    accs_temp = (targetEV3(i):0.1:50)/100; %good experts
    accs3(i) = datasample(accs_temp,1);
end
costs3_min = 1-(targetEV3./100./accs3);
costs3=ceil(costs3_min*10000);

for i = 1:length(costs3)   
    noise = randi(err);
    cost_temp = datasample(1:(costs_res_temp1/4 + noise),1);
    costs_res_temp1 = costs_res_temp1-cost_temp+noise; %this is where charges are quite restricted
    costs3(i) = (costs3(i)+cost_temp)/10000;
    if costs3(i)>1
        costs_res_temp1 = costs_res_temp1 + (1-costs3(i));
        costs3(i)=1;
    end
end

accs = [accs1 accs2 accs3];
costs = [costs1 costs2 costs3];

% Experts' accuracies and costs.
% Permutate the order of experts.
experts = [accs' costs'];
experts = experts(randperm(length(experts)),:);

% Expected value of the experts = accuracy * (1-cost).
expertsEV = experts(:,1).*(1-experts(:,2));

% Add dummy variables for desirable properties of experts.
experts = [experts experts(:,1)>0.5 expertsEV>0.5];
end



