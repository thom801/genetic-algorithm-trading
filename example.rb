require 'rubygems'
require 'darwinning'

class Triple < Darwinning::Organism

	@name = 'Triple'
	@genes = [
		Darwinning::Gene.new("first", (0..100)),
		Darwinning::Gene.new("second", (0..100)),
		Darwinning::Gene.new("third", (0..100)),
		Darwinning::Gene.new("fourth", (0..100)),
		Darwinning::Gene.new("fifth", (0..100)),
	]

	def fitness
		(genotypes.inject{ |sum, x| sum + x } - 354).abs
	end
end

p = Darwinning::Population.new(Triple, 5, 0, 0.2, 5000)
p.evolve!

p.best_member.nice_print