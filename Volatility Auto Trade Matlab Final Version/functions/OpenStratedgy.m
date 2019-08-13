function trades = OpenStratedgy(priceTable)

[bestCallToLong, bestPutToLong, bestCallToShort, bestPutToShort] = BestOptionToTrade(priceTable);

AmountPerSecond = 100;

trades(1).Ticker = '';
trades(1).BuyOrSell = 'Buy';
trades(1).Amount = 0;
trades(1).Weight = 0;
if bestCallToLong.value >= bestPutToLong.value && bestCallToLong.value > 0.15
    trades(end+1).Ticker = bestCallToLong.ticker;
    trades(end).BuyOrSell = 'Buy';
    trades(end).Amount = AmountPerSecond;
    trades(end).Weight = 1;
end

if bestPutToLong.value > bestCallToLong.value && bestPutToLong.value > 0.15
    trades(end+1).Ticker = bestPutToLong.ticker;
    trades(end).BuyOrSell = 'Buy';
    trades(end).Amount = AmountPerSecond;
    trades(end).Weight = 1;
end

if bestCallToShort.value >= bestPutToShort.value && bestCallToShort.value > 0.15
    trades(end+1).Ticker = bestCallToShort.ticker;
    trades(end).BuyOrSell = 'Sell';
    trades(end).Amount = AmountPerSecond;
    trades(end).Weight = 1;
end



if bestPutToShort.value > bestCallToShort.value && bestPutToShort.value > 0.15
    trades(end+1).Ticker = bestPutToShort.ticker;
    trades(end).BuyOrSell = 'Sell';
    trades(end).Amount = AmountPerSecond;
    trades(end).Weight = 1;
end

%% Between Options
Diff = priceTable.DiffFromAverage;
isValid = IsValidPairOption(priceTable);
Diff(~isValid) = NaN;
[maxDiff, indMax] = max(Diff);
[minDiff, indMin] = min(Diff);
if maxDiff - minDiff > 0.20 && indMax~=1 && indMin~=1 && priceTable.MarketPrice(indMax)>=0.05 && priceTable.MarketPrice(indMin)>=0.05
    trades(end+1).Ticker = priceTable.Properties.RowNames{indMax};
    trades(end).BuyOrSell = 'Sell';
    trades(end).Amount = AmountPerSecond;
    trades(end).Weight = 1;
    trades(end+1).Ticker = priceTable.Properties.RowNames{indMin};
    trades(end).BuyOrSell = 'Buy';
    trades(end).Amount = AmountPerSecond;
    trades(end).Weight = 1;    
end

%%
trades = trades(2:end);

for trade = trades
    disp([trade.Ticker ' ' trade.BuyOrSell ' ' num2str(trade.Amount)]);
end

end

