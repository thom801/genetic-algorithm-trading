require 'rubygems'
require 'pp'
require 'market_beat'
require_relative 'simulation'
require_relative 'strategy'
require_relative 'population'

# Genetic parameters
POPULATION_SIZE = 10
MUTATION_RATE = 0.20
NUM_GENERATIONS = 10000
BREEDING_POPULATION_SIZE = 6

# Simulation parameters
STARTING_CASH = 10000
START_DATE = Date.new(2013,1,1)
END_DATE = Date.new(2013,12,31)
VELOCITY_DECAY = 1.2 # Must be greater than 1

DECIMAL_PRECISION = 2
COST_PER_TRADE = 6.0

STOCK_SYMBOLS = [
	# "TSLA", 
	# "SCTY", 	
	"ETG", 
	"GT", 
	"FTR", 
	"TDC",
	"JCP",
	"FSLR",
	# "PLUG",
	"SPWR",
	"ENPH",
]

$stock_quotes = {}

# Grab stock quotes within the date range for each stock symbol and store it.
STOCK_SYMBOLS.each do |stock_symbol|
	current_stock = MarketBeat.quotes(stock_symbol.to_sym, START_DATE.to_s, END_DATE.to_s).reverse!
	previous_close = nil
	velocity = 0

	current_stock.each do |quote|

		current_close = quote[:close].to_f

		if previous_close
			# measure the change percent since previous day close
			change = (current_close - previous_close).round(2)
			change_percent = (change / previous_close * 10).round(DECIMAL_PRECISION)

			# apply velocity decay and store in daily quote
			decayed_velocity = velocity / VELOCITY_DECAY
			velocity = (decayed_velocity + change_percent).round(DECIMAL_PRECISION)
		end

		quote[:close] = quote[:close].to_f.round(2)
		quote[:velocity] = velocity.round(DECIMAL_PRECISION)
		previous_close = current_close
	end

	$stock_quotes[stock_symbol] = current_stock
end

DAYS_TO_SIMULATE = $stock_quotes[STOCK_SYMBOLS[0]].length

NUM_GENERATIONS.times do |generation|
	puts "Generation #{generation + 1}"

	if !$population
		$population = Population.new
	else
		# puts generation
	end

	$population.members.each do |strategy|
		if strategy.score.nil?
			simulation = Simulation.new(strategy)
			strategy.score = (simulation.final_assets - STARTING_CASH).round(2)
			strategy.num_trades = simulation.num_trades
			strategy.trade_history = simulation.trade_history
		end
	end

	# $population.members.each do |member|
	# 	puts member.score
	# end

	puts $population.members[0].score

	$population.evolve!

	puts ' '
end

pp $population.members[0]





