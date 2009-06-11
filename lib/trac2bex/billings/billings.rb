module Trac2bex
  module Billings

    # Project Statecodes
    module ProjectStates
      Active = 1001
      Completed = 1002
      Cancelled = 1003
      Estimate = 1004
    end
    
    # Timeslip Typecodes
    module TimeslipTypes
      Timed = 101
      Flat = 102
      Quantity = 103
      Expense = 104
      Mileage = 105
    end
    
    # Timeslip Nature
    module TimeslipNatures
      Billable = 101
      MyEyesOnly = 103
    end
    
  end
end