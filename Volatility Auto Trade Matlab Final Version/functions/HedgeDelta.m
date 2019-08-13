function currentPositions = HedgeDelta(rit, delta, currentPositions)

transactionLimit = 10000;
amountToBuy = -delta;
for i = 1:7
    if abs(amountToBuy) < 1
        break;
    end
    try
        amount = min(transactionLimit, abs(amountToBuy));
        amount = round(amount);
        if amountToBuy < 0
            amount = -amount;
        end
        tradeID = buy(rit, 'RTM' , amount);
%         update(rit);
        currentPositions.Data('RTM') = currentPositions.Data('RTM') + amount;
        amountToBuy = amountToBuy - amount;        
%         disp(['Trade Succes. ID: ' num2str(tradeID)]);
    catch e
        disp(['Trade Fail. Error: ' e]);
    end
end

disp(['Delta hedged']);

end

