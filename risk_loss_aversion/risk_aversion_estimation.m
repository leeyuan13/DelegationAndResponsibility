      %this version of the model estimates lambda and mu
      %lambda estimated separately for the emotion (happy + fearful) and no emotion (neutral + object) condition :

      % P is a "parameter" matrix, representing experimental design (gambles).  
      % rows are trials, column 1 is the value of the sure option, 
      % column 2 is the value of the potential loss,
      % column 3 is the value of the potential gain, 
      % column 4 is the binary choice variable: y value (1 if gamble
      % accepted, 0 if gamble rejected).

      
      function f = risk_aversion_estimation(x,P)
      f = 0;
      
      %sum log likelihood for each observation (trial)
      
      for i=1:1:length(P)
          %xb is the "index" of the binary choice model, eg: expected
          %utility
          xb=x(1)*(0.5*P(i,3)^x(2)-0.5*abs(P(i,2))^x(2)-P(i,1)^x(2));
          %x(1) is mu
          %x(2) is rho
          %xb is the "index" of the binary choice model, eg: expected
          %utility
        
          %if choice value is 1, use one part of likelihood contribution.
          if(P(i,5)==1)
              f=f+log((1+exp(-1*xb))^-1);
                  
          %if choice value is 0, use other part of likelihood contribution    
          elseif(P(i,5)==0)
             f=f+log(1-(1+exp(-1*xb))^-1);
          
          end
      end

      f=f*-1; %negative value of loglikelihood
          

