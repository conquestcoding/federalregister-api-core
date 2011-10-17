# == Schema Information
#
# Table name: entry_cfr_references
#
#  id       :integer(4)      not null, primary key
#  entry_id :integer(4)
#  title    :integer(4)
#  part     :integer(4)
#  chapter  :integer(4)
#

class EntryCfrReference < ApplicationModel
  belongs_to :entry
end
