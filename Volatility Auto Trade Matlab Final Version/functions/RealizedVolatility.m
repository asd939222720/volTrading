function vol = RealizedVolatility(newsInfo, tick)

ticksInOneWeek = 150;

week = ceil(tick / ticksInOneWeek);

vol = newsInfo.volatility.realizedVolatility(week);

end

