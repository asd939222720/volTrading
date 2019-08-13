function newsInfo = GetNewsInfo(rit, newsVarNames, newsInfo)

if nargin > 2
    lastGotNewsIndex = newsInfo.lastNewsIndex;
else
    lastGotNewsIndex = 0;
end

N = length(newsVarNames);
news = cell(N,1);
for i = 1:N
    thisNews = rit.(newsVarNames{i});
    if ~strcmp(thisNews(1:5),'NEWS|')
        news{i} = thisNews;
    else        
        break;
    end  
    lastNewsIndex = i;
end

if lastNewsIndex > lastGotNewsIndex
    if nargin > 2
        newsInfo = AnalysisNews(news(lastGotNewsIndex+1:lastNewsIndex), newsInfo);
    else
        newsInfo = AnalysisNews(news(lastGotNewsIndex+1:lastNewsIndex));
    end
    newsInfo.lastNewsIndex = lastNewsIndex;
    
    disp(['Got News ' num2str(lastNewsIndex)]);
    disp(['Interest Rate: ' num2str(newsInfo.interestRate)] );
    disp(['Delta Limit: ' num2str(newsInfo.deltaLimit)] );
    disp('Volatility Info:');
    disp(newsInfo.volatility);
end

end

