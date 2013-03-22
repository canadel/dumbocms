class Api::V1::PagesController < Api::V1::ApiController

  defaults({
    :resource_class => Page,
    :collection_name => 'pages',
    :instance_name => 'page'
  })

  def index
    render :json => @account.pages.to_json(:include => { :template => { :except => [] }, :documents => { :methods => :tpl } } ), :callback => params[:callback]
  end

  def show
    render :json => Page.where(:id => params[:id], :account_id => @account.id), :callback => params[:callback]
  end

  def create
    if !params[:page][:_with_domain].nil?
      domain = Domain.where(:name => params[:page][:name]).first

      unless domain
        params[:page].delete('_with_domain')
        
        page = Page.create(params[:page])

        domain = Domain.create({
          name: params[:page][:name],
          page_id: page.id,
          wildcard: 1
        })
        
        page.domain_id = domain.id
        
        page.save
      else
        page = domain.page || Page.where(:domain_id => domain.id).first
      end
    elsif !params[:page][:_package].nil?

        packages = {}

        packages['auc'] = {
          'template_id' => 48,
          'documents' => [
            {
              'template_id' => 45,
              'slug' => 'internet',
              'title' => 'Internet'
            },
            {
              'template_id' => 45,
              'slug' => 'overview',
              'title' => 'Overview'
            },
            {
              'template_id' => 45,
              'slug' => 'solar',
              'title' => 'Solar'
            }
          ]
        }

        packages['shift'] = {
          'template_id' => 95,
          'documents' => [
            {
              'template_id' => 94,
              'slug' => 'contant',
              'title' => 'Contact & Impressum'
            }
          ]
        }

        Rails.logger.warn packages.inspect


        package = params[:page][:_package]
        params[:page].delete('_package')

        unless packages[package].nil?
          params[:page][:template_id] = packages[package]['template_id']

          page = Page.create(params[:page])
          
          domain = Domain.create({
            name: params[:page][:name],
            page_id: page.id,
            wildcard: 1
          })
          
          page.domain_id = domain.id
          
          page.save

          packages[package]['documents'].each do |d|
            doc = Document.create(:page_id => page.id, :title => d['title'], :slug => d['slug'], :content => 'Created with EasyCreate')
          end
        end
    else
      page = Page.create(params[:page])
    end

    render :json => page
  end

  def update
    page = Page.where(:id => params[:id], :account_id => @account.id).first
  
    if page
      # page.title = params[:page][:title] if params[:page][:title]
      # page.description = params[:page][:description] if params[:page][:description]
      # page.domain_id = params[:page][:domain_id] if params[:page][:domain_id]
      # page.save
      page.update_attributes(params[:page])
    end

    render :json => page
  end

private

  def allowed_params
    %w(account_id name title template_id description indexable)
  end

end
