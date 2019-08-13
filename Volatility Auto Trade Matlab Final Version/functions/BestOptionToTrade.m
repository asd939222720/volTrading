function [bestCallToLong, bestPutToLong, bestCallToShort, bestPutToShort] = BestOptionToTrade(priceTable)

tickerNames = priceTable.Properties.RowNames;
CallIndexes = contains(tickerNames,'C');
PutIndexes = contains(tickerNames,'P');

[value_call_short,index] = max(priceTable.OverValuedDiff(CallIndexes));
if ~isempty(value_call_short) && value_call_short > 0
    tickers = tickerNames(CallIndexes);
    bestCallToShort.ticker = tickers{index};
    bestCallToShort.value = value_call_short;
else
    bestCallToShort.ticker = '';
    bestCallToShort.value = 0;
end

[value_put_short,index] = max(priceTable.OverValuedDiff(PutIndexes));
if ~isempty(value_put_short) && value_put_short > 0 
    tickers = tickerNames(PutIndexes);
    bestPutToShort.ticker = tickers{index};
    bestPutToShort.value = value_put_short;
else
    bestPutToShort.ticker = '';
    bestPutToShort.value = 0;
end

[value_call_long,index] = max(priceTable.UnderValuedDiff(CallIndexes));
if ~isempty(value_call_long) && value_call_long > 0 
    tickers = tickerNames(CallIndexes);
    bestCallToLong.ticker = tickers{index};
    bestCallToLong.value = value_call_long;
else
    bestCallToLong.ticker = '';
    bestCallToLong.value = 0;
end

[value_put_long,index] = max(priceTable.UnderValuedDiff(PutIndexes));
if ~isempty(value_put_long) && value_put_long > 0
    tickers = tickerNames(PutIndexes);
    bestPutToLong.ticker = tickers{index};
    bestPutToLong.value = value_put_long;
else
    bestPutToLong.ticker = '';
    bestPutToLong.value = 0;
end

% disp(['bestCallToLong: ' bestCallToLong.ticker ' ' num2str(value_call_long)]);
% disp(['bestPutToLong: ' bestPutToLong.ticker ' ' num2str(value_put_long)]);
% disp(['bestCallToShort: ' bestCallToShort.ticker ' ' num2str(value_call_short)]);
% disp(['bestPutToShort: ' bestPutToShort.ticker ' ' num2str(value_put_short)]);


end

