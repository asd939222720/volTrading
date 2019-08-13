function trades = CloseStratedgy(positionInfo,priceTable)

CloseThreshold = 0.03;
AmountPerSecond = 100;

trades(1).Ticker = '';
trades(1).BuyOrSell = 'Buy';
trades(1).Amount = 0;
trades(1).Weight = 0;


openPositions = positionInfo.Positions(positionInfo.Positions.Data~=0,:);
for i = 1:length(openPositions.Data)
    ticker = openPositions.Properties.RowNames{i};
    position = openPositions.Data(i);
    
    if position > 0 && priceTable.OverValuedDiff(ticker) > CloseThreshold 
        trades(end+1).Ticker = ticker;
        trades(end).BuyOrSell = 'Sell';
        trades(end).Amount = position;
        trades(end).Weight = 1;
    elseif position < 0 && priceTable.UnderValuedDiff(ticker) > CloseThreshold
        trades(end+1).Ticker = ticker;
        trades(end).BuyOrSell = 'Buy';
        trades(end).Amount = abs(position);
        trades(end).Weight = 1;
    end
end
%% Between Options
openIndex = positionInfo.Positions.Data~=0;
Diff = priceTable.DiffFromAverage;
Diff(~openIndex) = NaN;
Diff(1) = NaN;
[maxDiff, indMax] = max(Diff);
[minDiff, indMin] = min(Diff);
if maxDiff - minDiff < 0.05 && indMax~=1 && indMin~=1 && indMax~=indMin && positionInfo.Positions.Data(indMax)<0 && positionInfo.Positions.Data(indMin)>0
    trades(end+1).Ticker = priceTable.Properties.RowNames{indMax};
    trades(end).BuyOrSell = 'Buy';
    trades(end).Amount = min(AmountPerSecond,abs(positionInfo.Positions.Data(indMax)));
    trades(end).Weight = 1;
    trades(end+1).Ticker = priceTable.Properties.RowNames{indMin};
    trades(end).BuyOrSell = 'Sell';
    trades(end).Amount = min(AmountPerSecond,abs(positionInfo.Positions.Data(indMin)));
    trades(end).Weight = 1;    
end


if maxDiff - minDiff >= 0 && indMax~=1 && indMin~=1 && indMax~=indMin && positionInfo.Positions.Data(indMax)>0 && positionInfo.Positions.Data(indMin)<0
    trades(end+1).Ticker = priceTable.Properties.RowNames{indMax};
    trades(end).BuyOrSell = 'Sell';
    trades(end).Amount = min(AmountPerSecond,abs(positionInfo.Positions.Data(indMax)));
    trades(end).Weight = 1;
    trades(end+1).Ticker = priceTable.Properties.RowNames{indMin};
    trades(end).BuyOrSell = 'Buy';
    trades(end).Amount = min(AmountPerSecond,abs(positionInfo.Positions.Data(indMin)));
    trades(end).Weight = 1;    
end

%%
trades = trades(2:end);

for trade = trades
    disp(['CLOSE:' trade.Ticker ' ' trade.BuyOrSell ' ' num2str(trade.Amount)]);
end

end

