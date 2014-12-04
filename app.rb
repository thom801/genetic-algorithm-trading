require 'rubygems'
require 'pp'
require_relative 'simulation'
require_relative 'strategy'

POPULATION_SIZE = 10
MUTATION_RATE = 0.05

class Population
	attr_accessor :members

	def initialize
		# create a new members array
		@members = []

		# create the initial population
		POPULATION_SIZE.times do |i|
			newStrategy = Strategy.new
			i.times { newStrategy.mutate }
			@members.push(newStrategy)
		end
	end 
end

def init
	$population = Population.new

	run_simulations()
end
	
def run_simulations
	$population.members.each do |strategy|
		# Run a simulation using the current strategy.
		Simulation.new(strategy)
	end
end

init()
