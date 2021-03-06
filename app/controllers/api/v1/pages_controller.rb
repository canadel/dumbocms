class Api::V1::PagesController < Api::V1::ApiController

  defaults({
    :resource_class => Page,
    :collection_name => 'pages',
    :instance_name => 'page'
  })

  def index
    render :json => @account.pages.to_json(:include => { :template => { :except => [] }, :documents => { :methods => [:tpl, :cat, :links] }, :categories => {} } ), :callback => params[:callback]
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
       
	      page.account_id = @accound.id
        page.domain_id = domain.id
        
        page.save
      else
        page = domain.page || Page.where(:domain_id => domain.id).first
      end
    elsif !params[:page][:_package].nil?

        package_name = params[:page][:_package]
        params[:page].delete('_package')

        package = Package.where(:name => package_name).first

        if package
          params[:page][:template_id] = package.template.id

          page = Page.create(params[:page])
          
          domain = Domain.create({
            name: params[:page][:name],
            page_id: page.id,
            wildcard: 1
          })
          
	        page.account_id = @account.id
          page.domain_id = domain.id
          
          page.save

          package.presets.each do |p|

            if p.category_id
              category_template = Category.find(p.category_id)
              new_category = Category.create(:page_id => page.id, :name => category_template.name, :slug => category_template.slug)
              category_id = new_category.id
            else
              category_id = nil
            end

            doc = Document.create(:page_id => page.id, :title => p.title, :slug => p.slug, :content => p.content, :template_id => p.template_id, :category_id => category_id, :latitude => p.latitude, :longitude => p.longitude)
          end
        end
    else
      params[:page][:account_id] = @account.id
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
