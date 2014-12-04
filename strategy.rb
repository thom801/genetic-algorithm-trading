class Strategy
	attr_accessor :parameters

	def initialize
		
		@parameters = {
			buySize: 100,
			sellSize: 100,
			buyVelocity: 2,
			sellVelocity: 2
		}
	end

	def mutate
		# Loop over each parameter and mutate it.
		@parameters.each do |key, value|
			direction = rand > 0.5 ? 1 : -1
			newValue = (value + (direction * MUTATION_RATE * value)).round(2)
			@parameters[key] = newValue
		end
	end
end