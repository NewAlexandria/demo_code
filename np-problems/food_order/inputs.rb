module FoodOrderInputs

  def self.included base
    #base.send :include, InstanceMethods
    base.extend ClassMethods
  end

	module ClassMethods
    # It would be ideal to do some 'type' checking here on the input
    # We assume things are in USD$, and have two decimals of precision.
    def menu_parse filename
      raw = File.open(filename).
        readlines.map(&:strip).   		# prep lines
        reject(&:empty?).        		  # no empty ones
        map(&:gsub.with(/[$.]/,'')).	# assume $ and integer-ize
        map(&:split.with(","))  		  # give implicit key-val pairs

      items = raw[1..-1].map {|i| Hash[*i] }
      return raw[0][0].to_i, items
    end
  end
end
