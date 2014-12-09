
class Simulation
	attr_reader :num_trades, :trade_history

	def initialize(strategy)
		@strategy = strategy
		@shares = {}
		@cash = STARTING_CASH.to_i
		@num_trades = 0
		@trade_history = []

		STOCK_SYMBOLS.each do |stock_symbol|
			@shares[stock_symbol.to_sym] = 0
		end

		# puts "Simulation started with strategy #{@strategy.inspect}"

		DAYS_TO_SIMULATE.times do |day|

			# puts "Day #{day + 1}"

			$stock_quotes.each do |stock_symbol, quote|
				position = quote[day]
				velocity = position[:velocity]
				tradeDirection = nil

				if velocity > @strategy.parameters[:buyVelocity]
					tradeDirection = 1
					tradeVerb = 'BUY'
				end

				if velocity < @strategy.parameters[:sellVelocity]
					tradeDirection = -1
					tradeVerb = 'SELL'
				end

				if tradeDirection
					tradeAction = (@strategy.parameters[:buyVolume] / position[:close]).round(2)
      		trade stock_symbol, position, tradeAction

      		@trade_history.push "#{tradeVerb} #{stock_symbol}. Velocity at: #{velocity}. Action: #{tradeAction}. Date: #{position[:date]}"
				end
			end
		end
	end

	def final_assets
		total = @cash
		@shares.each do |stock_symbol, num_shares|
			current_value = $stock_quotes[stock_symbol.to_s][DAYS_TO_SIMULATE - 1][:close]
			total += num_shares * current_value
		end

		total -= @num_trades * COST_PER_TRADE

		return total.round(2)
	end

	def trade(stock_symbol, position, tradeAction)
		tradeCost = (tradeAction * position[:close]).round(2)
		@num_trades += 1

		shares = @shares[stock_symbol.to_sym]

    # If we don't have enough money to complete the suggested trade.
    if @cash - tradeCost < 0
      tradeAction = @cash / position[:close]
    end	

    # If we don't have enough stocks to complete the suggested trade.
    if shares + tradeAction < 0
      tradeAction = shares * -1
    end

    tradeCost = (tradeAction * position[:close]).round(2)

    # Keep track of our shares and cash
    @shares[stock_symbol.to_sym] = (shares + tradeAction).round(2)
    @cash = (@cash - tradeCost).round(2)

    # Make sure we aren't cheating
    if shares < 0
      log shares
      raise 'Shares cannot be negative!'
    end

    if @cash < 0
      if @cash > -0.01
        @cash = 0
      else
        raise 'You can\'t use money you don\'t have... What do you think this is, America?!'
      end
    end
	end
end