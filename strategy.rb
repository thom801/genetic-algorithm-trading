# Starting strategy parameters
BUY_VOLUME = 300
SELL_VOLUME = 300
BUY_VELOCITY = 2
SELL_VELOCITY = -1

class Strategy
	attr_accessor :parameters, :score, :num_trades, :trade_history, :final_assets

	def initialize(parents=nil)

		# default starting parameters.
		@parameters = {
			buyVolume: BUY_VOLUME,
			sellVolume: SELL_VOLUME,
			buyVelocity: BUY_VELOCITY,
			sellVelocity: SELL_VELOCITY
		}

		if parents
			parent1 = parents[0].parameters
			parent2 = parents[1].parameters

			@parameters.each do |key, value|
				@parameters[key] = ((parent1[key] + parent2[key]) / 2).round(2)
			end

			mutate!
		end

		@score = nil
		@num_trades = nil
		@trade_history = nil
		@final_assets = nil
	end

	def mutate!
		# Loop over each parameter and mutate it.
		@parameters.each do |key, value|
			direction = rand > 0.5 ? 1 : -1
			mutation_rate = MUTATION_MAX_RATE * rand()
			newValue = (value + (direction * mutation_rate * value)).round(2)
			@parameters[key] = newValue
		end
	end
end