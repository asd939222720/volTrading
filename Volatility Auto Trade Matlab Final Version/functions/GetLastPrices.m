function [pricesList, tick] = GetLastPrices(rit,tickerNames)

ticksInOnePeriod = 600;

pricesList = nan(size(tickerNames));
for i = 1 : length(tickerNames)
    pricesList(i) = rit.(tickerNames{i});
end

tick = double(ticksInOnePeriod - rit.timeRemaining);

disp('');

disp(['=== TICK ' num2str(tick) '===']);
disp(['RTM: ' num2str(pricesList(1)) ]);

end

