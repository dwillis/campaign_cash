%w(base candidate committee contribution filing form independent_expenditure president).each do |f|
  require File.join(File.dirname(__FILE__), '../lib/campaign_cash', f)
end