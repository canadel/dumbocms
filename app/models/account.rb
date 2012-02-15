require 'pathname'

class Account < ActiveRecord::Base
  include SimplestAuth::Model
  authenticate_by :email

  include Cms::Base

  define_value :api_key, -> { SecureRandom.hex(16) }
  define_value :synced_templates_at, -> { Time.now }
  define_default :role, 'owner'
  define_value :role, 'owner'
  define_enum :role, %w{owner} # TODO: writer designer}
  define_name :email, uniqueness: true
  define_has_many %w{pages rewriters templates}, dependent: :destroy
  define_has_many %w{documents}, through: :pages
  define_parent :company
  define_timezone :timezone
  define_default :timezone, -> { self.company.try(:timezone) || 'Europe/Berlin' }
  define_default :super_user, false
  
  has_paper_trail ignore: :synced_templates_at

  validates :company, associated: true, presence: true

  default_scope alphabetically()
  
  class << self
    # Return a FTP path for accounts.
    def templates_path
      Rails.configuration.dumbocms.templates_path
    end
    
    # Sync all accounts.
    def sync!
      all.map {|account| account.sync! rescue nil}
      true
    end
    
    # Return a PureFTP response.
    #
    # http://download.pureftpd.org/pub/pure-ftpd/doc/README.Authentication-Modules
    def ftp_auth
      ([]).tap do |ret|
        email, password = ENV['AUTHD_ACCOUNT'], ENV['AUTHD_PASSWORD']
        account = Account.authenticate(email, password)

        if account
          dir = account.templates_path
          uid = Rails.configuration.dumbocms.ftp["uid"]
          gid = Rails.configuration.dumbocms.ftp["gid"]

          if dir.present?
            # OK.
            ret << "auth_ok:1"
            ret << "uid:#{uid}"
            ret << "gid:#{gid}"
            ret << "dir:#{dir}"
          else
            # Something really wrong.
            ret << "auth_ok:\-1"
          end
        else
          # Invalid password.
          ret << "auth_ok:0"
        end

        # ret << "slow_tilde_expansion:0"
        ret << 'end'
        ret << nil
      end.join("\n")
    end
  end

  # Return a FTP path for templates for this account.
  #
  # Return /./ to ensure chroot with PureFTPd.
  #
  # http://download.pureftpd.org/pub/pure-ftpd/doc/README.Authentication-Modules
  def templates_path
    return nil if self.id.blank?
    
    "#{Account.templates_path}./#{self.id}".tap do |path| # TODO strp

      # Create the directory if does not exist.
      # FIXME HARDCODED assets and templates locations, matt@prayam.com
      [path, [path, '/assets'].join, [path, '/templates'].join].each do |localPath|
        Dir.mkdir(localPath) unless File.exists?(localPath)
      end
      
      # Return the path. # TODO remove
      path
    end
  end
  
  # Sync an account with the filesystem.
  def sync!
    sync_create_or_update!
    sync_destroy!
    true
  end
  
  protected
    def sync_create_or_update!(path=nil)
      path ||= self.templates_path
    
      Dir.foreach(path) do |name|
        next if name =~ /^\./ # skip hidden
        
        ph = File.expand_path(name, path)
        ft = File.ftype(ph)
        
        case ft
        # when 'directory'
        #   # TODO: Store the full path in the templates.
        #   sync_create_or_update!(ph)
        when 'file'
          if Template.extensions.include?(File.extname(name))
            content = File.read(ph)
            
            # Haiku
            template = self.templates.find_by_name(name)
            template ||= self.templates.build(name: name)
            template.name = name
            template.content = content
            template.save
          end
        end
      end
      
      true
    end
    
    def sync_destroy!
      self.templates.each do |template|
        next if File.exists?(template.path)

        template.destroy rescue nil
      end
      
      true
    end
end
