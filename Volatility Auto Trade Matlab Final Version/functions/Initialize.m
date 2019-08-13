function [rit, tickers, tickerVarNames, newsVarNames, positionVarNames] = Initialize()


installRIT;

rit = rotmanTrader;
rit.updateFreq = 1;
if strcmp(rit.traderName, 'TRADERNAME')
    error('Fail to connetct tod RIT Client!');
end

tickers = rit.allTickers';

ts = cell(length(tickers),1);
tickerVarNames = cell(length(tickers),1);


try
    topics = getSubscriptions(rit);
    unsubscribe(rit, topics.ID);
catch e
%     disp(e);
end

% Subscribe last prices
for i = 1:length(tickers)
    ticker = tickers{i};

    
    subscriptionName = [ticker '|last'];
    tickerVarNames{i} = [lower(ticker) '_last'];
    subscribe(rit,subscriptionName);
      
    ts{i} = timeseries(nan(600,1),(1:600)','Name',ticker);
end

tscHistoryPrices = tscollection(ts);
tscHistoryPrices.Name = 'History Prices';

% Subcribe news
newsNumber = 8;
newsVarNames = cell(newsNumber,1);
for i = 1:newsNumber
   subscriptionName = ['NEWS|' num2str(i)];
   newsVarNames{i} = ['news_' num2str(i)];
   subscribe(rit, subscriptionName);
end

% Subscribe positions
positionVarNames = cell(size(tickers));
for i = 1:length(tickers)
    ticker = tickers{i};

    
    subscriptionName = [ticker '|POSITION'];
    positionVarNames{i} = [lower(ticker) '_position'];
    subscribe(rit,subscriptionName);
end

end

