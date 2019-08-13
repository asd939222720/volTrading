function [tickerToBuy,tickerToSell] = SpreadPair(priceTable)

tickerNames = priceTable.Properties.RowNames;

thredhold = 0.0;

[value_long,index] = max(priceTable.UnderValuedDiff);
if value_long > thredhold
    bestLongOption = tickerNames{index};
else
    bestLongOption  = '';
end
    
[value_short,index] = max(priceTable.UnderValuedDiff);
if value_short > thredhold
    bestShortOption = tickerNames{index};
else
    bestShortOption = '';
end

tickerToBuy = {};
tickerToSell = {};

if value_long > value_short && ~isempty(bestLongOption)
    tickerToBuy{end+1} = bestLongOption;
    tickerToSell{end+1} = 'RTM';
elseif value_short >= value_long && ~isempty(bestShortOption)
    tickerToSell{end+1} = bestShortOption;
    tickerToBuy{end+1} = 'RTM';
end

disp('Open Spread:');
for i = 1:length(tickerToBuy)
    disp(['Buy ' tickerToBuy{i} '; Sell ' tickerToSell{i}]);
end

end

