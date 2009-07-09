# deliberately eschewing monkey business in favour of old school inheritance
module Trac2bex
  class OpenStructWithId < OpenStruct
    def id
      if @table.has_key?(:id)
        @table[:id]
      elsif @table.has_key?("id")
        @table["id"]
      else
        super
      end
    end
  end
end