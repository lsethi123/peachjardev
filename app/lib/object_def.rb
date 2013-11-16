class Time
    def as_json(options = {})
        strftime("%e %b %Y %H:%M")
    end
end

 class TrueClass
    def as_json(options = {})
        "true"
    end
end

 class FalseClass
    def as_json(options = {})
        "false"
    end
end

class Object

    def nil!
        !self.nil?
    end

 end

class NilClass

    # def method_missing(meth, *args, &block)
    #     nil
    # end

    def empty?
        true
    end
end


def helper
    Helper.instance
end

class Hash

    def filter(a)
        self.reject {|k,v| !a.include?(k)}
    end
     def to_url
        Rails.application.routes.url_helpers.url_for(self.merge({:only_path=>true}))
    end
      

    def from_keys(*keys)
        selected_values = self.values_at(*keys)
        selected_key_values = keys.zip(selected_values)
        Hash[*selected_key_values.flatten]
    end
end

class String

    def bool?
        to_b
    end

    

     def to_b
        return true if self == true || self =~ (/(true|t|yes|y|1)$/i)
        return false if self == false || self.blank? || self =~ (/(false|f|no|n|0)$/i)
        raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
    end

    def to_url
        # Rails.application.routes.url_helpers.url_for(self)
        self
    end
    
end

