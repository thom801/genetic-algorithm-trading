class Simulation
	def initialize(strategy)
		@strategy = strategy
		puts "Simulation started with strategy #{@strategy.inspect}"
	end
end