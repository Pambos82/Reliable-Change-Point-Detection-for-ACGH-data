function results = kernels(pvalues,~,epsilon,significance_l)
% kernels implements the cautious betting function combined with a kernel.
%
% This function analyses a vector of p-values using a cautious betting strategy alongside
% a kernel density estimation to detect significant deviations from the
% exchangeability assumption. 
%
% Inputs:
%   pvalues - A vector of p-values to analyze.
%   epsilon - Threshold epsilon for adjusting betting strategy based on previous outcomes.
%   significance_l - The significance level threshold for rejecting the exchangeability assumption.
%
% Outputs:
%   results - A vector of martingale values up to the point where the exchangeability 
%             assumption is rejected. This indicates accumulating evidence against the null hypothesis.
%
% Example usage:
%    pvalues=[rand(1,1000) rand(1,1000).^2]
%   results = kernels(pvalues,  100, 0.01)
%
% Reference:
%   Eliades and Papadopoulos (2024), PMLR 230:387-405.

% Initialize strategy variables: S2, S1 for Martingales values
% f1 and f2 for the betting functions.
    S2(1:length(pvalues))=0;
   S1(1:length(pvalues))=0;
   f2(1:length(pvalues))=1;
   f1(1:length(pvalues))=1;


                       
           
           for i=2:length(pvalues)

 [f2(i),~]=ksdensity([pvalues(max(1,i-100):i-1)' ],pvalues(i),"support",[-10^-6 1+10^-6],"BoundaryCorrection","reflection");      

 f2(i)=max(f2(i),10^(-10));
 m=1;
      

                   m=S2(i-1)-min(S2(max(i-5000,1):i-1));
                    if m>log(epsilon)
                      f1(i)=f2(i);   
                       
                    end
                    
                
    
                  S2(i)=S2(i-1)+log(f2(i));
                    S1(i)= S1(i-1)+log(f1(i));
                          
                %     if(S1(i)>log(1/significance_l))
                %     break
                % 
                % end
                end
                
                
                
                results=S1(1:i);
            end