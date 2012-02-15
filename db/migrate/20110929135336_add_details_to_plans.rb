class AddDetailsToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :trial_length, :integer
    add_column :plans, :trial_credit_card, :boolean
    add_column :plans, :billing_day_of_month, :integer
    add_column :plans, :billing_price, :integer
  end

  def self.down
    remove_column :plans, :billing_price
    remove_column :plans, :billing_day_of_month
    remove_column :plans, :trial_credit_card
    remove_column :plans, :trial_length
  end
end
