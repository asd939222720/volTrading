function myPositionManagementStrategy(input)
%% My Position Management Strategy
% simple strategy that keeps inventory of all tickers to 0.   It reverse
% any open positions in blocks of 5k shares ore fewer.
%
% Input is a |rotmanTrader| object, make sure we have subscribed to all
% ticker symbols with position to use this function.
%
%   Example:
%   rit = rotmanTrader;
%   subscribe(rit,{'CRZY|POSITION';'TAME|POSITION'})
%   fcn = @(input) myPositionManagementStrategy(input);
%   addUpdateFcn(rit,fcn)

% Copyright 2018 The MathWorks, Inc.

for t = 1:length(input.allTickers)
    position = input.([lower(input.allTickers{t}),'_position']);
    if position ~= 0
        if abs(position) < 5000
            shares = abs(position);
        else
            shares = 5000;
        end
        buy(input,input.allTickers{t},-sign(position)*shares);
    fprintf('Selling %d shares of %s \n',-sign(position)*shares,input.allTickers{t});
    end
end