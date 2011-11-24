require 'enumerator'

module Finance
	class IIF
		def initialize(filename)
			@headings = {}
			if block_given?
				File.open(filename) do |fh|
					@fh = fh
					yield self
				end
			else
				@fh = File.open(filename)
			end 
		end

		def each
			if block_given?
				@fh.each_line do |l|
					f = l.strip.split("\t")
					type = f.shift
					if type[0] == ?!
						@headings[type[1..-1]] = f
					else
						yield({:type => type, :data => Hash[*@headings[type].zip(f).flatten]})
					end
				end
			else
				return new Enumerable::Enumerator(self, :each)
			end
		end
	end
end
