class Population
	attr_accessor :members

	def initialize
		# create a new members array
		@members = []

		# create the initial population
		POPULATION_SIZE.times do |i|
			newStrategy = Strategy.new
			# Create slightly different members each time
			i.times { newStrategy.mutate! }
			@members.push(newStrategy)
		end
	end

	def evolve!

		# sort by score ascending
		@members.sort_by! do |strategy|
			strategy.score
		end

		# trim the population down to the ones to breed
		@members = @members.drop(@members.length - BREEDING_POPULATION_SIZE)


		# Add new members to the population that are bred from the best.
		(POPULATION_SIZE - BREEDING_POPULATION_SIZE).times do

			parent1 = @members[rand(@members.length - 1)]
			parent2 = @members[rand(@members.length - 1)]
			strategy = Strategy.new([parent1, parent2])

			@members.push strategy
		end

		# pp @members
	end
end