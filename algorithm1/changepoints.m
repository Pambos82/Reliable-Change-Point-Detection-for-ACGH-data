function changePoints = changepoints(sub, mask1, maskMinus1, sig,funcHandle)
    % Initialize loop variable
    m = 1;
    % Initialize pvalues array
   

    % Initialize the change points array
    changePoints = [];
    mask1(:)=1;%if you wish to use one martingale also remove +funcHandle(pvalues2,15, 10, sig);
    while m <= length(sub)
        pvalues=[];
        pvalues2=[];
        sub_ = zeros(1,length(sub)-m+1);
        for i = m:length(sub)
            t = i-m+1;
            segment = sub(m:i);
            if mask1(i) == 1
                sameSign = mask1(m:i);
            else
                sameSign = maskMinus1(m:i);
            end
            selected = segment(sameSign);
            pvalues(t) = (sum(selected < sub(i)) + rand*sum(selected == sub(i))) / numel(selected);
            sub_(t) = median(selected);
            history = sub_(1:t);
            selected = history(sameSign);
            pvalues2(t) = (sum(selected < sub_(t)) + rand*sum(selected == sub_(t))) / numel(selected);
        end
          

if any(isnan(pvalues))
    numNaNs = sum(isnan(pvalues));
    pvalues(isnan(pvalues)) = rand(1, numNaNs); % Replace NaNs with random values from a uniform distribution [0, 1]
    pvalues2(isnan(pvalues2)) = rand(1, numNaNs); % Replace NaNs with random values from a uniform distribution [0, 1]

end
        results1 = funcHandle(pvalues,15, 10, sig);%adding two martingales
        
        % Update loop variable m based on the latest instruction
        if (max(results1)>log(1/sig))
            index=find(results1>log(1/sig), 1, 'first');
        
            m = m + index; % next observation after the alarm
        
        else
                       break;
 
        end
        % Store the updated value of m-1 as a change point
        changePoints = [changePoints, m-1];
        
        % Example condition to exit loop if m exceeds or matches the length of sub
        if m > length(sub)
            break;
        end
    end
end

