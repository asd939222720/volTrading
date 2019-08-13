%%
clear;clc;

addpath(genpath(pwd));

TicksInOnePeriod = 600;

[rit, tickerNames, tickerVarNames, newsVarNames, positionVarNames] = Initialize();

newsInfo = GetNewsInfo(rit, newsVarNames);

LastTick = 0;
while LastTick<TicksInOnePeriod-2
    try
        AutoTradeProgram;
    catch e
        disp(e);
    end
         
end
    
