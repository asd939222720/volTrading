%%
CurrentTick = 0;
LastTick = 0;
wasWaiting = true;
lastOpenTick = 0;
while(LastTick<TicksInOnePeriod-2)
    update(rit);
    CurrentTick = double(TicksInOnePeriod - rit.timeRemaining);
       
    if CurrentTick == 0
        disp('Wating...');
        pause(1);
        wasWaiting = true;
        continue;
        
    end
    if CurrentTick <= LastTick
        pause(0.01);
        continue;
    end  
    
    if wasWaiting
        newsInfo = GetNewsInfo(rit, newsVarNames);
        wasWaiting = false;
    end
    
    % Update data
    newsInfo = GetNewsInfo(rit, newsVarNames, newsInfo);
    [lastPrices, tick] = GetLastPrices(rit,tickerVarNames);
    CurrentTick = tick;    
    priceTable = ComparePrices(lastPrices,tick, tickerNames,newsInfo);
    positionInfo = GetPositions(rit,positionVarNames,tickerNames);
    currentPositions = positionInfo.Positions;
    
    
    % Close
    if tick - lastOpenTick > 12
        closeTrades = CloseStratedgy(positionInfo,priceTable);
        currentPositions = ExcuteTrades(rit,closeTrades, priceTable, newsInfo, tick, currentPositions);
    end
    % Open 
    openTrades = OpenStratedgy(priceTable);
    [currentPositions, isTraded] = ExcuteTrades(rit,openTrades, priceTable, newsInfo, tick, currentPositions);
    if isTraded
        lastOpenTick = tick;
    end
    % Hedge Delta
    currentDelta = GetPortfolioDelta(currentPositions,priceTable,newsInfo,tick);
    currentPositions = HedgeDelta(rit, currentDelta, currentPositions);
    hedgedDelta = GetPortfolioDelta(currentPositions,priceTable,newsInfo,tick);
            
    
    
    LastTick = CurrentTick;
end