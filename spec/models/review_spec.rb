require 'spec_helper' 
 
 describe Review do
  it {should have_searchable_field(:content)} 
 end
