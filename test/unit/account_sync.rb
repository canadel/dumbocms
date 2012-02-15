require 'test_helper'

class AccountRepoTest < ActiveSupport::TestCase
  def setup
    # Ensure we do not create mess everywhere.
    @templates_path = File.expand_path('../../tmp/templates/', __FILE__)
    @templates_path = "#{@templates_path}/" # FIXME
    Rails.configuration.dumbocms.templates_path = @templates_path

    # Ensure that the directory exists.
    Dir.mkdir(@templates_path) unless File.exists?(@templates_path)

    @account = FactoryGirl.build(:account)
  end
  
  test("setup") do
    assert(@templates_path.present?, 'Templates path should be set.')
  end

  test("class templates_path") do
    assert_equal @templates_path, Account.templates_path
  end
  test("instance templates_path") do
    a = FactoryGirl.create(:account)
    assert_equal "#{@templates_path}./#{a.id}", a.templates_path
  end
  test("instance templates_path new_record?") do
    assert @account.templates_path.nil?
  end
  
  test("ftp_auth wrong") do
    ENV['AUTHD_ACCOUNT'], ENV['AUTHD_PASSWORD'] = 'wrong', 'wrong'
    
    expected = []
    expected << "auth_ok:0"
    expected << "end"
    expected << nil
    
    ret = Account.ftp_auth
    assert_equal expected.join("\n"), ret
    
    ENV['AUTHD_ACCOUNT'], ENV['AUTHD_PASSWORD'] = nil, nil
  end
  test("ftp_auth correct") do
    a = FactoryGirl.create(:account)
    a.email = 'maurycy@localhost'
    a.password = a.password_confirmation = 'dupa123'
    a.save!
    
    ENV['AUTHD_ACCOUNT'], ENV['AUTHD_PASSWORD'] = a.email, 'dupa123'
    
    expected = []
    expected << "auth_ok:1"
    expected << "uid:1001"
    expected << "gid:1001"
    expected << "dir:#{a.templates_path}"
    expected << "end"
    expected << nil
    
    ret = Account.ftp_auth
    assert_equal expected.join("\n"), ret
    
    ENV['AUTHD_ACCOUNT'], ENV['AUTHD_PASSWORD'] = nil, nil
  end
end