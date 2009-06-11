require 'plist'

module Trac2bex
  module Billings
    class TimeslipArray
      attr_accessor :array
      
      def initialize(array)
        @array = array
      end
      
      def to_plist
        wrapper = {
          "entityName" => "TimeSlip",
          "objects" => array
        }
        Plist::Emit.dump(wrapper, true)
      end
      
    end
  end
end